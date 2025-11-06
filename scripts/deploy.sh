#!/bin/bash

# Production Deployment Script for Programador Musical
# This script handles the deployment process for production environment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
COMPOSE_FILE="docker-compose.prod.yml"
ENV_FILE=".env.prod"
BACKUP_DIR="./backups"
SSL_DIR="./ssl"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_requirements() {
    log_info "Checking requirements..."
    
    # Check if Docker is installed and running
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        log_error "Docker is not running"
        exit 1
    fi
    
    # Check if Docker Compose is available
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        log_error "Docker Compose is not available"
        exit 1
    fi
    
    # Check if production environment file exists
    if [ ! -f "$ENV_FILE" ]; then
        log_error "Production environment file $ENV_FILE not found"
        log_info "Please copy .env.prod.example to .env.prod and configure it"
        exit 1
    fi
    
    log_success "Requirements check passed"
}

setup_ssl() {
    log_info "Setting up SSL certificates..."
    
    if [ ! -d "$SSL_DIR" ]; then
        mkdir -p "$SSL_DIR"
        log_info "Created SSL directory: $SSL_DIR"
    fi
    
    if [ ! -f "$SSL_DIR/cert.pem" ] || [ ! -f "$SSL_DIR/key.pem" ]; then
        log_warning "SSL certificates not found"
        log_info "Generating self-signed certificates for testing..."
        
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout "$SSL_DIR/key.pem" \
            -out "$SSL_DIR/cert.pem" \
            -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
        
        log_warning "Self-signed certificates generated. Replace with proper certificates for production!"
    else
        log_success "SSL certificates found"
    fi
}

backup_database() {
    log_info "Creating database backup..."
    
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
    fi
    
    # Check if database container is running
    if docker ps --format "table {{.Names}}" | grep -q "programador-musical-db-prod"; then
        TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
        BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.sql"
        
        docker exec programador-musical-db-prod pg_dump -U postgres -d programador_musical_prod > "$BACKUP_FILE"
        log_success "Database backup created: $BACKUP_FILE"
    else
        log_warning "Database container not running, skipping backup"
    fi
}

build_images() {
    log_info "Building production images..."
    
    # Build images with no cache for production
    docker-compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" build --no-cache
    
    log_success "Images built successfully"
}

deploy() {
    log_info "Starting deployment..."
    
    # Stop existing containers
    log_info "Stopping existing containers..."
    docker-compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" down
    
    # Start services
    log_info "Starting services..."
    docker-compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" up -d
    
    # Wait for services to be healthy
    log_info "Waiting for services to be healthy..."
    sleep 30
    
    # Check service health
    check_health
    
    log_success "Deployment completed successfully"
}

check_health() {
    log_info "Checking service health..."
    
    # Check database
    if docker-compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" exec -T db pg_isready -U postgres; then
        log_success "Database is healthy"
    else
        log_error "Database health check failed"
        return 1
    fi
    
    # Check backend
    sleep 10
    if curl -f http://localhost/api/health &> /dev/null; then
        log_success "Backend is healthy"
    else
        log_error "Backend health check failed"
        return 1
    fi
    
    # Check frontend through nginx
    if curl -f http://localhost/health &> /dev/null; then
        log_success "Frontend is healthy"
    else
        log_error "Frontend health check failed"
        return 1
    fi
    
    log_success "All services are healthy"
}

show_logs() {
    log_info "Showing service logs..."
    docker-compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" logs --tail=50
}

show_status() {
    log_info "Service status:"
    docker-compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" ps
}

cleanup() {
    log_info "Cleaning up unused Docker resources..."
    docker system prune -f
    docker volume prune -f
    log_success "Cleanup completed"
}

# Main script
case "${1:-deploy}" in
    "check")
        check_requirements
        ;;
    "ssl")
        setup_ssl
        ;;
    "backup")
        backup_database
        ;;
    "build")
        check_requirements
        build_images
        ;;
    "deploy")
        check_requirements
        setup_ssl
        backup_database
        build_images
        deploy
        ;;
    "health")
        check_health
        ;;
    "logs")
        show_logs
        ;;
    "status")
        show_status
        ;;
    "cleanup")
        cleanup
        ;;
    "stop")
        log_info "Stopping all services..."
        docker-compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" down
        log_success "Services stopped"
        ;;
    *)
        echo "Usage: $0 {check|ssl|backup|build|deploy|health|logs|status|cleanup|stop}"
        echo ""
        echo "Commands:"
        echo "  check   - Check deployment requirements"
        echo "  ssl     - Setup SSL certificates"
        echo "  backup  - Create database backup"
        echo "  build   - Build production images"
        echo "  deploy  - Full deployment (default)"
        echo "  health  - Check service health"
        echo "  logs    - Show service logs"
        echo "  status  - Show service status"
        echo "  cleanup - Clean unused Docker resources"
        echo "  stop    - Stop all services"
        exit 1
        ;;
esac