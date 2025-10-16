#!/bin/bash

# Script para probar servicios individualmente
set -e

echo "🧪 Probando servicios individualmente..."

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# 1. Probar base de datos
echo "🗄️ Probando PostgreSQL..."
docker-compose up -d db
sleep 10

if docker-compose exec -T db pg_isready -U postgres > /dev/null 2>&1; then
    print_success "PostgreSQL está funcionando"
else
    print_error "PostgreSQL no responde"
    exit 1
fi

# 2. Probar backend
echo "🔧 Probando Backend..."
docker-compose up -d backend
sleep 15

if curl -s http://localhost:8000/health > /dev/null; then
    print_success "Backend está funcionando en puerto 8000"
else
    print_warning "Backend no responde en puerto 8000, puede estar iniciando..."
fi

# 3. Probar frontend
echo "🎨 Probando Frontend..."
docker-compose up -d frontend
sleep 20

if curl -s http://localhost:3000 > /dev/null; then
    print_success "Frontend está funcionando en puerto 3000"
else
    print_warning "Frontend no responde en puerto 3000, puede estar iniciando..."
fi

# 4. Probar nginx
echo "🌐 Probando Nginx..."
docker-compose up -d nginx
sleep 5

if curl -s http://localhost/health > /dev/null; then
    print_success "Nginx está funcionando en puerto 80"
else
    print_warning "Nginx no responde en puerto 80, puede estar iniciando..."
fi

echo ""
echo "📋 Estado de los servicios:"
docker-compose ps

echo ""
echo "🎉 Pruebas completadas!"
