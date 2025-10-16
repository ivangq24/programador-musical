# 👨‍💻 Guía para Desarrolladores

Esta guía te ayudará a configurar el entorno de desarrollo del Programador Musical desde cero.

## 📋 Requisitos Previos

- **Docker** (versión 20.10 o superior)
- **Docker Compose** (versión 2.0 o superior)
- **Git**

## 🚀 Configuración Inicial

### 1. Clonar el Repositorio

```bash
git clone <repository-url>
cd programador-musical
```

### 2. Configuración Automática (Recomendado)

```bash
# Ejecutar script de configuración
./setup-dev.sh
```

Este script automáticamente:
- ✅ Verifica que Docker esté instalado
- ✅ Crea archivos `.env` necesarios
- ✅ Limpia contenedores existentes
- ✅ Construye y ejecuta todos los servicios
- ✅ Verifica que todo esté funcionando

### 3. Configuración Manual

Si prefieres configurar manualmente:

```bash
# 1. Crear archivos de entorno
cp backend/env.example backend/.env
cp frontend/env.example frontend/.env.local

# 2. Editar configuraciones según tu entorno
# backend/.env
# frontend/.env.local

# 3. Ejecutar servicios
docker-compose up --build -d
```

## 🔧 Desarrollo

### Estructura del Proyecto

```
programador-musical/
├── backend/          # API REST con FastAPI
├── frontend/         # Aplicación web con Next.js
├── nginx/            # Configuración de Nginx
├── postgres/         # Base de datos con datos iniciales
├── docker-compose.yml
├── setup-dev.sh      # Script de configuración
└── README.md
```

### Servicios Disponibles

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **Documentación API**: http://localhost:8000/docs
- **Base de datos**: localhost:5432

### Comandos Útiles

```bash
# Ver estado de servicios
docker-compose ps

# Ver logs
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f db

# Parar servicios
docker-compose down

# Reiniciar un servicio
docker-compose restart backend

# Reconstruir y ejecutar
docker-compose up --build -d
```

### Desarrollo con Hot Reload

- **Backend**: Los cambios en Python se reflejan automáticamente
- **Frontend**: Los cambios en React/Next.js se reflejan automáticamente
- **Base de datos**: Los datos persisten entre reinicios

## 🐛 Solución de Problemas

### Puerto ya en uso

```bash
# Verificar qué proceso usa el puerto
lsof -i :8000
lsof -i :3000
lsof -i :5432
```

### Contenedores no inician

```bash
# Ver logs detallados
docker-compose logs

# Reconstruir desde cero
docker-compose down -v
docker-compose up --build -d
```

### Base de datos no conecta

```bash
# Verificar que PostgreSQL esté listo
docker-compose exec db pg_isready -U postgres

# Ver logs de la base de datos
docker-compose logs db
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

1. Asegúrate de que el entorno de desarrollo funcione correctamente
2. Haz tus cambios en el código
3. Los cambios se reflejarán automáticamente gracias al hot reload
4. Prueba tus cambios en http://localhost:3000 y http://localhost:8000
