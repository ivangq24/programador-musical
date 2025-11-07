from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import or_, func
from typing import List
from app.core.database import get_db
from app.models.cortes import Corte as CorteModel
from app.schemas.cortes import CorteCreate, CorteUpdate, Corte

router = APIRouter()

# Obtener lista de cortes
@router.get("/", response_model=List[Corte])
async def get_cortes(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    search: str = Query(None),
    activo: bool = Query(None),
    db: Session = Depends(get_db)
):
    try:
        query = db.query(CorteModel)
        
        if search:
            query = query.filter(
                or_(
                    CorteModel.nombre.ilike(f"%{search}%"),
                    CorteModel.descripcion.ilike(f"%{search}%")
                )
            )
        
        if activo is not None:
            query = query.filter(CorteModel.activo == activo)
        
        cortes = query.offset(skip).limit(limit).all()
        return cortes
    except Exception as e:

        return []

# Obtener un corte específico
@router.get("/{corte_id}", response_model=Corte)
async def get_corte(corte_id: int, db: Session = Depends(get_db)):
    corte = db.query(CorteModel).filter(CorteModel.id == corte_id).first()
    if not corte:
        raise HTTPException(status_code=404, detail="Corte no encontrado")
    return corte

# Crear un nuevo corte
@router.post("/", response_model=Corte)
async def create_corte(corte: CorteCreate, db: Session = Depends(get_db)):
    db_corte = CorteModel(
ombre=corte.nombre,
        descripcion=corte.descripcion,
        duracion=corte.duracion,
        tipo=corte.tipo,
        activo=corte.activo,
        observaciones=corte.observaciones
    )
    db.add(db_corte)
    db.commit()
    db.refresh(db_corte)
    return db_corte

# Actualizar un corte
@router.put("/{corte_id}", response_model=Corte)
async def update_corte(corte_id: int, corte: CorteUpdate, db: Session = Depends(get_db)):
    db_corte = db.query(CorteModel).filter(CorteModel.id == corte_id).first()
    if not db_corte:
        raise HTTPException(status_code=404, detail="Corte no encontrado")
    
    update_data = corte.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_corte, field, value)
    
    db.commit()
    db.refresh(db_corte)
    return db_corte

# Eliminar un corte
@router.delete("/{corte_id}")
async def delete_corte(corte_id: int, db: Session = Depends(get_db)):
    corte = db.query(CorteModel).filter(CorteModel.id == corte_id).first()
    if not corte:
        raise HTTPException(status_code=404, detail="Corte no encontrado")
    
    db.delete(corte)
    db.commit()
    return {"message": "Corte eliminado exitosamente"}

# Obtener estadísticas de cortes
@router.get("/stats/summary")
async def get_cortes_stats(db: Session = Depends(get_db)):
    total = db.query(CorteModel).count()
    activos = db.query(CorteModel).filter(CorteModel.activo == True).count()
    inactivos = total - activos
    
    return {
        "total": total,
        "activos": activos,
        "inactivos": inactivos
    }
