#!/bin/bash

# Production setup script for Programador Musical
# This script prepares the environment for production deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Generate secure random strings
generate_secret() {
    openssl rand -base64 32
}

generate_password() {
    openssl rand -base64 24 | tr -d "=+/" | cut -c1-20
}

log_info "Setting up production environment for Programador Musical..."

# Create production environment file
if [ ! -f ".env.prod" ]; then
    log_info "Creating production environment file..."
    
    # Generate secure secrets
    DB_PASSWORD=$(generate_password)
    JWT_SECRET=$(generate_secret)
    
    cat > .env.prod << EOF
# Production Environment Variables
# Generated on $(date)

# Database Configuration
POSTGRES_DB=programador_musical_prod
POSTGRES_USER=programador_user
POSTGRES_PASSWORD=${DB_PASSWORD}
DATABASE_URL=postgresql://programador_user:${DB_PASSWORD}@db:5432/programador_musical_prod

# Security
SECRET_KEY=${JWT_SECRET}
ACCESS_TOKEN_EXPIRE_MINUTES=1440

# API Configuration
API_V1_STR=/api/v1
PROJECT_NAME=Programador Musical

# CORS Configuration (update with your domain)
BACKEND_CORS_ORIGINS=["https://yourdomain.com"]

# Frontend Configuration
NODE_ENV=production
NEXT_PUBLIC_API_URL=https://yourdomain.com/api

# Monitoring
LOG_LEVEL=INFO
EOF

    log_success "Production environment file created: .env.prod"
    log_warning "Please update BACKEND_CORS_ORIGINS and NEXT_PUBLIC_API_URL with your actual domain"
else
    log_info "Production environment file already exists"
fi

# Create Terraform variables file
if [ ! -f "aws/terraform/terraform.tfvars" ]; then
    log_info "Creating Terraform variables file..."
    
    # Read values from .env.prod if it exists
    if [ -f ".env.prod" ]; then
        source .env.prod
    fi
    
    cat > aws/terraform/terraform.tfvars << EOF
# AWS Configuration
aws_region = "us-east-1"
environment = "production"
project_name = "programador-musical"

# Domain Configuration (update with your domain)
domain_name = ""  # e.g., "yourdomain.com"

# Database Configuration
database_name = "${POSTGRES_DB:-programador_musical}"
database_username = "${POSTGRES_USER:-programador_user}"
database_password = "${POSTGRES_PASSWORD:-$(generate_password)}"

# Application Configuration
jwt_secret_key = "${SECRET_KEY:-$(generate_secret)}"
backend_cors_origins = ["*"]  # Update with your domain

# ECS Configuration
ecs_desired_count = 1
ecs_min_capacity = 1
ecs_max_capacity = 3

# RDS Configuration
db_instance_class = "db.t3.micro"
db_allocated_storage = 20

# Security Configuration
enable_deletion_protection = false  # Set to true for production
EOF

    log_success "Terraform variables file created: aws/terraform/terraform.tfvars"
    log_warning "Please review and update the configuration, especially domain_name and backend_cors_origins"
else
    log_info "Terraform variables file already exists"
fi

# Make scripts executable
log_info "Making scripts executable..."
chmod +x scripts/deploy.sh
chmod +x aws/deploy-to-aws.sh
chmod +x aws/manage-secrets.sh
chmod +x aws/get-my-ip.sh
chmod +x backend/entrypoint.sh

# Create SSL directory
if [ ! -d "ssl" ]; then
    mkdir -p ssl
    log_info "Created SSL directory for certificates"
fi

# Create backups directory
if [ ! -d "backups" ]; then
    mkdir -p backups
    log_info "Created backups directory"
fi

# Validate Docker files
log_info "Validating Docker configurations..."

for dockerfile in "backend/Dockerfile.prod" "frontend/Dockerfile.prod" "nginx/Dockerfile.prod"; do
    if [ -f "$dockerfile" ]; then
        log_success "✓ $dockerfile exists"
    else
        log_error "✗ $dockerfile missing"
    fi
done

# Check required tools
log_info "Checking required tools..."

tools=("docker" "docker-compose" "aws" "terraform")
missing_tools=()

for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        log_success "✓ $tool is installed"
    else
        log_error "✗ $tool is not installed"
        missing_tools+=("$tool")
    fi
done

if [ ${#missing_tools[@]} -gt 0 ]; then
    log_error "Missing required tools: ${missing_tools[*]}"
    log_info "Please install the missing tools before proceeding"
    exit 1
fi

# Display next steps
log_success "Production setup completed!"
echo ""
log_info "Next steps:"
echo "1. Review and update .env.prod with your configuration"
echo "2. Review and update aws/terraform/terraform.tfvars"
echo "3. Configure AWS credentials: aws configure"
echo "4. Deploy to AWS: ./aws/deploy-to-aws.sh deploy"
echo ""
log_info "For local testing:"
echo "1. Test production build: docker-compose -f docker-compose.prod.yml up"
echo "2. Run deployment script: ./scripts/deploy.sh"
echo ""
log_warning "Security reminders:"
echo "- Never commit .env.prod or terraform.tfvars to version control"
echo "- Use strong, unique passwords for production"
echo "- Update CORS origins with your actual domain"
echo "- Enable deletion protection for production databases"