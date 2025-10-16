# 🎵 Programador Musical

Sistema completo de programación musical desarrollado con FastAPI y Next.js.

## 🚀 Inicio Rápido

### Opción 1: Docker Compose (Recomendado)

```bash
# 1. Clonar el repositorio
git clone <repository-url>
cd programador-musical

# 2. Ejecutar el script de configuración automática
./setup-dev.sh
```

### Opción 2: Desarrollo Local

```bash
# 1. Configurar base de datos PostgreSQL
# Crear base de datos: programador-musical
# Usuario: postgres, Contraseña: postgres

# 2. Backend
cd backend
pip install -r requirements.txt
cp env.example .env
# Editar .env con tus configuraciones
uvicorn main:app --reload

# 3. Frontend (en otra terminal)
cd frontend
npm install
cp env.example .env.local
# Editar .env.local con tus configuraciones
npm run dev
```

## 📋 Servicios

- **Aplicación**: http://localhost (Nginx + Frontend + Backend)
- **Backend API**: http://localhost/api
- **Documentación API**: http://localhost/docs
- **Base de datos**: PostgreSQL en puerto 5432

## 🏗️ Arquitectura

```
programador-musical/
├── backend/          # API REST con FastAPI
├── frontend/         # Aplicación web con Next.js
├── nginx/            # Configuración de Nginx
├── postgres/         # Base de datos con datos iniciales
├── docker-compose.yml
├── setup-dev.sh      # Script de configuración
└── README-DOCKER.md  # Documentación Docker
```

## 🛠️ Tecnologías

### Backend
- **FastAPI** - Framework web moderno
- **PostgreSQL** - Base de datos
- **SQLAlchemy** - ORM
- **Alembic** - Migraciones

### Frontend
- **Next.js 14** - Framework React
- **Tailwind CSS** - Estilos
- **Lucide React** - Iconos

### Infraestructura
- **Nginx** - Proxy reverso y servidor web
- **PostgreSQL** - Base de datos con datos iniciales
- **Docker Compose** - Orquestación de contenedores

## 📚 Documentación

- [Docker Setup](README-DOCKER.md) - Configuración con Docker
- [Backend](backend/README.md) - Documentación de la API
- [Frontend](frontend/README.md) - Documentación del frontend

## 🔧 Comandos Útiles

```bash
# Ver estado de servicios
docker-compose ps

# Ver logs
docker-compose logs -f

# Parar servicios
docker-compose down

# Reconstruir
docker-compose up --build -d
```

## 📝 Módulos del Sistema

- **Catálogos**: Gestión de entidades
- **Categorías**: Categorías y canciones
- **Programación**: Políticas y programación
- **Reportes**: Reportes del sistema
- **Varios**: Configuraciones adicionales
