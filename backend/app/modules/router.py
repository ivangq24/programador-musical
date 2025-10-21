"""
Main router for all modules
"""
from fastapi import APIRouter
from app.modules.programacion.endpoints import generar_programacion_completa, politicas, set_reglas
from app.modules.catalogos.endpoints import catalogos, difusoras
from app.modules.categorias.endpoints import categorias, canciones, import_csv

# Create main router
api_router = APIRouter()

# Programacion module
api_router.include_router(
    generar_programacion_completa.router,
    prefix="/programacion",
    tags=["programacion-generar"]
)

api_router.include_router(
    politicas.router,
    prefix="/programacion",
    tags=["programacion-politicas"]
)

api_router.include_router(
    set_reglas.router,
    prefix="/programacion",
    tags=["programacion-reglas"]
)

# Catalogos module
api_router.include_router(
    catalogos.router,
    prefix="/catalogos",
    tags=["catalogos"]
)

api_router.include_router(
    difusoras.router,
    prefix="/catalogos",
    tags=["catalogos-difusoras"]
)

# Categorias module
api_router.include_router(
    categorias.router,
    prefix="/categorias",
    tags=["categorias"]
)

api_router.include_router(
    canciones.router,
    prefix="/categorias",
    tags=["categorias-canciones"]
)

api_router.include_router(
    import_csv.router,
    prefix="/categorias",
    tags=["categorias-import"]
)
