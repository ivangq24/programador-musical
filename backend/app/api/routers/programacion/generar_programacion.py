from fastapi import APIRouter
from app.api.v1.endpoints.generar_programacion import router as generar_programacion_endpoint_router

# Crear el router para generar programación
router = APIRouter()

# Incluir el router de endpoints de generar programación
router.include_router(generar_programacion_endpoint_router, tags=["generar-programacion"])
