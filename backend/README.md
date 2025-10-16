# Backend - Programador Musical

API REST desarrollada con FastAPI para el sistema de programación musical.

## 🚀 Tecnologías

- **FastAPI** - Framework web moderno y rápido
- **PostgreSQL** - Base de datos relacional
- **SQLAlchemy** - ORM para Python
- **Alembic** - Migraciones de base de datos
- **Pydantic** - Validación de datos

## 🛠️ Desarrollo Local

```bash
# Instalar dependencias
pip install -r requirements.txt

# Configurar variables de entorno
cp env.example .env

# Ejecutar migraciones
alembic upgrade head

# Ejecutar servidor
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

## 📚 Documentación API

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/health

## 🔧 Endpoints Principales

- **Catálogos**: `/api/v1/catalogos/`
- **Categorías**: `/api/v1/categorias/`
- **Programación**: `/api/v1/programacion/`
- **Reportes**: `/api/v1/reportes/`
- **Varios**: `/api/v1/varios/`
