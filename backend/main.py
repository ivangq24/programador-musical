from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.main_router import api_router

app = FastAPI(
    title="Programador Musical API",
    description="API para el sistema de programación musical",
    version="1.0.0",
    openapi_url=f"{settings.API_V1_STR}/openapi.json"
)

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins for production
    allow_credentials=False,  # Set to False when using allow_origins=["*"]
    allow_methods=["*"],
    allow_headers=["*"],
)

# Incluir rutas de la API
app.include_router(api_router, prefix=settings.API_V1_STR)

@app.get("/")
async def root():
    return {"message": "Programador Musical API - Backend funcionando correctamente"}

@app.get("/health")
async def health_check():
    """Enhanced health check for production deployment"""
    try:
        from app.core.database import get_db
        from sqlalchemy import text
        
        # Test database connection
        db = next(get_db())
        result = db.execute(text("SELECT 1"))
        result.fetchone()
        db.close()
        
        return {
            "status": "healthy",
            "database": "connected",
            "message": "All systems operational",
            "version": "1.0.0"
        }
    except Exception as e:
        return {
            "status": "unhealthy",
            "database": "disconnected",
            "error": str(e),
            "message": "Service degraded"
        }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
