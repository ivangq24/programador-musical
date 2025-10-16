from fastapi import APIRouter
from .catalogos.difusoras import difusoras_router
from .catalogos.cortes import cortes_router
from .categorias.canciones import canciones_router
from .contratos.contratos import contratos_router
from .cuentaspocobrar.cuentaspocobrar import router as cuentaspocobrar_router
from .facturas.facturas import router as facturas_router
from .programacion.importcsv import importcsv_router
from .programacion.politicas import politicas_router
from .programacion.set_reglas import router as set_reglas_router
from .programacion.generar_programacion import router as generar_programacion_router
from app.api.v1.endpoints.generar_programacion_simple import router as generar_programacion_simple_router
from app.api.v1.endpoints.generar_programacion_completa import router as generar_programacion_completa_router
from .programacion.programacion import router as programacion_router
from .reportes.reportes import router as reportes_router
from .varios.varios import router as varios_router

# Crear el router principal
api_router = APIRouter()

# Incluir routers de cada módulo siguiendo la estructura del frontend
api_router.include_router(difusoras_router, prefix="/catalogos/difusoras", tags=["catalogos-difusoras"])
api_router.include_router(cortes_router, prefix="/catalogos/cortes", tags=["catalogos-cortes"])
api_router.include_router(canciones_router, prefix="/categorias/canciones", tags=["categorias-canciones"])
api_router.include_router(contratos_router, prefix="/contratos/contratos", tags=["contratos-contratos"])
api_router.include_router(cuentaspocobrar_router, prefix="/cuentaspocobrar", tags=["cuentaspocobrar"])
api_router.include_router(facturas_router, prefix="/facturas", tags=["facturas"])
api_router.include_router(importcsv_router, prefix="/programacion/importcsv", tags=["programacion-importcsv"])
api_router.include_router(politicas_router, prefix="/programacion", tags=["programacion-politicas"])
api_router.include_router(set_reglas_router, prefix="/programacion/set-reglas", tags=["programacion-set-reglas"])
api_router.include_router(generar_programacion_router, prefix="/programacion", tags=["programacion-generar"])
api_router.include_router(generar_programacion_simple_router, prefix="/programacion", tags=["programacion-generar-simple"])
api_router.include_router(generar_programacion_completa_router, prefix="/programacion", tags=["programacion-generar-completa"])
# Incluir programacion_router al final para evitar conflictos de rutas
# Las rutas específicas deben ir antes que las rutas genéricas como /{programacion_id}
api_router.include_router(programacion_router, prefix="/programacion", tags=["programacion"])
api_router.include_router(reportes_router, prefix="/reportes", tags=["reportes"])
api_router.include_router(varios_router, prefix="/varios", tags=["varios"])
