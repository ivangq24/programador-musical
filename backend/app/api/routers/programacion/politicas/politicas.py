from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.api.v1.endpoints.politicas import router as politicas_endpoint_router

# Crear el router para políticas
router = APIRouter()

# Incluir el router de endpoints de políticas
router.include_router(politicas_endpoint_router, prefix="/politicas", tags=["politicas"])
