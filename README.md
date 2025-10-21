# 🎵 Programador Musical

Sistema de programación musical para estaciones de radio con gestión de políticas, programación automática y catálogos de música.

## 🚀 Inicio Rápido

### Prerrequisitos

- Docker y Docker Compose
- Git

### Instalación

1. **Clonar el repositorio:**
```bash
git clone <repository-url>
cd programador-musical
```

2. **Configurar entorno de desarrollo:**
```bash
chmod +x setup-dev.sh
./setup-dev.sh
```

3. **Acceder a la aplicación:**
- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- Documentación API: http://localhost:8000/docs

## 🏗️ Arquitectura

### Servicios

- **Frontend**: Next.js 14 con React
- **Backend**: FastAPI con Python 3.11
- **Base de Datos**: PostgreSQL 15
- **Proxy**: Nginx para enrutamiento

### Estructura del Proyecto

```
programador-musical/
├── frontend/                 # Aplicación Next.js
│   ├── src/
│   │   ├── app/             # App Router de Next.js
│   │   ├── pages/           # Páginas de la aplicación
│   │   ├── components/      # Componentes React
│   │   ├── api/             # Clientes API
│   │   └── styles/          # Estilos CSS
│   ├── Dockerfile
│   └── package.json
├── backend/                  # API FastAPI
│   ├── app/
│   │   ├── api/             # Endpoints de la API
│   │   ├── models/          # Modelos SQLAlchemy
│   │   ├── schemas/         # Esquemas Pydantic
│   │   └── services/        # Lógica de negocio
│   ├── alembic/             # Migraciones de DB
│   ├── Dockerfile
│   └── requirements.txt
├── postgres/                # Scripts de base de datos
│   ├── database.sql         # Schema y datos iniciales
│   └── backups/             # Backups de la DB
├── nginx/                   # Configuración del proxy
├── docker-compose.yml       # Orquestación de servicios
└── setup-dev.sh            # Script de configuración
```

## 🛠️ Desarrollo

### Comandos Útiles

```bash
# Ver logs de todos los servicios
docker compose logs -f

# Ver logs de un servicio específico
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f db

# Reiniciar un servicio
docker compose restart backend

# Parar todos los servicios
docker compose down

# Parar y eliminar volúmenes
docker compose down -v

# Reconstruir imágenes
docker compose build --no-cache
```

### Base de Datos

```bash
# Acceder a la base de datos
docker compose exec db psql -U postgres -d programador-musical

# Crear backup
docker compose exec db pg_dump -U postgres -d programador-musical > backup.sql

# Restaurar backup
docker compose exec -T db psql -U postgres -d programador-musical < backup.sql
```

## 📋 Funcionalidades

### Módulos Principales

1. **Catálogos**
   - Gestión de difusoras (estaciones de radio)
   - Catálogo de canciones
   - Categorías musicales
   - Cortes publicitarios

2. **Categorías y Canciones**
   - Mantenimiento de canciones
   - Importación desde CSV
   - Gestión de categorías

3. **Programación**
   - Políticas de programación
   - Generación automática de programación
   - Consulta de programación generada

4. **Reportes**
   - Reportes de programación
   - Estadísticas de uso

## 🔧 Configuración

### Variables de Entorno

El proyecto incluye archivos `.env.example` con las configuraciones por defecto:

- **Backend**: `backend/env.example`
- **Frontend**: `frontend/env.example`

### Puertos

- **Frontend**: 3000
- **Backend**: 8000
- **Base de Datos**: 5433
- **Nginx**: 80, 443

## 🐳 Docker

### Servicios Incluidos

- **db**: PostgreSQL 15 con datos iniciales
- **backend**: FastAPI con hot reload
- **frontend**: Next.js con hot reload
- **nginx**: Proxy reverso con configuración optimizada

### Health Checks

Todos los servicios incluyen health checks para monitoreo automático.

## 📚 API Documentation

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **OpenAPI JSON**: http://localhost:8000/openapi.json

## 🚀 Despliegue

### Producción

Para despliegue en producción:

1. Configurar variables de entorno de producción
2. Cambiar `SECRET_KEY` y credenciales de base de datos
3. Configurar dominio en nginx
4. Usar `docker-compose.prod.yml` (si existe)

### Variables de Entorno de Producción

```bash
# Base de datos
POSTGRES_PASSWORD=your-secure-password
DATABASE_URL=postgresql://user:password@db:5432/programador-musical

# Seguridad
SECRET_KEY=your-production-secret-key

# CORS
BACKEND_CORS_ORIGINS=["https://yourdomain.com"]
```

## 🤝 Contribución

1. Fork el proyecto
2. Crear una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 🆘 Soporte

Si tienes problemas:

1. Verificar que Docker esté ejecutándose
2. Revisar los logs: `docker compose logs`
3. Verificar que los puertos no estén ocupados
4. Reconstruir las imágenes: `docker compose build --no-cache`

## 📞 Contacto

Para soporte técnico o preguntas sobre el proyecto, contacta al equipo de desarrollo.