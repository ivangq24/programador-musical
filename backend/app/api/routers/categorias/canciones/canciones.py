from fastapi import APIRouter, HTTPException, Depends, Query
from sqlalchemy.orm import Session
from sqlalchemy import text
from typing import List, Optional
from app.core.database import get_db
from app.models.categorias import Cancion, Categoria
from app.models.catalogos import Difusora
from app.schemas.categorias import CancionCreate, CancionUpdate, Cancion as CancionSchema

router = APIRouter()

@router.get("/")
async def get_canciones(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    search: Optional[str] = Query(None),
    difusora: Optional[str] = Query(None),
    categoria: Optional[str] = Query(None),
    db: Session = Depends(get_db)
):
    """
    Obtiene la lista de canciones con filtros opcionales
    """
    try:
        query = db.query(Cancion)
        
        # Filtro por búsqueda
        if search:
            query = query.filter(
                Cancion.titulo.ilike(f"%{search}%") |
                Cancion.artista.ilike(f"%{search}%")
            )
        
        # Filtro por difusora (si se implementa la relación)
        if difusora:
            # Aquí se podría filtrar por difusora si hay relación
            pass
        
        # Filtro por categoría
        if categoria:
            query = query.join(Categoria).filter(Categoria.nombre == categoria)
        
        # Aplicar paginación
        total = query.count()
        canciones = query.offset(skip).limit(limit).all()
        
        # Formatear respuesta
        canciones_data = []
        for cancion in canciones:
            canciones_data.append({
                "id": cancion.id,
                "titulo": cancion.titulo,
                "artista": cancion.artista,
                "album": cancion.album,
                "duracion": cancion.duracion,
                "categoria_id": cancion.categoria_id,
                "activa": cancion.activa,
                "created_at": cancion.created_at.isoformat() if cancion.created_at else None,
                "updated_at": cancion.updated_at.isoformat() if cancion.updated_at else None
            })
        
        return {
            "canciones": canciones_data,
            "total": total,
            "skip": skip,
            "limit": limit
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error obteniendo canciones: {str(e)}")

@router.get("/{cancion_id}")
async def get_cancion(
    cancion_id: int,
    db: Session = Depends(get_db)
):
    """
    Obtiene una canción específica por ID
    """
    try:
        cancion = db.query(Cancion).filter(Cancion.id == cancion_id).first()
        
        if not cancion:
            raise HTTPException(status_code=404, detail="Canción no encontrada")
        
        return {
            "id": cancion.id,
            "titulo": cancion.titulo,
            "artista": cancion.artista,
            "album": cancion.album,
            "duracion": cancion.duracion,
            "categoria_id": cancion.categoria_id,
            "activa": cancion.activa,
            "created_at": cancion.created_at.isoformat() if cancion.created_at else None,
            "updated_at": cancion.updated_at.isoformat() if cancion.updated_at else None
        }
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error obteniendo canción: {str(e)}")

@router.post("/", response_model=CancionSchema)
async def create_cancion(
    cancion_data: CancionCreate,
    db: Session = Depends(get_db)
):
    """
    Crea una nueva canción
    """
    try:
        nueva_cancion = Cancion(**cancion_data.dict())
        
        db.add(nueva_cancion)
        db.commit()
        db.refresh(nueva_cancion)
        
        return nueva_cancion
        
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Error creando canción: {str(e)}")

@router.put("/{cancion_id}", response_model=CancionSchema)
async def update_cancion(
    cancion_id: int,
    cancion_update: CancionUpdate,
    db: Session = Depends(get_db)
):
    """
    Actualiza una canción existente
    """
    try:
        cancion = db.query(Cancion).filter(Cancion.id == cancion_id).first()
        
        if not cancion:
            raise HTTPException(status_code=404, detail="Canción no encontrada")
        
        # Actualizar solo los campos proporcionados
        update_data = cancion_update.dict(exclude_unset=True)
        for field, value in update_data.items():
            setattr(cancion, field, value)
        
        db.commit()
        db.refresh(cancion)
        
        return cancion
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Error actualizando canción: {str(e)}")

@router.delete("/{cancion_id}")
async def delete_cancion(
    cancion_id: int,
    db: Session = Depends(get_db)
):
    """
    Elimina una canción
    """
    try:
        cancion = db.query(Cancion).filter(Cancion.id == cancion_id).first()
        
        if not cancion:
            raise HTTPException(status_code=404, detail="Canción no encontrada")
        
        db.delete(cancion)
        db.commit()
        
        return {"message": "Canción eliminada exitosamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Error eliminando canción: {str(e)}")

@router.get("/stats/summary")
async def get_canciones_stats(db: Session = Depends(get_db)):
    """
    Obtiene estadísticas de las canciones
    """
    try:
        total_canciones = db.query(Cancion).count()
        canciones_activas = db.query(Cancion).filter(Cancion.activa == True).count()
        canciones_inactivas = total_canciones - canciones_activas
        
        return {
            "total_canciones": total_canciones,
            "canciones_activas": canciones_activas,
            "canciones_inactivas": canciones_inactivas
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error obteniendo estadísticas: {str(e)}")

@router.get("/categorias/unique")
async def get_categorias_canciones(db: Session = Depends(get_db)):
    """
    Obtiene las categorías únicas de las canciones
    """
    try:
        # Obtener todas las categorías activas de la base de datos
        categorias = db.query(Categoria.nombre).filter(
            Categoria.activa == True
        ).distinct().all()
        
        # Convertir a lista de strings y ordenar
        categorias_list = sorted([cat[0] for cat in categorias if cat[0]])
        
        return {
            "categorias": categorias_list,
            "total": len(categorias_list)
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error obteniendo categorías: {str(e)}")

@router.post("/politica/{politica_id}/categorias")
async def guardar_categorias_politica(
    politica_id: int,
    categorias: List[str],
    db: Session = Depends(get_db)
):
    """
    Guarda las categorías seleccionadas para una política
    """
    try:
        print(f"Guardando categorías para política {politica_id}: {categorias}")
        
        # Eliminar categorías existentes para esta política
        db.execute(text("DELETE FROM politica_categorias WHERE politica_id = :politica_id"), 
                  {"politica_id": politica_id})
        
        # Insertar las nuevas categorías
        for categoria in categorias:
            db.execute(
                text("INSERT INTO politica_categorias (politica_id, categoria_nombre) VALUES (:politica_id, :categoria_nombre)"),
                {"politica_id": politica_id, "categoria_nombre": categoria}
            )
        
        db.commit()
        print(f"Categorías guardadas exitosamente en la DB para política {politica_id}")
        
        return {
            "message": "Categorías guardadas exitosamente",
            "politica_id": politica_id,
            "categorias": categorias,
            "total": len(categorias)
        }
    except Exception as e:
        db.rollback()
        print(f"Error guardando categorías: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error guardando categorías: {str(e)}")

@router.get("/politica/{politica_id}/categorias")
async def obtener_categorias_politica(
    politica_id: int,
    db: Session = Depends(get_db)
):
    """
    Obtiene las categorías guardadas para una política
    """
    try:
        # Consultar categorías reales de la base de datos
        result = db.execute(
            text("SELECT categoria_nombre FROM politica_categorias WHERE politica_id = :politica_id ORDER BY categoria_nombre"),
            {"politica_id": politica_id}
        )
        categorias = [row[0] for row in result.fetchall()]
        
        print(f"Categorías obtenidas de la DB para política {politica_id}: {categorias}")
        
        return {
            "politica_id": politica_id,
            "categorias": categorias,
            "total": len(categorias)
        }
    except Exception as e:
        print(f"Error obteniendo categorías de política: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error obteniendo categorías de política: {str(e)}")
