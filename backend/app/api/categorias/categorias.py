from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func
from app.core.database import get_db
from app.models.programacion import PoliticaProgramacion as PoliticaProgramacionModel
from app.models.categorias import Categoria
from app.schemas.categorias import CategoriaCreate, CategoriaUpdate, Categoria as CategoriaSchema
from typing import List

router = APIRouter()

# Categorías endpoints
@router.get("/categorias")
async def get_categorias(db: Session = Depends(get_db)):
    """Obtener todas las categorías activas"""
    categorias = db.query(Categoria).filter(Categoria.activa == True).all()
    return {
        "categorias": [categoria.nombre for categoria in categorias],
        "total": len(categorias)
    }

# CRUD de Categorías
@router.get("/categorias/items", response_model=list[CategoriaSchema])
async def list_categorias(db: Session = Depends(get_db)):
    return db.query(Categoria).order_by(Categoria.nombre.asc()).all()

@router.post("/categorias", response_model=CategoriaSchema)
async def create_categoria(payload: CategoriaCreate, db: Session = Depends(get_db)):
    db_cat = Categoria(
        difusora=payload.difusora,
        clave=payload.clave,
        nombre=payload.nombre,
        descripcion=payload.descripcion,
        activa=payload.activa
    )
    db.add(db_cat)
    db.commit()
    db.refresh(db_cat)
    return db_cat

@router.put("/categorias/{categoria_id}", response_model=CategoriaSchema)
async def update_categoria(categoria_id: int, payload: CategoriaUpdate, db: Session = Depends(get_db)):
    cat = db.query(Categoria).filter(Categoria.id == categoria_id).first()
    if not cat:
        raise HTTPException(status_code=404, detail="Categoría no encontrada")
    data = payload.model_dump(exclude_unset=True)
    for k, v in data.items():
        setattr(cat, k, v)
    db.commit()
    db.refresh(cat)
    return cat

@router.delete("/categorias/{categoria_id}")
async def delete_categoria(categoria_id: int, db: Session = Depends(get_db)):
    cat = db.query(Categoria).filter(Categoria.id == categoria_id).first()
    if not cat:
        raise HTTPException(status_code=404, detail="Categoría no encontrada")
    db.delete(cat)
    db.commit()
    return {"ok": True}

@router.get("/categorias/{categoria_id}/elementos")
async def get_elementos_categoria(categoria_id: int, db: Session = Depends(get_db)):
    from app.models.categorias import Cancion
    canciones = db.query(Cancion).filter(Cancion.categoria_id == categoria_id).all()
    # respuesta mínima
    return [
        {
            "id": c.id,
            "titulo": c.titulo,
            "artista": c.artista,
            "album": c.album,
            "duracion": c.duracion
        }
        for c in canciones
    ]

@router.post("/movimientos/mover")
async def mover_canciones(
    origen_id: int,
    destino_id: int,
    canciones_ids: List[int],
    db: Session = Depends(get_db)
):
    """Mover canciones seleccionadas de una categoría a otra."""
    from app.models.categorias import Cancion
    if origen_id == destino_id:
        raise HTTPException(status_code=400, detail="La categoría de origen y destino no pueden ser la misma")
    # Validar que existan categorías
    if not db.query(Categoria).filter(Categoria.id == origen_id).first():
        raise HTTPException(status_code=404, detail="Categoría de origen no encontrada")
    if not db.query(Categoria).filter(Categoria.id == destino_id).first():
        raise HTTPException(status_code=404, detail="Categoría de destino no encontrada")
    # Actualizar en bulk
    updated = (
        db.query(Cancion)
        .filter(Cancion.id.in_(canciones_ids), Cancion.categoria_id == origen_id)
        .update({Cancion.categoria_id: destino_id}, synchronize_session=False)
    )
    db.commit()
    return {"moved": int(updated)}

# Listado con métricas: número de elementos y duración promedio
@router.get("/categorias/items-stats")
async def list_categorias_with_stats(db: Session = Depends(get_db)):
    from app.models.categorias import Cancion  # import local para evitar ciclos
    categorias = db.query(Categoria).order_by(Categoria.nombre.asc()).all()
    # Obtener métricas por categoria_id en una sola consulta
    metrics = (
        db.query(
            Cancion.categoria_id.label('categoria_id'),
            func.count(Cancion.id).label('num_elementos'),
            func.avg(Cancion.duracion).label('duracion_promedio'),
            func.sum(Cancion.duracion).label('duracion_total'),
            func.min(Cancion.duracion).label('duracion_min'),
            func.max(Cancion.duracion).label('duracion_max')
        )
        .group_by(Cancion.categoria_id)
        .all()
    )
    metrics_map = {m.categoria_id: {
        "num_elementos": int(m.num_elementos or 0),
        "duracion_promedio": int(m.duracion_promedio or 0),
        "duracion_total": int(m.duracion_total or 0),
        "duracion_min": int(m.duracion_min or 0),
        "duracion_max": int(m.duracion_max or 0),
    } for m in metrics}
    result = []
    for c in categorias:
        m = metrics_map.get(c.id, {
            "num_elementos": 0,
            "duracion_promedio": 0,
            "duracion_total": 0,
            "duracion_min": 0,
            "duracion_max": 0,
        })
        result.append({
            "id": c.id,
            "nombre": c.nombre,
            "descripcion": c.descripcion,
            "activa": c.activa,
            "created_at": c.created_at,
            "updated_at": c.updated_at,
            "num_elementos": m["num_elementos"],
            "duracion_promedio": m["duracion_promedio"],
            "duracion_total": m["duracion_total"],
            "duracion_min": m["duracion_min"],
            "duracion_max": m["duracion_max"],
        })
    return result

@router.get("/canciones/politica/{politica_id}/categorias")
async def get_categorias_politica(politica_id: int, db: Session = Depends(get_db)):
    """Obtener categorías guardadas para una política específica"""
    politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
    if not politica:
        raise HTTPException(status_code=404, detail="Política no encontrada")
    if not politica.categorias_seleccionadas:
        return {"categorias": [], "total": 0}
    # Almacenadas como ids separados por coma
    categorias_ids = [c.strip() for c in politica.categorias_seleccionadas.split(',') if c and c.strip()]
    return {"categorias": categorias_ids, "total": len(categorias_ids)}

@router.post("/canciones/politica/{politica_id}/categorias")
async def save_categorias_politica(politica_id: int, categorias: List[str], db: Session = Depends(get_db)):
    """Guardar categorías para una política específica"""
    politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
    if not politica:
        raise HTTPException(status_code=404, detail="Política no encontrada")
    # Normalizar: solo IDs/valores no vacíos, únicos, como texto separado por comas
    categorias_norm = [str(c).strip() for c in categorias if str(c).strip()]
    categorias_unicas = []
    for c in categorias_norm:
        if c not in categorias_unicas:
            categorias_unicas.append(c)
    politica.categorias_seleccionadas = ','.join(categorias_unicas)
    db.commit()
    db.refresh(politica)
    return {"message": "Categorías guardadas exitosamente", "politica_id": politica_id, "categorias": categorias_unicas}

@router.get("/categorias/mantenimiento")
async def get_mantenimiento_categorias(db: Session = Depends(get_db)):
    """Obtener mantenimiento de categorías"""
    return {"message": "Hello World - Mantenimiento de Categorías", "data": []}

@router.get("/categorias/movimientos")
async def get_movimientos_categorias(db: Session = Depends(get_db)):
    """Obtener movimientos entre categorías"""
    return {"message": "Hello World - Movimientos entre Categorías", "data": []}

# (Eliminados endpoints de Conjuntos)

# Canciones endpoints
@router.get("/canciones/mantenimiento")
async def get_mantenimiento_canciones(db: Session = Depends(get_db)):
    """Obtener mantenimiento de canciones"""
    return {"message": "Hello World - Mantenimiento de Canciones", "data": []}

@router.post("/canciones/importar-csv")
async def importar_csv_canciones(db: Session = Depends(get_db)):
    """Importar canciones desde CSV"""
    return {"message": "Hello World - Importar a CSV", "data": []}
