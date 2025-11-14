from fastapi import APIRouter, HTTPException, Depends, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from app.core.database import get_db
from app.core.auth import get_current_user, get_user_difusoras
from app.models.auth import Usuario
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
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """
    Obtiene la lista de canciones con filtros opcionales
    Solo muestra canciones de las categorías que pertenecen a las difusoras del usuario
    """
    try:
        query = db.query(Cancion)
        
        # Filtrar por categorías que pertenecen a las difusoras del usuario (multi-tenancy)
        if difusoras_allowed:
            # Obtener IDs de categorías de las difusoras permitidas
            categorias_ids = db.query(Categoria.id).filter(
                Categoria.difusora.in_(difusoras_allowed)
            ).all()
            categorias_ids_list = [cat_id[0] for cat_id in categorias_ids]
            
            if categorias_ids_list:
                query = query.filter(Cancion.categoria_id.in_(categorias_ids_list))
            else:
                # Si no hay categorías, retornar lista vacía
                return {
                    "canciones": [],
                    "total": 0,
                    "skip": skip,
                    "limit": limit
                }
        else:
            # Si no tiene difusoras asignadas, retornar lista vacía
            # Esto asegura el aislamiento por organización
            return {
                "canciones": [],
                "total": 0,
                "skip": skip,
                "limit": limit
            }
        
        # Filtro por búsqueda
        if search:
            query = query.filter(
                Cancion.titulo.ilike(f"%{search}%") |
                Cancion.artista.ilike(f"%{search}%")
            )
        
        # Filtro por difusora específica (debe estar en las permitidas)
        if difusora:
            if difusora not in difusoras_allowed:
                raise HTTPException(
                    status_code=403,
                    detail="No tienes permiso para acceder a canciones de esta difusora"
                )
            # Filtrar por categorías de esta difusora
            categorias_difusora_ids = db.query(Categoria.id).filter(
                Categoria.difusora == difusora
            ).all()
            categorias_difusora_list = [cat_id[0] for cat_id in categorias_difusora_ids]
            
            if categorias_difusora_list:
                query = query.filter(Cancion.categoria_id.in_(categorias_difusora_list))
            else:
                # Si no hay categorías para esta difusora, retornar lista vacía
                return {
                    "canciones": [],
                    "total": 0,
                    "skip": skip,
                    "limit": limit
                }
        
        # Filtro por categoría
        if categoria:
            query = query.join(Categoria).filter(Categoria.nnombre == categoria)
            # Verificar que la categoría pertenece a una difusora permitida
            categoria_obj = db.query(Categoria).filter(Categoria.nnombre == categoria).first()
            if categoria_obj and categoria_obj.difusora not in difusoras_allowed:
                raise HTTPException(
                    status_code=403,
                    detail="No tienes permiso para acceder a esta categoría"
                )
        
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
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """
    Obtiene una canción específica por ID
    Solo si pertenece a una categoría de las difusoras del usuario
    """
    try:
        cancion = db.query(Cancion).filter(Cancion.id == cancion_id).first()
        
        if not cancion:
            raise HTTPException(status_code=404, detail="Canción no encontrada")
        
        # Verificar que la canción pertenece a una categoría de las difusoras permitidas
        if cancion.categoria_id:
            categoria = db.query(Categoria).filter(Categoria.id == cancion.categoria_id).first()
            if categoria and categoria.difusora not in difusoras_allowed:
                raise HTTPException(
                    status_code=403,
                    detail="No tienes permiso para acceder a esta canción"
                )
        
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
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """
    Crea una nueva canción
    Solo si la categoría pertenece a una difusora del usuario
    """
    try:
        # Verificar que la categoría pertenece a una difusora permitida
        if categoria_id:
            categoria = db.query(Categoria).filter(Categoria.id == categoria_id).first()
            if not categoria:
                raise HTTPException(status_code=404, detail="Categoría no encontrada")
            if categoria.difusora not in difusoras_allowed:
                raise HTTPException(
                    status_code=403,
                    detail="No tienes permiso para crear canciones en esta categoría"
                )
        
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
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """
    Actualiza una canción existente
    Solo si pertenece a una categoría de las difusoras del usuario
    """
    try:
        cancion = db.query(Cancion).filter(Cancion.id == cancion_id).first()
        
        if not cancion:
            raise HTTPException(status_code=404, detail="Canción no encontrada")
        
        # Verificar que la canción pertenece a una categoría de las difusoras permitidas
        if cancion.categoria_id:
            categoria = db.query(Categoria).filter(Categoria.id == cancion.categoria_id).first()
            if categoria and categoria.difusora not in difusoras_allowed:
                raise HTTPException(
                    status_code=403,
                    detail="No tienes permiso para modificar esta canción"
                )
        
        # Si se está cambiando la categoría, verificar que la nueva categoría pertenece a una difusora permitida
        if categoria_id is not None and categoria_id != cancion.categoria_id:
            nueva_categoria = db.query(Categoria).filter(Categoria.id == categoria_id).first()
            if not nueva_categoria:
                raise HTTPException(status_code=404, detail="Categoría no encontrada")
            if nueva_categoria.difusora not in difusoras_allowed:
                raise HTTPException(
                    status_code=403,
                    detail="No tienes permiso para asignar canciones a esta categoría"
                )
        
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
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """
    Elimina una canción
    Solo si pertenece a una categoría de las difusoras del usuario
    """
    try:
        cancion = db.query(Cancion).filter(Cancion.id == cancion_id).first()
        
        if not cancion:
            raise HTTPException(status_code=404, detail="Canción no encontrada")
        
        # Verificar que la canción pertenece a una categoría de las difusoras permitidas
        if cancion.categoria_id:
            categoria = db.query(Categoria).filter(Categoria.id == cancion.categoria_id).first()
            if categoria and categoria.difusora not in difusoras_allowed:
                raise HTTPException(
                    status_code=403,
                    detail="No tienes permiso para eliminar esta canción"
                )
        
        db.delete(cancion)
        db.commit()
        
        return {"message": "Canción eliminada exitosamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Error eliminando canción: {str(e)}")

@router.get("/stats")
async def get_canciones_stats(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras)
):
    """
    Obtiene estadísticas de las canciones (solo de las difusoras del usuario)
    """
    try:
        # Filtrar por categorías que pertenecen a las difusoras del usuario
        query = db.query(Cancion)
        if difusoras_allowed:
            # Obtener IDs de categorías de las difusoras permitidas
            categorias_ids = db.query(Categoria.id).filter(
                Categoria.difusora.in_(difusoras_allowed)
            ).all()
            categorias_ids_list = [cat_id[0] for cat_id in categorias_ids]
            
            if categorias_ids_list:
                query = query.filter(Cancion.categoria_id.in_(categorias_ids_list))
            else:
                # Si no hay categorías, retornar estadísticas vacías
                return {
                    "total_canciones": 0,
                    "canciones_activas": 0,
                    "canciones_inactivas": 0
                }
        else:
            # Si no tiene difusoras asignadas, retornar estadísticas vacías
            return {
                "total_canciones": 0,
                "canciones_activas": 0,
                "canciones_inactivas": 0
            }
        
        total_canciones = query.count()
        canciones_activas = query.filter(Cancion.activa == True).count()
        canciones_inactivas = total_canciones - canciones_activas
        
        return {
            "total_canciones": total_canciones,
            "canciones_activas": canciones_activas,
            "canciones_inactivas": canciones_inactivas
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error obteniendo estadísticas: {str(e)}")
