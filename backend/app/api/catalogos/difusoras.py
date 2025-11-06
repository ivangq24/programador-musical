from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import or_
from app.core.database import get_db
from app.core.auth import get_current_user, get_user_difusoras
from app.models.auth import Usuario
from app.models.catalogos import Difusora
from app.schemas.catalogos import DifusoraCreate, DifusoraUpdate, Difusora as DifusoraSchema
from typing import List, Optional
import logging

logger = logging.getLogger(__name__)
router = APIRouter()

@router.get("/", response_model=List[DifusoraSchema])
async def get_difusoras(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    difusoras_allowed: List[str] = Depends(get_user_difusoras),
    skip: int = Query(0, ge=0, description="Número de registros a omitir"),
    limit: int = Query(100, ge=1, le=1000, description="Número máximo de registros a retornar"),
    search: Optional[str] = Query(None, description="Término de búsqueda"),
    activa: Optional[bool] = Query(None, description="Filtrar por estado activo")
):
    """
    Obtener lista de difusoras con filtros opcionales
    Solo muestra las difusoras asignadas al usuario (admin ve todas)
    """
    try:
        query = db.query(Difusora)
        
        # Filtrar por difusoras permitidas (a menos que sea admin)
        if usuario.rol != "admin":
            query = query.filter(Difusora.siglas.in_(difusoras_allowed))
        
        # Aplicar filtro de estado activo
        if activa is not None:
            query = query.filter(Difusora.activa == activa)
        
        # Aplicar búsqueda
        if search:
            search_term = f"%{search}%"
            query = query.filter(
                or_(
                    Difusora.nombre.ilike(search_term),
                    Difusora.siglas.ilike(search_term),
                    Difusora.slogan.ilike(search_term),
                    Difusora.descripcion.ilike(search_term)
                )
            )
        
        # Ordenar por orden y luego por nombre
        query = query.order_by(Difusora.orden, Difusora.nombre)
        
        # Aplicar paginación
        difusoras = query.offset(skip).limit(limit).all()
        
        return difusoras
        
    except Exception as e:
        logger.error(f"Error al obtener difusoras: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/{difusora_id}", response_model=DifusoraSchema)
async def get_difusora(difusora_id: int, db: Session = Depends(get_db)):
    """
    Obtener una difusora específica por ID
    """
    try:
        difusora = db.query(Difusora).filter(Difusora.id == difusora_id).first()
        if not difusora:
            raise HTTPException(status_code=404, detail="Difusora no encontrada")
        return difusora
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error al obtener difusora {difusora_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.post("/", response_model=DifusoraSchema)
async def create_difusora(difusora: DifusoraCreate, db: Session = Depends(get_db)):
    """
    Crear una nueva difusora
    """
    try:
        # Verificar si ya existe una difusora con las mismas siglas
        existing_difusora = db.query(Difusora).filter(Difusora.siglas == difusora.siglas).first()
        if existing_difusora:
            raise HTTPException(status_code=400, detail="Ya existe una difusora con esas siglas")
        
        # Crear nueva difusora
        db_difusora = Difusora(**difusora.dict())
        db.add(db_difusora)
        db.commit()
        db.refresh(db_difusora)
        
        logger.info(f"Difusora creada: {db_difusora.siglas} - {db_difusora.nombre}")
        return db_difusora
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error al crear difusora: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.put("/{difusora_id}", response_model=DifusoraSchema)
async def update_difusora(
    difusora_id: int, 
    difusora_update: DifusoraUpdate, 
    db: Session = Depends(get_db)
):
    """
    Actualizar una difusora existente
    """
    try:
        # Buscar la difusora
        db_difusora = db.query(Difusora).filter(Difusora.id == difusora_id).first()
        if not db_difusora:
            raise HTTPException(status_code=404, detail="Difusora no encontrada")
        
        # Verificar si las siglas ya existen en otra difusora
        if difusora_update.siglas and difusora_update.siglas != db_difusora.siglas:
            existing_difusora = db.query(Difusora).filter(
                Difusora.siglas == difusora_update.siglas,
                Difusora.id != difusora_id
            ).first()
            if existing_difusora:
                raise HTTPException(status_code=400, detail="Ya existe una difusora con esas siglas")
        
        # Actualizar solo los campos proporcionados
        update_data = difusora_update.dict(exclude_unset=True)
        for field, value in update_data.items():
            setattr(db_difusora, field, value)
        
        db.commit()
        db.refresh(db_difusora)
        
        logger.info(f"Difusora actualizada: {db_difusora.siglas} - {db_difusora.nombre}")
        return db_difusora
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error al actualizar difusora {difusora_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.delete("/{difusora_id}")
async def delete_difusora(difusora_id: int, db: Session = Depends(get_db)):
    """
    Eliminar una difusora
    """
    try:
        # Buscar la difusora
        db_difusora = db.query(Difusora).filter(Difusora.id == difusora_id).first()
        if not db_difusora:
            raise HTTPException(status_code=404, detail="Difusora no encontrada")
        
        # Eliminar la difusora
        db.delete(db_difusora)
        db.commit()
        
        logger.info(f"Difusora eliminada: {db_difusora.siglas} - {db_difusora.nombre}")
        return {"message": "Difusora eliminada correctamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error al eliminar difusora {difusora_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/stats/summary")
async def get_difusoras_stats(db: Session = Depends(get_db)):
    """
    Obtener estadísticas de difusoras
    """
    try:
        total = db.query(Difusora).count()
        activas = db.query(Difusora).filter(Difusora.activa == True).count()
        inactivas = total - activas
        
        return {
            "total": total,
            "activas": activas,
            "inactivas": inactivas
        }
        
    except Exception as e:
        logger.error(f"Error al obtener estadísticas de difusoras: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

