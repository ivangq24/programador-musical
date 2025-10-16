from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import or_, func
from app.core.database import get_db
from app.models.programacion import SetRegla as SetReglaModel, Regla as ReglaModel
from app.schemas.programacion import (
    SetReglaCreate, SetReglaUpdate, SetRegla,
    ReglaCreate, ReglaUpdate, Regla
)
from typing import List, Optional
import logging

logger = logging.getLogger(__name__)
router = APIRouter()

# ============================================================================
# SET DE REGLAS
# ============================================================================

@router.get("/", response_model=List[SetRegla])
async def get_set_reglas(
    db: Session = Depends(get_db),
    skip: int = Query(0, ge=0, description="Número de registros a omitir"),
    limit: int = Query(100, ge=1, le=1000, description="Número máximo de registros a retornar"),
    search: Optional[str] = Query(None, description="Término de búsqueda"),
    habilitado: Optional[bool] = Query(None, description="Filtrar por estado habilitado")
):
    """Obtener lista de sets de reglas con filtros opcionales"""
    try:
        query = db.query(SetReglaModel)
        
        if search:
            search_term = f"%{search}%"
            query = query.filter(
                or_(
                    SetReglaModel.nombre.ilike(search_term),
                    SetReglaModel.descripcion.ilike(search_term)
                )
            )
        
        if habilitado is not None:
            query = query.filter(SetReglaModel.habilitado == habilitado)
        
        set_reglas = query.offset(skip).limit(limit).all()
        return set_reglas
        
    except Exception as e:
        logger.error(f"Error al obtener sets de reglas: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.get("/{set_regla_id}", response_model=SetRegla)
async def get_set_regla(set_regla_id: int, db: Session = Depends(get_db)):
    """Obtener un set de reglas específico"""
    try:
        set_regla = db.query(SetReglaModel).filter(SetReglaModel.id == set_regla_id).first()
        if not set_regla:
            raise HTTPException(status_code=404, detail="Set de reglas no encontrado")
        return set_regla
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error al obtener set de reglas {set_regla_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.post("/", response_model=SetRegla)
async def create_set_regla(set_regla: SetReglaCreate, db: Session = Depends(get_db)):
    """Crear un nuevo set de reglas"""
    try:
        # Verificar si ya existe un set de reglas con el mismo nombre
        existing = db.query(SetReglaModel).filter(SetReglaModel.nombre == set_regla.nombre).first()
        if existing:
            raise HTTPException(status_code=400, detail="Ya existe un set de reglas con ese nombre")
        
        db_set_regla = SetReglaModel(**set_regla.dict())
        db.add(db_set_regla)
        db.commit()
        db.refresh(db_set_regla)
        return db_set_regla
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error al crear set de reglas: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.put("/{set_regla_id}", response_model=SetRegla)
async def update_set_regla(set_regla_id: int, set_regla_update: SetReglaUpdate, db: Session = Depends(get_db)):
    """Actualizar un set de reglas existente"""
    try:
        db_set_regla = db.query(SetReglaModel).filter(SetReglaModel.id == set_regla_id).first()
        if not db_set_regla:
            raise HTTPException(status_code=404, detail="Set de reglas no encontrado")
        
        update_data = set_regla_update.dict(exclude_unset=True)
        for field, value in update_data.items():
            setattr(db_set_regla, field, value)
        
        db.commit()
        db.refresh(db_set_regla)
        return db_set_regla
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error al actualizar set de reglas {set_regla_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.delete("/{set_regla_id}")
async def delete_set_regla(set_regla_id: int, db: Session = Depends(get_db)):
    """Eliminar un set de reglas"""
    try:
        db_set_regla = db.query(SetReglaModel).filter(SetReglaModel.id == set_regla_id).first()
        if not db_set_regla:
            raise HTTPException(status_code=404, detail="Set de reglas no encontrado")
        
        db.delete(db_set_regla)
        db.commit()
        return {"message": "Set de reglas eliminado correctamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error al eliminar set de reglas {set_regla_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

# ============================================================================
# REGLAS INDIVIDUALES
# ============================================================================

@router.get("/{set_regla_id}/reglas", response_model=List[Regla])
async def get_reglas_by_set(set_regla_id: int, db: Session = Depends(get_db)):
    """Obtener todas las reglas de un set específico"""
    try:
        set_regla = db.query(SetReglaModel).filter(SetReglaModel.id == set_regla_id).first()
        if not set_regla:
            raise HTTPException(status_code=404, detail="Set de reglas no encontrado")
        
        reglas = db.query(ReglaModel).filter(ReglaModel.set_regla_id == set_regla_id).all()
        return reglas
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error al obtener reglas del set {set_regla_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.post("/{set_regla_id}/reglas", response_model=Regla)
async def create_regla(set_regla_id: int, regla: ReglaCreate, db: Session = Depends(get_db)):
    """Crear una nueva regla para un set específico"""
    try:
        # Verificar que el set de reglas existe
        set_regla = db.query(SetReglaModel).filter(SetReglaModel.id == set_regla_id).first()
        if not set_regla:
            raise HTTPException(status_code=404, detail="Set de reglas no encontrado")
        
        regla_data = regla.dict()
        regla_data['set_regla_id'] = set_regla_id
        db_regla = ReglaModel(**regla_data)
        db.add(db_regla)
        db.commit()
        db.refresh(db_regla)
        return db_regla
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error al crear regla para set {set_regla_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.put("/reglas/{regla_id}", response_model=Regla)
async def update_regla(regla_id: int, regla_update: ReglaUpdate, db: Session = Depends(get_db)):
    """Actualizar una regla existente"""
    try:
        db_regla = db.query(ReglaModel).filter(ReglaModel.id == regla_id).first()
        if not db_regla:
            raise HTTPException(status_code=404, detail="Regla no encontrada")
        
        update_data = regla_update.dict(exclude_unset=True)
        for field, value in update_data.items():
            setattr(db_regla, field, value)
        
        db.commit()
        db.refresh(db_regla)
        return db_regla
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error al actualizar regla {regla_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@router.delete("/reglas/{regla_id}")
async def delete_regla(regla_id: int, db: Session = Depends(get_db)):
    """Eliminar una regla"""
    try:
        db_regla = db.query(ReglaModel).filter(ReglaModel.id == regla_id).first()
        if not db_regla:
            raise HTTPException(status_code=404, detail="Regla no encontrada")
        
        db.delete(db_regla)
        db.commit()
        return {"message": "Regla eliminada correctamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error al eliminar regla {regla_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

# ============================================================================
# ESTADÍSTICAS
# ============================================================================

@router.get("/stats/summary")
async def get_set_reglas_stats(db: Session = Depends(get_db)):
    """Obtener estadísticas de sets de reglas"""
    try:
        total = db.query(SetReglaModel).count()
        habilitados = db.query(SetReglaModel).filter(SetReglaModel.habilitado == True).count()
        deshabilitados = total - habilitados
        
        # Estadísticas de reglas por set
        sets_con_reglas = db.query(SetReglaModel.id, SetReglaModel.nombre, func.count(ReglaModel.id)).join(
            ReglaModel, SetReglaModel.id == ReglaModel.set_regla_id, isouter=True
        ).group_by(SetReglaModel.id, SetReglaModel.nombre).all()
        
        return {
            "total": total,
            "habilitados": habilitados,
            "deshabilitados": deshabilitados,
            "sets_con_reglas": [
                {"id": set_id, "nombre": nombre, "num_reglas": num_reglas}
                for set_id, nombre, num_reglas in sets_con_reglas
            ]
        }
        
    except Exception as e:
        logger.error(f"Error al obtener estadísticas de sets de reglas: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")
