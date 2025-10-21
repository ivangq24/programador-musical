from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.core.database import get_db
from typing import List

router = APIRouter()

# Categorías endpoints
@router.get("/categorias/mantenimiento")
async def get_mantenimiento_categorias(db: Session = Depends(get_db)):
    """Obtener mantenimiento de categorías"""
    return {"message": "Hello World - Mantenimiento de Categorías", "data": []}

@router.get("/categorias/movimientos")
async def get_movimientos_categorias(db: Session = Depends(get_db)):
    """Obtener movimientos entre categorías"""
    return {"message": "Hello World - Movimientos entre Categorías", "data": []}

# Conjuntos endpoints
@router.get("/conjuntos/mantenimiento")
async def get_mantenimiento_conjuntos(db: Session = Depends(get_db)):
    """Obtener mantenimiento en conjuntos"""
    return {"message": "Hello World - Mantenimiento en Conjuntos", "data": []}

# Canciones endpoints
@router.get("/canciones/mantenimiento")
async def get_mantenimiento_canciones(db: Session = Depends(get_db)):
    """Obtener mantenimiento de canciones"""
    return {"message": "Hello World - Mantenimiento de Canciones", "data": []}

@router.post("/canciones/importar-csv")
async def importar_csv_canciones(db: Session = Depends(get_db)):
    """Importar canciones desde CSV"""
    return {"message": "Hello World - Importar a CSV", "data": []}
