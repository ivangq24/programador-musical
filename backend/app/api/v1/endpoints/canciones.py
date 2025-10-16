from fastapi import APIRouter, HTTPException, Depends, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from app.core.database import get_db
from app.models.categorias import Cancion, Categoria
from app.models.catalogos import Difusora

router = APIRouter()

@router.get("/canciones")
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

@router.get("/canciones/{cancion_id}")
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

@router.post("/canciones")
async def create_cancion(
    titulo: str,
    artista: str,
    album: Optional[str] = None,
    duracion: Optional[int] = None,
    categoria_id: Optional[int] = None,
    db: Session = Depends(get_db)
):
    """
    Crea una nueva canción
    """
    try:
        nueva_cancion = Cancion(
            titulo=titulo,
            artista=artista,
            album=album,
            duracion=duracion,
            categoria_id=categoria_id,
            activa=True
        )
        
        db.add(nueva_cancion)
        db.commit()
        db.refresh(nueva_cancion)
        
        return {
            "id": nueva_cancion.id,
            "titulo": nueva_cancion.titulo,
            "artista": nueva_cancion.artista,
            "album": nueva_cancion.album,
            "duracion": nueva_cancion.duracion,
            "categoria_id": nueva_cancion.categoria_id,
            "activa": nueva_cancion.activa,
            "message": "Canción creada exitosamente"
        }
        
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Error creando canción: {str(e)}")

@router.put("/canciones/{cancion_id}")
async def update_cancion(
    cancion_id: int,
    titulo: Optional[str] = None,
    artista: Optional[str] = None,
    album: Optional[str] = None,
    duracion: Optional[int] = None,
    categoria_id: Optional[int] = None,
    activa: Optional[bool] = None,
    db: Session = Depends(get_db)
):
    """
    Actualiza una canción existente
    """
    try:
        cancion = db.query(Cancion).filter(Cancion.id == cancion_id).first()
        
        if not cancion:
            raise HTTPException(status_code=404, detail="Canción no encontrada")
        
        # Actualizar campos si se proporcionan
        if titulo is not None:
            cancion.titulo = titulo
        if artista is not None:
            cancion.artista = artista
        if album is not None:
            cancion.album = album
        if duracion is not None:
            cancion.duracion = duracion
        if categoria_id is not None:
            cancion.categoria_id = categoria_id
        if activa is not None:
            cancion.activa = activa
        
        db.commit()
        db.refresh(cancion)
        
        return {
            "id": cancion.id,
            "titulo": cancion.titulo,
            "artista": cancion.artista,
            "album": cancion.album,
            "duracion": cancion.duracion,
            "categoria_id": cancion.categoria_id,
            "activa": cancion.activa,
            "message": "Canción actualizada exitosamente"
        }
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Error actualizando canción: {str(e)}")

@router.delete("/canciones/{cancion_id}")
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

@router.get("/stats")
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
