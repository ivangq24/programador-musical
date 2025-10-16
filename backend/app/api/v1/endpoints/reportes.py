from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.core.database import get_db
from typing import List

router = APIRouter()

@router.get("/")
async def get_reportes(db: Session = Depends(get_db)):
    """Obtener lista de reportes disponibles"""
    return {"message": "Hello World - Reportes", "data": []}

@router.get("/generar/{reporte_id}")
async def generar_reporte(reporte_id: int, db: Session = Depends(get_db)):
    """Generar un reporte específico"""
    return {"message": f"Hello World - Generando Reporte {reporte_id}", "data": []}
