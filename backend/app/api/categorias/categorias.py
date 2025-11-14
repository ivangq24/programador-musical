from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func
from app.core.database import get_db
from app.core.auth import get_current_user, get_user_difusoras
from app.models.auth import Usuario
from app.models.programacion import PoliticaProgramacion as PoliticaProgramacionModel
from app.models.categorias import Categoria
from app.schemas.categorias import CategoriaCreate, CategoriaUpdate, Categoria as CategoriaSchema
from typing import List

router = APIRouter()

# Categorías endpoints
@router.get("/categorias")
async def get_categorias(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Obtener todas las categorías activas (solo de las difusoras del usuario) - Multi-tenancy"""
    query = db.query(Categoria).filter(Categoria.activa == True)
    
    # Filtrar por difusoras permitidas (aislamiento por organización)
    if difusoras_allowed:
        query = query.filter(Categoria.difusora.in_(difusoras_allowed))
    else:
        # Si no tiene difusoras asignadas, retornar lista vacía
        # Esto asegura el aislamiento por organización
        return {
            "categorias": [],
            "total": 0
        }
    
    categorias = query.all()
    return {
        "categorias": [categoria.nombre for categoria in categorias],
        "total": len(categorias)
    }

# CRUD de Categorías
@router.get("/categorias/items", response_model=list[CategoriaSchema])
async def list_categorias(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Listar categorías (solo de las difusoras del usuario y de su organización)"""
    query = db.query(Categoria)
    
    # Filtrar por difusoras permitidas (aislamiento estricto por organización)
    # NO permitir excepciones para admins - todos los usuarios deben tener difusoras asignadas
    if difusoras_allowed:
        query = query.filter(Categoria.difusora.in_(difusoras_allowed))
    else:
        # Si no tiene difusoras asignadas, retornar lista vacía
        # Esto asegura el aislamiento por organización
        return []
    
    # Verificar adicionalmente que las categorías pertenecen a la organización del usuario
    # Filtrar por difusoras que pertenecen a la organización del usuario
    from app.models.catalogos import Difusora
    if hasattr(usuario, 'organizacion_id') and usuario.organizacion_id:
        difusoras_org = db.query(Difusora.siglas).filter(
            Difusora.organizacion_id == usuario.organizacion_id,
            Difusora.siglas.in_(difusoras_allowed)
        ).all()
        difusoras_org_siglas = [d[0] for d in difusoras_org]
        if difusoras_org_siglas:
            query = query.filter(Categoria.difusora.in_(difusoras_org_siglas))
        else:
            return []
    
    return query.order_by(Categoria.nombre.asc()).all()

@router.post("/categorias", response_model=CategoriaSchema)
async def create_categoria(
    payload: CategoriaCreate, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Crear categoría (solo para difusoras del usuario y de su organización)"""
    # Verificar que el usuario tiene acceso a la difusora (aislamiento por organización)
    if not difusoras_allowed:
        raise HTTPException(
            status_code=403,
            detail="No tienes difusoras asignadas. Contacta a un administrador."
        )
    
    if payload.difusora not in difusoras_allowed:
        raise HTTPException(
            status_code=403,
            detail="No tienes permiso para crear categorías para esta difusora"
        )
    
    # Verificar que la difusora pertenece a la organización del usuario
    from app.models.catalogos import Difusora
    difusora_obj = db.query(Difusora).filter(
        Difusora.siglas == payload.difusora,
        Difusora.organizacion_id == usuario.organizacion_id
    ).first()
    if not difusora_obj:
        raise HTTPException(
            status_code=403,
            detail="La difusora no pertenece a tu organización"
        )
    
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
async def update_categoria(
    categoria_id: int, 
    payload: CategoriaUpdate, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Actualizar categoría (solo si pertenece a una difusora del usuario y de su organización)"""
    cat = db.query(Categoria).filter(Categoria.id == categoria_id).first()
    if not cat:
        raise HTTPException(status_code=404, detail="Categoría no encontrada")
    
    # Verificar que la categoría pertenece a una difusora permitida
    if not difusoras_allowed or cat.difusora not in difusoras_allowed:
        raise HTTPException(
            status_code=403,
            detail="No tienes permiso para modificar esta categoría"
        )
    
    # Verificar que la difusora pertenece a la organización del usuario
    from app.models.catalogos import Difusora
    difusora_obj = db.query(Difusora).filter(
        Difusora.siglas == cat.difusora,
        Difusora.organizacion_id == usuario.organizacion_id
    ).first()
    if not difusora_obj:
        raise HTTPException(
            status_code=403,
            detail="La categoría no pertenece a tu organización"
        )
    
    data = payload.model_dump(exclude_unset=True)
    
    # Si se está cambiando la difusora, verificar que la nueva difusora está permitida y pertenece a la organización
    if 'difusora' in data:
        if data['difusora'] not in difusoras_allowed:
            raise HTTPException(
                status_code=403,
                detail="No tienes permiso para asignar categorías a esta difusora"
            )
        nueva_difusora = db.query(Difusora).filter(
            Difusora.siglas == data['difusora'],
            Difusora.organizacion_id == usuario.organizacion_id
        ).first()
        if not nueva_difusora:
            raise HTTPException(
                status_code=403,
                detail="La difusora no pertenece a tu organización"
            )
    
    for k, v in data.items():
        setattr(cat, k, v)
    db.commit()
    db.refresh(cat)
    return cat

@router.delete("/categorias/{categoria_id}")
async def delete_categoria(
    categoria_id: int, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Eliminar categoría (solo si pertenece a una difusora del usuario y de su organización)"""
    cat = db.query(Categoria).filter(Categoria.id == categoria_id).first()
    if not cat:
        raise HTTPException(status_code=404, detail="Categoría no encontrada")
    
    # Verificar que la categoría pertenece a una difusora permitida
    if not difusoras_allowed or cat.difusora not in difusoras_allowed:
        raise HTTPException(
            status_code=403,
            detail="No tienes permiso para eliminar esta categoría"
        )
    
    # Verificar que la difusora pertenece a la organización del usuario
    from app.models.catalogos import Difusora
    difusora_obj = db.query(Difusora).filter(
        Difusora.siglas == cat.difusora,
        Difusora.organizacion_id == usuario.organizacion_id
    ).first()
    if not difusora_obj:
        raise HTTPException(
            status_code=403,
            detail="La categoría no pertenece a tu organización"
        )
    
    db.delete(cat)
    db.commit()
    return {"ok": True}

@router.get("/categorias/{categoria_id}/elementos")
async def get_elementos_categoria(
    categoria_id: int, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Obtener elementos de una categoría (solo si pertenece a una difusora del usuario y de su organización)"""
    categoria = db.query(Categoria).filter(Categoria.id == categoria_id).first()
    if not categoria:
        raise HTTPException(status_code=404, detail="Categoría no encontrada")
    
    # Verificar que la categoría pertenece a una difusora permitida
    if not difusoras_allowed or categoria.difusora not in difusoras_allowed:
        raise HTTPException(
            status_code=403,
            detail="No tienes permiso para acceder a esta categoría"
        )
    
    # Verificar que la difusora pertenece a la organización del usuario
    from app.models.catalogos import Difusora
    difusora_obj = db.query(Difusora).filter(
        Difusora.siglas == categoria.difusora,
        Difusora.organizacion_id == usuario.organizacion_id
    ).first()
    if not difusora_obj:
        raise HTTPException(
            status_code=403,
            detail="La categoría no pertenece a tu organización"
        )
    
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
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Mover canciones seleccionadas de una categoría a otra (solo entre categorías de las difusoras del usuario y de su organización)."""
    from app.models.categorias import Cancion
    from app.models.catalogos import Difusora
    
    if origen_id == destino_id:
        raise HTTPException(status_code=400, detail="La categoría de origen y destino no pueden ser la misma")
    
    # Validar que existan categorías y que pertenezcan a difusoras permitidas y a la organización del usuario
    categoria_origen = db.query(Categoria).filter(Categoria.id == origen_id).first()
    if not categoria_origen:
        raise HTTPException(status_code=404, detail="Categoría de origen no encontrada")
    
    # Verificar que la categoría de origen pertenece a una difusora permitida
    if categoria_origen.difusora not in difusoras_allowed:
        raise HTTPException(
            status_code=403,
            detail="No tienes permiso para acceder a la categoría de origen"
        )
    
    # Verificar que la difusora de origen pertenece a la organización del usuario
    difusora_origen = db.query(Difusora).filter(
        Difusora.siglas == categoria_origen.difusora,
        Difusora.organizacion_id == usuario.organizacion_id
    ).first()
    if not difusora_origen:
        raise HTTPException(
            status_code=403,
            detail="La categoría de origen no pertenece a tu organización"
        )
    
    categoria_destino = db.query(Categoria).filter(Categoria.id == destino_id).first()
    if not categoria_destino:
        raise HTTPException(status_code=404, detail="Categoría de destino no encontrada")
    
    # Verificar que la categoría de destino pertenece a una difusora permitida
    if categoria_destino.difusora not in difusoras_allowed:
        raise HTTPException(
            status_code=403,
            detail="No tienes permiso para acceder a la categoría de destino"
        )
    
    # Verificar que la difusora de destino pertenece a la organización del usuario
    difusora_destino = db.query(Difusora).filter(
        Difusora.siglas == categoria_destino.difusora,
        Difusora.organizacion_id == usuario.organizacion_id
    ).first()
    if not difusora_destino:
        raise HTTPException(
            status_code=403,
            detail="La categoría de destino no pertenece a tu organización"
        )
    
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
async def list_categorias_with_stats(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Listar categorías con estadísticas (solo de las difusoras del usuario)"""
    from app.models.categorias import Cancion  # import local para evitar ciclos
    
    # Filtrar categorías por difusoras permitidas (aislamiento por organización)
    query = db.query(Categoria)
    if difusoras_allowed:
        query = query.filter(Categoria.difusora.in_(difusoras_allowed))
    else:
        # Si no tiene difusoras asignadas, retornar lista vacía
        return []
    
    categorias = query.order_by(Categoria.nombre.asc()).all()
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
async def get_categorias_politica(
    politica_id: int, 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Obtener categorías guardadas para una política específica (solo si la política pertenece a una difusora del usuario)"""
    politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
    if not politica:
        raise HTTPException(status_code=404, detail="Política no encontrada")
    
    # Verificar que la política pertenece a una difusora permitida
    if politica.difusora not in difusoras_allowed:
        raise HTTPException(
            status_code=403,
            detail="No tienes permiso para acceder a esta política"
        )
    if not politica.categorias_seleccionadas:
        return {"categorias": [], "total": 0}
    # Almacenadas como ids separados por coma
    categorias_ids = [c.strip() for c in politica.categorias_seleccionadas.split(',') if c and c.strip()]
    return {"categorias": categorias_ids, "total": len(categorias_ids)}

@router.post("/canciones/politica/{politica_id}/categorias")
async def save_categorias_politica(
    politica_id: int, 
    categorias: List[str], 
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Guardar categorías para una política específica (solo si la política pertenece a una difusora del usuario)"""
    politica = db.query(PoliticaProgramacionModel).filter(PoliticaProgramacionModel.id == politica_id).first()
    if not politica:
        raise HTTPException(status_code=404, detail="Política no encontrada")
    
    # Verificar que la política pertenece a una difusora permitida
    if politica.difusora not in difusoras_allowed:
        raise HTTPException(
            status_code=403,
            detail="No tienes permiso para modificar esta política"
        )
    
    # Verificar que todas las categorías pertenecen a difusoras permitidas
    if categorias:
        categorias_ids = [int(c.strip()) for c in categorias if c.strip() and c.strip().isdigit()]
        categorias_obj = db.query(Categoria).filter(Categoria.id.in_(categorias_ids)).all()
        for cat in categorias_obj:
            if cat.difusora not in difusoras_allowed:
                raise HTTPException(
                    status_code=403,
                    detail=f"No tienes permiso para usar la categoría '{cat.nombre}' que pertenece a otra difusora"
                )
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
async def get_mantenimiento_categorias(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Obtener mantenimiento de categorías (solo de las difusoras del usuario y de su organización)"""
    from app.models.catalogos import Difusora
    
    # Filtrar categorías por difusoras permitidas (aislamiento por organización)
    query = db.query(Categoria)
    if difusoras_allowed:
        # Verificar que las difusoras pertenecen a la organización del usuario
        difusoras_org = db.query(Difusora.siglas).filter(
            Difusora.siglas.in_(difusoras_allowed),
            Difusora.organizacion_id == usuario.organizacion_id
        ).all()
        difusoras_org_list = [d[0] for d in difusoras_org]
        
        if difusoras_org_list:
            query = query.filter(Categoria.difusora.in_(difusoras_org_list))
        else:
            # Si no hay difusoras de la organización, retornar lista vacía
            return {"message": "Mantenimiento de Categorías", "data": []}
    else:
        # Si no tiene difusoras asignadas, retornar lista vacía
        return {"message": "Mantenimiento de Categorías", "data": []}
    
    categorias = query.filter(Categoria.activa == True).order_by(Categoria.nombre.asc()).all()
    return {"message": "Mantenimiento de Categorías", "data": [{"id": c.id, "nombre": c.nombre, "difusora": c.difusora} for c in categorias]}

@router.get("/categorias/movimientos")
async def get_movimientos_categorias(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """Obtener movimientos entre categorías (solo de las difusoras del usuario)"""
    # Este endpoint es un placeholder, pero debe estar protegido
    # Si se implementa en el futuro, debe filtrar por difusoras_allowed
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
