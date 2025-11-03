"""
Main API router that organizes all endpoints by module
"""
from fastapi import APIRouter

# Import all endpoint modules
from app.api.programacion import generar_programacion_completa, politicas, reglas
from app.api.catalogos import catalogos, difusoras, cortes
from app.api.categorias import categorias, canciones, import_csv
from app.api.reportes import estadisticas

# Create main router
api_router = APIRouter()

# Programacion module routes
api_router.include_router(
    generar_programacion_completa.router,
    prefix="/programacion",
    tags=["programacion-generar"]
)

api_router.include_router(
    politicas.router,
    prefix="/programacion/politicas",
    tags=["programacion-politicas"]
)

api_router.include_router(
    reglas.router,
    prefix="/programacion",
    tags=["programacion-reglas"]
)


# Catalogos module routes
api_router.include_router(
    catalogos.router,
    prefix="/catalogos",
    tags=["catalogos"]
)

api_router.include_router(
    difusoras.router,
    prefix="/catalogos/general/difusoras",
    tags=["catalogos-difusoras"]
)

api_router.include_router(
    cortes.router,
    prefix="/catalogos/general/cortes",
    tags=["catalogos-cortes"]
)

# Categorias module routes
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

# Reportes module routes
api_router.include_router(
    estadisticas.router,
    prefix="/reportes",
    tags=["reportes-estadisticas"]
)
