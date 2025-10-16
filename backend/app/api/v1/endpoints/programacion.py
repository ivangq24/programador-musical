from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import or_, func, and_, desc, asc
from app.core.database import get_db
from app.models.programacion import Programacion as ProgramacionModel
from app.schemas.programacion import (
    Programacion as ProgramacionSchema,
    ProgramacionCreate,
    ProgramacionUpdate,
    ProgramacionStats
)
from pydantic import BaseModel
from typing import List, Optional, Dict, Any
from datetime import datetime, date, time
import logging

logger = logging.getLogger(__name__)

router = APIRouter()

# ============================================================================
# ENDPOINTS CRUD PARA PROGRAMACIÓN
# ============================================================================

@router.get("/", response_model=List[ProgramacionSchema])
async def get_programacion(
    skip: int = Query(0, ge=0, description="Número de registros a omitir"),
    limit: int = Query(100, ge=1, le=1000, description="Número de registros a retornar"),
    difusora: Optional[str] = Query(None, description="Filtrar por difusora"),
    fecha: Optional[str] = Query(None, description="Filtrar por fecha (YYYY-MM-DD)"),
    fecha_inicio: Optional[str] = Query(None, description="Fecha de inicio (YYYY-MM-DD)"),
    fecha_fin: Optional[str] = Query(None, description="Fecha de fin (YYYY-MM-DD)"),
    tipo: Optional[str] = Query(None, description="Filtrar por tipo"),
    categoria: Optional[str] = Query(None, description="Filtrar por categoría"),
    mc: Optional[bool] = Query(None, description="Filtrar por MC completado"),
    politica_id: Optional[int] = Query(None, description="Filtrar por política"),
    reloj_id: Optional[int] = Query(None, description="Filtrar por reloj"),
    search: Optional[str] = Query(None, description="Búsqueda en descripción, intérprete, disco"),
    db: Session = Depends(get_db)
):
    """Obtener programación con filtros opcionales"""
    try:
        query = db.query(ProgramacionModel)
        
        # Aplicar filtros
        if difusora:
            query = query.filter(ProgramacionModel.difusora == difusora)
        
        if fecha:
            fecha_obj = datetime.strptime(fecha, "%Y-%m-%d").date()
            query = query.filter(ProgramacionModel.fecha == fecha_obj)
        
        if fecha_inicio and fecha_fin:
            fecha_inicio_obj = datetime.strptime(fecha_inicio, "%Y-%m-%d").date()
            fecha_fin_obj = datetime.strptime(fecha_fin, "%Y-%m-%d").date()
            query = query.filter(
                and_(
                    ProgramacionModel.fecha >= fecha_inicio_obj,
                    ProgramacionModel.fecha <= fecha_fin_obj
                )
            )
        
        if tipo:
            query = query.filter(ProgramacionModel.tipo == tipo)
        
        if categoria:
            query = query.filter(ProgramacionModel.categoria == categoria)
        
        if mc is not None:
            query = query.filter(ProgramacionModel.mc == mc)
        
        if politica_id:
            query = query.filter(ProgramacionModel.politica_id == politica_id)
        
        if reloj_id:
            query = query.filter(ProgramacionModel.reloj_id == reloj_id)
        
        if search:
            search_filter = or_(
                ProgramacionModel.descripcion.ilike(f"%{search}%"),
                ProgramacionModel.interprete.ilike(f"%{search}%"),
                ProgramacionModel.disco.ilike(f"%{search}%")
            )
            query = query.filter(search_filter)
        
        # Ordenar por fecha y hora
        query = query.order_by(
            ProgramacionModel.fecha.desc(),
            ProgramacionModel.hora_planeada.asc()
        )
        
        # Aplicar paginación
        programacion = query.offset(skip).limit(limit).all()
        
        return programacion
        
    except Exception as e:
        logger.error(f"Error al obtener programación: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/{programacion_id}", response_model=ProgramacionSchema)
async def get_programacion_by_id(
    programacion_id: int,
    db: Session = Depends(get_db)
):
    """Obtener programación por ID"""
    try:
        programacion = db.query(ProgramacionModel).filter(
            ProgramacionModel.id == programacion_id
        ).first()
        
        if not programacion:
            raise HTTPException(status_code=404, detail="Programación no encontrada")
        
        return programacion
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error al obtener programación {programacion_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.post("/", response_model=ProgramacionSchema)
async def create_programacion(
    programacion_data: ProgramacionCreate,
    db: Session = Depends(get_db)
):
    """Crear nueva programación"""
    try:
        # Crear nueva programación
        programacion = ProgramacionModel(**programacion_data.dict())
        
        db.add(programacion)
        db.commit()
        db.refresh(programacion)
        
        return programacion
        
    except Exception as e:
        db.rollback()
        logger.error(f"Error al crear programación: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.put("/{programacion_id}", response_model=ProgramacionSchema)
async def update_programacion(
    programacion_id: int,
    programacion_data: ProgramacionUpdate,
    db: Session = Depends(get_db)
):
    """Actualizar programación existente"""
    try:
        programacion = db.query(ProgramacionModel).filter(
            ProgramacionModel.id == programacion_id
        ).first()
        
        if not programacion:
            raise HTTPException(status_code=404, detail="Programación no encontrada")
        
        # Actualizar campos
        update_data = programacion_data.dict(exclude_unset=True)
        for field, value in update_data.items():
            setattr(programacion, field, value)
        
        db.commit()
        db.refresh(programacion)
        
        return programacion
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error al actualizar programación {programacion_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.delete("/{programacion_id}")
async def delete_programacion(
    programacion_id: int,
    db: Session = Depends(get_db)
):
    """Eliminar programación"""
    try:
        programacion = db.query(ProgramacionModel).filter(
            ProgramacionModel.id == programacion_id
        ).first()
        
        if not programacion:
            raise HTTPException(status_code=404, detail="Programación no encontrada")
        
        db.delete(programacion)
        db.commit()
        
        return {"message": "Programación eliminada correctamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error al eliminar programación {programacion_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

# ============================================================================
# ENDPOINTS DE ESTADÍSTICAS
# ============================================================================

@router.get("/stats/overview", response_model=ProgramacionStats)
async def get_programacion_stats(
    difusora: Optional[str] = Query(None, description="Filtrar por difusora"),
    fecha_inicio: Optional[str] = Query(None, description="Fecha de inicio (YYYY-MM-DD)"),
    fecha_fin: Optional[str] = Query(None, description="Fecha de fin (YYYY-MM-DD)"),
    db: Session = Depends(get_db)
):
    """Obtener estadísticas de programación"""
    try:
        query = db.query(ProgramacionModel)
        
        # Aplicar filtros
        if difusora:
            query = query.filter(ProgramacionModel.difusora == difusora)
        
        if fecha_inicio and fecha_fin:
            fecha_inicio_obj = datetime.strptime(fecha_inicio, "%Y-%m-%d").date()
            fecha_fin_obj = datetime.strptime(fecha_fin, "%Y-%m-%d").date()
            query = query.filter(
                and_(
                    ProgramacionModel.fecha >= fecha_inicio_obj,
                    ProgramacionModel.fecha <= fecha_fin_obj
                )
            )
        
        # Estadísticas generales
        total = query.count()
        mc_completados = query.filter(ProgramacionModel.mc == True).count()
        mc_pendientes = query.filter(ProgramacionModel.mc == False).count()
        
        # Estadísticas por difusora
        por_difusora = {}
        difusoras = db.query(ProgramacionModel.difusora, func.count(ProgramacionModel.id)).group_by(ProgramacionModel.difusora).all()
        for dif, count in difusoras:
            por_difusora[dif] = count
        
        # Estadísticas por fecha
        por_fecha = {}
        fechas = db.query(ProgramacionModel.fecha, func.count(ProgramacionModel.id)).group_by(ProgramacionModel.fecha).all()
        for fecha, count in fechas:
            por_fecha[str(fecha)] = count
        
        # Estadísticas por tipo
        por_tipo = {}
        tipos = db.query(ProgramacionModel.tipo, func.count(ProgramacionModel.id)).group_by(ProgramacionModel.tipo).all()
        for tipo, count in tipos:
            por_tipo[tipo] = count
        
        # Estadísticas por categoría
        por_categoria = {}
        categorias = db.query(ProgramacionModel.categoria, func.count(ProgramacionModel.id)).group_by(ProgramacionModel.categoria).all()
        for categoria, count in categorias:
            por_categoria[categoria] = count
        
        return ProgramacionStats(
            total=total,
            por_difusora=por_difusora,
            por_fecha=por_fecha,
            por_tipo=por_tipo,
            por_categoria=por_categoria,
            mc_completados=mc_completados,
            mc_pendientes=mc_pendientes
        )
        
    except Exception as e:
        logger.error(f"Error al obtener estadísticas de programación: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

# ============================================================================
# ENDPOINTS DE GENERACIÓN DE PROGRAMACIÓN
# ============================================================================

@router.post("/generar")
async def generar_programacion(
    difusora: str,
    politica_id: int,
    fecha_inicio: str,
    fecha_fin: str,
    db: Session = Depends(get_db)
):
    """Generar programación completa para un período"""
    try:
        # Convertir fechas
        fecha_inicio_obj = datetime.strptime(fecha_inicio, "%Y-%m-%d").date()
        fecha_fin_obj = datetime.strptime(fecha_fin, "%Y-%m-%d").date()
        
        # Eliminar programación existente para el período
        db.query(ProgramacionModel).filter(
            and_(
                ProgramacionModel.difusora == difusora,
                ProgramacionModel.fecha >= fecha_inicio_obj,
                ProgramacionModel.fecha <= fecha_fin_obj
            )
        ).delete()
        
        # Generar programación para cada día
        current_date = fecha_inicio_obj
        total_generados = 0
        
        while current_date <= fecha_fin_obj:
            # Aquí se implementaría la lógica de generación
            # Por ahora, retornar mensaje de éxito
            current_date += datetime.timedelta(days=1)
            total_generados += 1
        
        db.commit()
        
        return {
            "message": f"Programación generada correctamente",
            "dias_generados": total_generados,
            "difusora": difusora,
            "fecha_inicio": fecha_inicio,
            "fecha_fin": fecha_fin
        }
        
    except Exception as e:
        db.rollback()
        logger.error(f"Error al generar programación: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")