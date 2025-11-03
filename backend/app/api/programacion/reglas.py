from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.models.programacion import Regla as ReglaModel, SeparacionRegla as SeparacionReglaModel
from app.schemas.programacion import (
    ReglaCreate, ReglaUpdate, Regla, ReglaConSeparaciones,
    SeparacionReglaCreate, SeparacionReglaUpdate, SeparacionRegla
)
from typing import List

router = APIRouter()

@router.get("/politicas/{politica_id}/reglas", response_model=List[ReglaConSeparaciones])
def get_reglas_by_politica(politica_id: int, db: Session = Depends(get_db)):
    """Obtener todas las reglas de una política específica"""
    reglas = db.query(ReglaModel).filter(ReglaModel.politica_id == politica_id).all()
    return reglas

@router.get("/reglas/{regla_id}", response_model=ReglaConSeparaciones)
def get_regla(regla_id: int, db: Session = Depends(get_db)):
    """Obtener una regla específica por ID"""
    regla = db.query(ReglaModel).filter(ReglaModel.id == regla_id).first()
    if not regla:
        raise HTTPException(status_code=404, detail="Regla no encontrada")
    return regla

@router.post("/reglas", response_model=ReglaConSeparaciones)
def create_regla(regla: ReglaCreate, db: Session = Depends(get_db)):
    """Crear una nueva regla"""
    # Crear la regla principal
    db_regla = ReglaModel(
        politica_id=regla.politica_id,
        tipo_regla=regla.tipo_regla,
        caracteristica=regla.caracteristica,
        tipo_separacion=regla.tipo_separacion,
        descripcion=regla.descripcion,
        horario=regla.horario,
        solo_verificar_dia=regla.solo_verificar_dia,
        habilitada=regla.habilitada
    )
    db.add(db_regla)
    db.commit()
    db.refresh(db_regla)
    
    # Crear las separaciones asociadas
    for separacion_data in regla.separaciones:
        db_separacion = SeparacionReglaModel(
            regla_id=db_regla.id,
            valor=separacion_data.valor,
            separacion=separacion_data.separacion
        )
        db.add(db_separacion)
    
    db.commit()
    db.refresh(db_regla)
    return db_regla

@router.put("/reglas/{regla_id}", response_model=ReglaConSeparaciones)
def update_regla(regla_id: int, regla_update: ReglaUpdate, db: Session = Depends(get_db)):
    """Actualizar una regla existente"""
    db_regla = db.query(ReglaModel).filter(ReglaModel.id == regla_id).first()
    if not db_regla:
        raise HTTPException(status_code=404, detail="Regla no encontrada")
    
    # Actualizar campos de la regla
    update_data = regla_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        if field != 'separaciones':
            setattr(db_regla, field, value)
    
    # Actualizar separaciones si se proporcionan
    if regla_update.separaciones is not None:
        # Eliminar separaciones existentes
        db.query(SeparacionReglaModel).filter(SeparacionReglaModel.regla_id == regla_id).delete()
        
        # Crear nuevas separaciones
        for separacion_data in regla_update.separaciones:
            db_separacion = SeparacionReglaModel(
                regla_id=regla_id,
                valor=separacion_data.valor,
                separacion=separacion_data.separacion
            )
            db.add(db_separacion)
    
    db.commit()
    db.refresh(db_regla)
    return db_regla

@router.delete("/reglas/{regla_id}")
def delete_regla(regla_id: int, db: Session = Depends(get_db)):
    """Eliminar una regla"""
    db_regla = db.query(ReglaModel).filter(ReglaModel.id == regla_id).first()
    if not db_regla:
        raise HTTPException(status_code=404, detail="Regla no encontrada")
    
    db.delete(db_regla)
    db.commit()
    return {"message": "Regla eliminada correctamente"}

@router.get("/separaciones/{separacion_id}", response_model=SeparacionRegla)
def get_separacion(separacion_id: int, db: Session = Depends(get_db)):
    """Obtener una separación específica por ID"""
    separacion = db.query(SeparacionReglaModel).filter(SeparacionReglaModel.id == separacion_id).first()
    if not separacion:
        raise HTTPException(status_code=404, detail="Separación no encontrada")
    return separacion

@router.put("/separaciones/{separacion_id}", response_model=SeparacionRegla)
def update_separacion(separacion_id: int, separacion_update: SeparacionReglaUpdate, db: Session = Depends(get_db)):
    """Actualizar una separación existente"""
    db_separacion = db.query(SeparacionReglaModel).filter(SeparacionReglaModel.id == separacion_id).first()
    if not db_separacion:
        raise HTTPException(status_code=404, detail="Separación no encontrada")
    
    update_data = separacion_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_separacion, field, value)
    
    db.commit()
    db.refresh(db_separacion)
    return db_separacion

@router.delete("/separaciones/{separacion_id}")
def delete_separacion(separacion_id: int, db: Session = Depends(get_db)):
    """Eliminar una separación"""
    db_separacion = db.query(SeparacionReglaModel).filter(SeparacionReglaModel.id == separacion_id).first()
    if not db_separacion:
        raise HTTPException(status_code=404, detail="Separación no encontrada")
    
    db.delete(db_separacion)
    db.commit()
    return {"message": "Separación eliminada correctamente"}
