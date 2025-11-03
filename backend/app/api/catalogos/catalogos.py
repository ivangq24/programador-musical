from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import or_
from app.core.database import get_db
from app.models.catalogos import Difusora
from app.schemas.catalogos import Difusora as DifusoraSchema
from typing import List, Optional
import logging

logger = logging.getLogger(__name__)
router = APIRouter()

# General endpoints
@router.get("/general/difusoras", response_model=List[DifusoraSchema])
async def get_difusoras(
    db: Session = Depends(get_db),
    skip: int = Query(0, ge=0, description="Número de registros a omitir"),
    limit: int = Query(100, ge=1, le=1000, description="Número máximo de registros a retornar"),
    search: Optional[str] = Query(None, description="Término de búsqueda"),
    activa: Optional[bool] = Query(None, description="Filtrar por estado activo")
):
    """Obtener lista de difusoras con filtros opcionales"""
    try:
        query = db.query(Difusora)
        
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

@router.get("/general/difusoras/stats")
async def get_difusoras_stats(db: Session = Depends(get_db)):
    """Obtener estadísticas de difusoras"""
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


