from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.core.database import get_db
from typing import List

router = APIRouter()

@router.get("/")
async def get_varios(db: Session = Depends(get_db)):
    """Obtener configuraciones varias"""
    return {"message": "Hello World - Varios", "data": []}

@router.get("/configuracion")
async def get_configuracion(db: Session = Depends(get_db)):
    """Obtener configuración del sistema"""
    return {"message": "Hello World - Configuración", "data": []}
