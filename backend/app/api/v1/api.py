from fastapi import APIRouter
from app.api.v1.endpoints import catalogos, categorias, programacion, reportes, varios, difusoras, politicas, import_csv, canciones

api_router = APIRouter()

# Incluir routers de cada módulo
api_router.include_router(catalogos.router, prefix="/catalogos", tags=["catalogos"])
api_router.include_router(categorias.router, prefix="/categorias", tags=["categorias"])
api_router.include_router(programacion.router, prefix="/programacion", tags=["programacion"])
api_router.include_router(reportes.router, prefix="/reportes", tags=["reportes"])
api_router.include_router(varios.router, prefix="/varios", tags=["varios"])
api_router.include_router(difusoras.router, prefix="/difusoras", tags=["difusoras"])
api_router.include_router(politicas.router, prefix="/politicas", tags=["politicas"])
api_router.include_router(import_csv.router, prefix="/import-csv", tags=["import-csv"])
api_router.include_router(canciones.router, prefix="/canciones", tags=["canciones"])
