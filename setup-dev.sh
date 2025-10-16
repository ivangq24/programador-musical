#!/bin/bash

# Script de configuración para desarrollo del Programador Musical
# Este script configura y ejecuta el entorno de desarrollo con Docker Compose

set -e  # Salir si hay algún error

echo "🎵 Configurando entorno de desarrollo para Programador Musical..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con color
print_message() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que Docker y Docker Compose estén instalados
check_docker() {
    print_message "Verificando instalación de Docker..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker no está instalado. Por favor instala Docker primero."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        print_error "Docker Compose no está instalado. Por favor instala Docker Compose primero."
        exit 1
    fi
    
    print_success "Docker y Docker Compose están instalados"
}

# Crear archivos .env si no existen
setup_env_files() {
    print_message "Configurando archivos de entorno..."
    
    # Archivo .env principal del proyecto
    if [ ! -f ".env" ]; then
        print_message "Creando .env principal..."
        cat > .env << EOF
# Base de Datos
POSTGRES_DB=programador-musical
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_HOST=db
POSTGRES_PORT=5432

# Backend API
DATABASE_URL=postgresql://postgres:postgres@db:5432/programador-musical
SECRET_KEY=dev-secret-key-change-in-production
ACCESS_TOKEN_EXPIRE_MINUTES=30
API_V1_STR=/api/v1
PROJECT_NAME=Programador Musical
BACKEND_CORS_ORIGINS=["http://localhost:3000"]

# Frontend
NEXT_PUBLIC_API_URL=http://localhost/api
NODE_ENV=development

# Docker Compose
COMPOSE_PROJECT_NAME=programador-musical
EOF
        print_success "Archivo .env principal creado"
    else
        print_warning "El archivo .env principal ya existe"
    fi
    
    # Backend .env
    if [ ! -f "backend/.env" ]; then
        print_message "Creando backend/.env..."
        cat > backend/.env << EOF
# Database Configuration
DATABASE_URL=postgresql://postgres:postgres@db:5432/programador-musical

# Security
SECRET_KEY=dev-secret-key-change-in-production
ACCESS_TOKEN_EXPIRE_MINUTES=30

# API Configuration
API_V1_STR=/api/v1
PROJECT_NAME=Programador Musical

# CORS
BACKEND_CORS_ORIGINS=["http://localhost:3000"]
EOF
        print_success "Archivo backend/.env creado"
    else
        print_warning "El archivo backend/.env ya existe"
    fi
    
    # Frontend .env.local
    if [ ! -f "frontend/.env.local" ]; then
        print_message "Creando frontend/.env.local..."
        cat > frontend/.env.local << EOF
# API Configuration
NEXT_PUBLIC_API_URL=http://localhost/api

# Development Configuration
NODE_ENV=development
EOF
        print_success "Archivo frontend/.env.local creado"
    else
        print_warning "El archivo frontend/.env.local ya existe"
    fi
}

# Limpiar contenedores y volúmenes existentes
cleanup() {
    print_message "Limpiando contenedores y volúmenes existentes..."
    
    # Detener y eliminar contenedores
    docker-compose down --remove-orphans 2>/dev/null || true
    
    # Eliminar volúmenes huérfanos
    docker volume prune -f 2>/dev/null || true
    
    print_success "Limpieza completada"
}

# Construir y ejecutar servicios
start_services() {
    print_message "Construyendo y ejecutando servicios..."
    
    # Construir imágenes
    print_message "Construyendo imágenes de Docker..."
    docker-compose build --no-cache
    
    # Ejecutar servicios en modo detached
    print_message "Iniciando servicios..."
    docker-compose up -d
    
    print_success "Servicios iniciados en modo detached"
}

# Verificar estado de los servicios
check_services() {
    print_message "Verificando estado de los servicios..."
    
    # Esperar a que los servicios estén listos
    print_message "Esperando a que los servicios estén listos..."
    sleep 10
    
    # Verificar estado de los contenedores
    echo ""
    print_message "Estado de los contenedores:"
    docker-compose ps
    
    echo ""
    print_message "Verificando conectividad..."
    
    # Verificar backend
    if curl -s http://localhost:8000/health > /dev/null; then
        print_success "✅ Backend (FastAPI) está funcionando en http://localhost:8000"
    else
        print_warning "⚠️  Backend no responde aún, puede estar iniciando..."
    fi
    
    # Verificar frontend
    if curl -s http://localhost:3000 > /dev/null; then
        print_success "✅ Frontend (Next.js) está funcionando en http://localhost:3000"
    else
        print_warning "⚠️  Frontend no responde aún, puede estar iniciando..."
    fi
    
    # Verificar base de datos
    if docker-compose exec -T db pg_isready -U postgres > /dev/null 2>&1; then
        print_success "✅ Base de datos PostgreSQL está funcionando"
    else
        print_warning "⚠️  Base de datos no responde aún, puede estar iniciando..."
    fi
}

# Mostrar información útil
show_info() {
    echo ""
    echo "🎵 =============================================="
    echo "   PROGRAMADOR MUSICAL - ENTORNO DE DESARROLLO"
    echo "=============================================="
    echo ""
    echo "📋 Servicios disponibles:"
    echo "   • Frontend:       http://localhost:3000"
    echo "   • Backend API:    http://localhost:8000"
    echo "   • Documentación:  http://localhost:8000/docs"
    echo "   • Base de datos:  localhost:5433"
    echo ""
    echo "📚 Comandos útiles:"
    echo "   • Ver logs:       docker-compose logs -f"
    echo "   • Parar servicios: docker-compose down"
    echo "   • Reiniciar:      docker-compose restart"
    echo "   • Estado:         docker-compose ps"
    echo ""
    echo "🔧 Para desarrollo:"
    echo "   • Los cambios en el código se reflejan automáticamente"
    echo "   • Backend: Hot reload habilitado"
    echo "   • Frontend: Hot reload habilitado"
    echo ""
    echo "📖 Documentación de la API:"
    echo "   • Swagger UI:     http://localhost:8000/docs"
    echo "   • ReDoc:          http://localhost:8000/redoc"
    echo ""
}

# Función principal
main() {
    echo "🎵 Iniciando configuración del entorno de desarrollo..."
    echo ""
    
    check_docker
    setup_env_files
    cleanup
    start_services
    check_services
    show_info
    
    print_success "¡Entorno de desarrollo configurado exitosamente! 🎉"
    print_message "Puedes comenzar a desarrollar. Los servicios están ejecutándose en segundo plano."
}

# Ejecutar función principal
main "$@"
