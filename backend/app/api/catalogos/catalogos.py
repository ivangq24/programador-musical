from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import or_
from app.core.database import get_db
from app.core.auth import get_current_user
from app.models.auth import Usuario
from app.models.catalogos import Difusora
from app.schemas.catalogos import Difusora as DifusoraSchema
from typing import List, Optional

router = APIRouter()

# General endpoints
@router.get("/general/difusoras", response_model=List[DifusoraSchema])
async def get_difusoras(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
    skip: int = Query(0, ge=0, description="Número de registros a omitir"),
    limit: int = Query(100, ge=1, le=1000, description="Número máximo de registros a retornar"),
    search: Optional[str] = Query(None, description="Término de búsqueda"),
    activa: Optional[bool] = Query(None, description="Filtrar por estado activo")
):
    """Obtener lista de difusoras con filtros opcionales (solo de la organización del usuario)"""
    try:
        # Verificar que organizacion_id existe
        if not hasattr(usuario, 'organizacion_id') or not usuario.organizacion_id:
            # Si organizacion_id no existe, la migración aún no se ha ejecutado
            return []
        
        # Filtrar por organización del usuario (multi-tenancy)
        query = db.query(Difusora).filter(Difusora.organizacion_id == usuario.organizacion_id)
        
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

        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/general/difusoras/stats")
async def get_difusoras_stats(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user)
):
    """Obtener estadísticas de difusoras (solo de la organización del usuario)"""
    try:
        # Verificar que organizacion_id existe
        if not hasattr(usuario, 'organizacion_id') or not usuario.organizacion_id:
            # Si organizacion_id no existe, la migración aún no se ha ejecutado
            return {
                "total": 0,
                "activas": 0,
                "inactivas": 0
            }
        
        # Filtrar por organización del usuario (multi-tenancy)
        query = db.query(Difusora).filter(Difusora.organizacion_id == usuario.organizacion_id)
        total = query.count()
        activas = query.filter(Difusora.activa == True).count()
        inactivas = total - activas
        
        return {
            "total": total,
            "activas": activas,
            "inactivas": inactivas
        }
        
    except Exception as e:

        raise HTTPException(status_code=500, detail="Error interno del servidor")


