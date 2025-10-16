from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from app.core.database import get_db
from app.models.cortes import Corte
from app.schemas.cortes import CorteCreate, CorteUpdate, Corte as CorteSchema, CorteList

router = APIRouter()


@router.get("/", response_model=CorteList)
def get_cortes(
    skip: int = Query(0, ge=0, description="Número de registros a omitir"),
    limit: int = Query(100, ge=1, le=1000, description="Número de registros a retornar"),
    tipo: Optional[str] = Query(None, pattern=r'^(comercial|vacio)$', description="Filtrar por tipo"),
    activo: Optional[bool] = Query(None, description="Filtrar por estado activo"),
    search: Optional[str] = Query(None, description="Buscar por nombre o descripción"),
    db: Session = Depends(get_db)
):
    """
    Obtener lista de cortes con filtros opcionales
    """
    query = db.query(Corte)
    
    # Aplicar filtros
    if tipo:
        query = query.filter(Corte.tipo == tipo)
    
    if activo is not None:
        query = query.filter(Corte.activo == activo)
    
    if search:
        search_filter = f"%{search}%"
        query = query.filter(
            (Corte.nombre.ilike(search_filter)) |
            (Corte.descripcion.ilike(search_filter))
        )
    
    # Obtener total de registros
    total = query.count()
    
    # Aplicar paginación
    cortes = query.offset(skip).limit(limit).all()
    
    return CorteList(
        cortes=cortes,
        total=total,
        page=skip // limit + 1,
        size=limit
    )


@router.get("/{corte_id}", response_model=CorteSchema)
def get_corte(corte_id: int, db: Session = Depends(get_db)):
    """
    Obtener un corte por ID
    """
    corte = db.query(Corte).filter(Corte.id == corte_id).first()
    if not corte:
        raise HTTPException(status_code=404, detail="Corte no encontrado")
    return corte


@router.post("/", response_model=CorteSchema)
def create_corte(corte: CorteCreate, db: Session = Depends(get_db)):
    """
    Crear un nuevo corte
    """
    # Verificar si ya existe un corte con el mismo nombre
    existing_corte = db.query(Corte).filter(Corte.nombre == corte.nombre).first()
    if existing_corte:
        raise HTTPException(status_code=400, detail="Ya existe un corte con este nombre")
    
    db_corte = Corte(**corte.dict())
    db.add(db_corte)
    db.commit()
    db.refresh(db_corte)
    return db_corte


@router.put("/{corte_id}", response_model=CorteSchema)
def update_corte(corte_id: int, corte_update: CorteUpdate, db: Session = Depends(get_db)):
    """
    Actualizar un corte existente
    """
    db_corte = db.query(Corte).filter(Corte.id == corte_id).first()
    if not db_corte:
        raise HTTPException(status_code=404, detail="Corte no encontrado")
    
    # Verificar si el nuevo nombre ya existe (si se está actualizando)
    if corte_update.nombre and corte_update.nombre != db_corte.nombre:
        existing_corte = db.query(Corte).filter(
            Corte.nombre == corte_update.nombre,
            Corte.id != corte_id
        ).first()
        if existing_corte:
            raise HTTPException(status_code=400, detail="Ya existe un corte con este nombre")
    
    # Actualizar solo los campos proporcionados
    update_data = corte_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_corte, field, value)
    
    db.commit()
    db.refresh(db_corte)
    return db_corte


@router.delete("/{corte_id}")
def delete_corte(corte_id: int, db: Session = Depends(get_db)):
    """
    Eliminar un corte
    """
    db_corte = db.query(Corte).filter(Corte.id == corte_id).first()
    if not db_corte:
        raise HTTPException(status_code=404, detail="Corte no encontrado")
    
    db.delete(db_corte)
    db.commit()
    return {"message": "Corte eliminado exitosamente"}


@router.get("/stats/summary")
def get_cortes_stats(db: Session = Depends(get_db)):
    """
    Obtener estadísticas de cortes
    """
    total_cortes = db.query(Corte).count()
    cortes_activos = db.query(Corte).filter(Corte.activo == True).count()
    cortes_inactivos = db.query(Corte).filter(Corte.activo == False).count()
    cortes_comerciales = db.query(Corte).filter(Corte.tipo == 'comercial').count()
    cortes_vacios = db.query(Corte).filter(Corte.tipo == 'vacio').count()
    
    return {
        "total_cortes": total_cortes,
        "cortes_activos": cortes_activos,
        "cortes_inactivos": cortes_inactivos,
        "cortes_comerciales": cortes_comerciales,
        "cortes_vacios": cortes_vacios
    }
