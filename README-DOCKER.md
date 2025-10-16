# 🎵 Programador Musical - Entorno de Desarrollo con Docker

Este documento describe cómo configurar y ejecutar el entorno de desarrollo del Programador Musical usando Docker Compose.

## 📋 Requisitos Previos

- Docker (versión 20.10 o superior)
- Docker Compose (versión 2.0 o superior)
- Git

## 🚀 Inicio Rápido

### Opción 1: Script Automático (Recomendado)

```bash
# Ejecutar el script de configuración
./setup-dev.sh
```

Este script automáticamente:
- Verifica que Docker esté instalado
- Crea los archivos `.env` necesarios
- Limpia contenedores existentes
- Construye y ejecuta todos los servicios
- Verifica que todo esté funcionando

### Opción 2: Comandos Manuales

```bash
# 1. Crear archivos de entorno (si no existen)
cp backend/env.example backend/.env
cp frontend/env.example frontend/.env.local

# 2. Construir y ejecutar servicios
docker-compose up --build -d

# 3. Verificar estado
docker-compose ps
```

## 🏗️ Arquitectura del Sistema

El entorno de desarrollo incluye los siguientes servicios:

### 🌐 Nginx (Proxy Reverso)
- **Puerto**: 80, 443
- **URL**: http://localhost
- **Funciones**: Proxy reverso, balanceador de carga, SSL termination

### 🗄️ Base de Datos (PostgreSQL)
- **Puerto**: 5432
- **Base de datos**: `programador-musical`
- **Usuario**: `postgres`
- **Contraseña**: `Rock123456`
- **Datos iniciales**: Cargados desde `postgres/database.sql`

### 🔧 Backend (FastAPI)
- **Puerto interno**: 8000
- **URL**: http://localhost/api
- **Documentación API**: http://localhost/docs
- **Health Check**: http://localhost/api/health

### 🎨 Frontend (Next.js)
- **Puerto interno**: 3000
- **URL**: http://localhost
- **Hot Reload**: Habilitado

## 📁 Estructura de Archivos

```
programador-musical/
├── docker-compose.yml          # Configuración de servicios
├── setup-dev.sh               # Script de configuración automática
├── nginx/                      # Configuración de Nginx
│   ├── nginx.conf             # Configuración principal
│   └── conf.d/
│       └── default.conf        # Configuración del sitio
├── postgres/                   # Base de datos
│   └── database.sql           # Datos iniciales
├── backend/
│   ├── Dockerfile             # Imagen del backend
│   ├── .env                   # Variables de entorno (creado automáticamente)
│   └── ...
├── frontend/
│   ├── Dockerfile             # Imagen del frontend
│   ├── .env.local             # Variables de entorno (creado automáticamente)
│   └── ...
└── README-DOCKER.md           # Este archivo
```

## 🛠️ Comandos Útiles

### Gestión de Servicios

```bash
# Ver estado de los servicios
docker-compose ps

# Ver logs en tiempo real
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f db

# Parar todos los servicios
docker-compose down

# Parar y eliminar volúmenes
docker-compose down -v

# Reiniciar un servicio específico
docker-compose restart backend

# Reconstruir y ejecutar
docker-compose up --build -d
```

### Desarrollo

```bash
# Ejecutar comandos en el backend
docker-compose exec backend bash
docker-compose exec backend python -m alembic upgrade head

# Ejecutar comandos en el frontend
docker-compose exec frontend bash
docker-compose exec frontend npm install

# Ejecutar comandos en la base de datos
docker-compose exec db psql -U postgres -d programador-musical
```

### Debugging

```bash
# Ver logs detallados
docker-compose logs --tail=100 -f

# Verificar conectividad
curl http://localhost:8000/health
curl http://localhost:3000

# Verificar base de datos
docker-compose exec db pg_isready -U postgres
```

## 🔧 Configuración de Desarrollo

### Variables de Entorno

#### Backend (.env)
```env
DATABASE_URL=postgresql://postgres:Rock123456@db:5432/programador-musical
SECRET_KEY=dev-secret-key-change-in-production
ACCESS_TOKEN_EXPIRE_MINUTES=30
API_V1_STR=/api/v1
PROJECT_NAME=Programador Musical
BACKEND_CORS_ORIGINS=["http://localhost:3000"]
```

#### Frontend (.env.local)
```env
NEXT_PUBLIC_API_URL=http://localhost:8000
```

### Hot Reload

- **Backend**: Los cambios en el código Python se reflejan automáticamente
- **Frontend**: Los cambios en React/Next.js se reflejan automáticamente
- **Base de datos**: Los datos persisten entre reinicios

## 🐛 Solución de Problemas

### Problemas Comunes

1. **Puerto ya en uso**
   ```bash
   # Verificar qué proceso usa el puerto
   lsof -i :8000
   lsof -i :3000
   lsof -i :5432
   
   # Parar el proceso o cambiar puertos en docker-compose.yml
   ```

2. **Contenedores no inician**
   ```bash
   # Ver logs detallados
   docker-compose logs
   
   # Reconstruir desde cero
   docker-compose down -v
   docker-compose up --build -d
   ```

3. **Base de datos no conecta**
   ```bash
   # Verificar que PostgreSQL esté listo
   docker-compose exec db pg_isready -U postgres
   
   # Ver logs de la base de datos
   docker-compose logs db
   ```

4. **Frontend no carga**
   ```bash
   # Verificar que Next.js esté compilando
   docker-compose logs frontend
   
   # Reinstalar dependencias
   docker-compose exec frontend npm install
   ```

### Limpieza Completa

```bash
# Parar y eliminar todo
docker-compose down -v --remove-orphans

# Eliminar imágenes
docker-compose down --rmi all

# Limpiar sistema Docker
docker system prune -a
```

## 📚 Recursos Adicionales

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Next.js Documentation](https://nextjs.org/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 🤝 Contribución

Para contribuir al proyecto:

1. Asegúrate de que el entorno de desarrollo funcione correctamente
2. Haz tus cambios en el código
3. Los cambios se reflejarán automáticamente gracias al hot reload
4. Prueba tus cambios en http://localhost:3000 y http://localhost:8000

## 📞 Soporte

Si tienes problemas con el entorno de desarrollo:

1. Revisa los logs: `docker-compose logs`
2. Verifica el estado: `docker-compose ps`
3. Consulta este README
4. Revisa la documentación de Docker y Docker Compose
