from fastapi import APIRouter
from app.api.v1.endpoints.set_reglas import router as set_reglas_endpoint_router

# Crear el router para set de reglas
router = APIRouter()

# Incluir el router de endpoints de set de reglas
router.include_router(set_reglas_endpoint_router, tags=["set-reglas"])
