#!/bin/bash

# AWS ECS Deployment Script for Programador Musical
# This script handles the complete deployment process to AWS ECS

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
AWS_REGION=${AWS_REGION:-us-east-1}
ENVIRONMENT=${ENVIRONMENT:-production}
PROJECT_NAME="programador-musical"

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
    
    # Check AWS CLI
    if ! command -v aws &> /dev/null; then
        log_error "AWS CLI is not installed"
        exit 1
    fi
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed"
        exit 1
    fi
    
    # Check Terraform
    if ! command -v terraform &> /dev/null; then
        log_error "Terraform is not installed"
        exit 1
    fi
    
    # Check AWS credentials
    if ! aws sts get-caller-identity &> /dev/null; then
        log_error "AWS credentials not configured"
        exit 1
    fi
    
    log_success "Requirements check passed"
}

setup_ip_restriction() {
    log_info "Setting up IP restriction..."
    
    # Auto-detect and set IP address using the simple script
    if [ -f "update-ip-simple.sh" ]; then
        chmod +x update-ip-simple.sh
        ./update-ip-simple.sh update
        log_success "IP restriction configured"
    else
        log_warning "update-ip-simple.sh not found, skipping IP restriction setup"
    fi
}

setup_terraform() {
    log_info "Setting up Terraform..."
    
    # Save current directory and change to terraform directory
    local original_dir=$(pwd)
    cd terraform
    
    # Initialize Terraform
    terraform init
    
    # Validate configuration
    terraform validate
    
    # Return to original directory
    cd "$original_dir"
    
    log_success "Terraform setup completed"
}

create_ecr_repositories() {
    log_info "Creating ECR repositories..."
    
    # Get AWS account ID
    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    
    # Create repositories if they don't exist
    for repo in frontend backend nginx; do
        if ! aws ecr describe-repositories --repository-names "${PROJECT_NAME}/${repo}" --region $AWS_REGION &> /dev/null; then
            log_info "Creating ECR repository: ${PROJECT_NAME}/${repo}"
            aws ecr create-repository \
                --repository-name "${PROJECT_NAME}/${repo}" \
                --region $AWS_REGION \
                --image-scanning-configuration scanOnPush=true
        else
            log_info "ECR repository already exists: ${PROJECT_NAME}/${repo}"
        fi
    done
    
    log_success "ECR repositories ready"
}

build_and_push_images() {
    log_info "Building and pushing Docker images..."
    
    # Get AWS account ID and ECR login
    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
    
    # Save current directory and go to project root
    local original_dir=$(pwd)
    cd ..
    
    # Get Cognito configuration from Terraform
    COGNITO_USER_POOL_ID=$(cd "$original_dir/terraform" && terraform output -raw cognito_user_pool_id 2>/dev/null || echo "")
    COGNITO_CLIENT_ID=$(cd "$original_dir/terraform" && terraform output -raw cognito_client_id 2>/dev/null || echo "")
    
    # Build and push frontend (ARM64 for cost savings)
    log_info "Building frontend image for ARM64 with Cognito config..."
    log_info "Cognito User Pool ID: $COGNITO_USER_POOL_ID"
    log_info "Cognito Client ID: $COGNITO_CLIENT_ID"
    docker build --platform linux/arm64 \
        --build-arg NEXT_PUBLIC_COGNITO_USER_POOL_ID="$COGNITO_USER_POOL_ID" \
        --build-arg NEXT_PUBLIC_COGNITO_CLIENT_ID="$COGNITO_CLIENT_ID" \
        --build-arg NEXT_PUBLIC_COGNITO_REGION="$AWS_REGION" \
        --build-arg NEXT_PUBLIC_API_URL="/api/v1" \
        -f frontend/Dockerfile.prod \
        -t $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/${PROJECT_NAME}/frontend:latest \
        ./frontend
    docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/${PROJECT_NAME}/frontend:latest
    
    # Build and push backend (ARM64 for cost savings)
    log_info "Building backend image for ARM64..."
    docker build --platform linux/arm64 -f backend/Dockerfile.prod -t $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/${PROJECT_NAME}/backend:latest ./backend
    docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/${PROJECT_NAME}/backend:latest
    
    # Build and push nginx (ARM64 for cost savings)
    log_info "Building nginx image for ARM64..."
    docker build --platform linux/arm64 -f nginx/Dockerfile.prod -t $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/${PROJECT_NAME}/nginx:latest ./nginx
    docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/${PROJECT_NAME}/nginx:latest
    
    # Return to original directory
    cd "$original_dir"
    
    log_success "Images built and pushed successfully"
}

create_secrets() {
    log_info "Creating application secrets..."
    
    # Create secrets using the management script
    ./manage-secrets.sh create
    
    log_success "Application secrets created"
}

deploy_infrastructure() {
    log_info "Deploying infrastructure with Terraform..."
    
    # Save current directory and change to terraform directory
    local original_dir=$(pwd)
    cd terraform
    
    # Check if terraform.tfvars exists
    if [ ! -f "terraform.tfvars" ]; then
        log_error "terraform.tfvars file not found"
        log_info "Please create terraform.tfvars with your configuration"
        exit 1
    fi
    
    # Plan deployment
    terraform plan -out=tfplan
    
    # Apply deployment
    terraform apply tfplan
    
    # Return to original directory
    cd "$original_dir"
    
    log_success "Infrastructure deployed successfully"
}

update_ecs_service() {
    log_info "Updating ECS service..."
    
    # Get the actual cluster and service names from terraform
    local original_dir=$(pwd)
    cd terraform
    
    CLUSTER_NAME=$(terraform output -raw ecs_cluster_name 2>/dev/null || echo "pm-prod-v2-cluster")
    SERVICE_NAME=$(terraform output -raw ecs_service_name 2>/dev/null || echo "pm-prod-v2-app")
    
    cd "$original_dir"
    
    # Force new deployment to pick up new images
    aws ecs update-service \
        --cluster "$CLUSTER_NAME" \
        --service "$SERVICE_NAME" \
        --force-new-deployment \
        --region $AWS_REGION
    
    log_info "Waiting for service to stabilize..."
    aws ecs wait services-stable \
        --cluster "$CLUSTER_NAME" \
        --services "$SERVICE_NAME" \
        --region $AWS_REGION
    
    log_success "ECS service updated successfully"
}

check_deployment() {
    log_info "Checking deployment health..."
    
    # Save current directory and change to terraform directory
    local original_dir=$(pwd)
    cd terraform
    
    # Get ALB DNS name
    ALB_DNS=$(terraform output -raw alb_dns_name 2>/dev/null)
    
    cd "$original_dir"
    
    if [ -z "$ALB_DNS" ]; then
        log_warning "Could not get ALB DNS name from terraform output"
        return
    fi
    
    # Wait a bit for the service to be ready
    sleep 30
    
    # Check health endpoint (try HTTP first, then HTTPS)
    if curl -f "http://$ALB_DNS/" &> /dev/null; then
        log_success "Application is healthy"
        log_success "Application URL: http://$ALB_DNS"
    elif curl -f -k "https://$ALB_DNS/" &> /dev/null; then
        log_success "Application is healthy"
        log_success "Application URL: https://$ALB_DNS"
    else
        log_warning "Health check failed, but deployment may still be starting"
        log_info "Application URL: http://$ALB_DNS"
        log_info "Please check the ECS service logs if issues persist"
    fi
}

show_outputs() {
    log_info "Deployment outputs:"
    local original_dir=$(pwd)
    cd terraform
    terraform output
    cd "$original_dir"
}

cleanup_old_images() {
    log_info "Cleaning up old Docker images..."
    
    # Clean up local images
    docker system prune -f
    
    log_success "Cleanup completed"
}

# Main deployment function
deploy() {
    log_info "Starting AWS ECS deployment..."
    
    check_requirements
    setup_ip_restriction
    setup_terraform
    deploy_infrastructure  # Terraform crea ECR y secretos
    build_and_push_images
    update_ecs_service
    check_deployment
    show_outputs
    cleanup_old_images
    
    log_success "Deployment completed successfully!"
}

# Script commands
case "${1:-deploy}" in
    "check")
        check_requirements
        ;;
    "terraform")
        setup_terraform
        deploy_infrastructure
        ;;
    "images")
        create_ecr_repositories
        build_and_push_images
        ;;
    "secrets")
        create_secrets
        ;;
    "ip")
        if [ -f "update-ip-simple.sh" ]; then
            chmod +x update-ip-simple.sh
            ./update-ip-simple.sh update
        else
            log_error "update-ip-simple.sh not found"
            exit 1
        fi
        ;;
    "deploy")
        deploy
        ;;
    "update")
        build_and_push_images
        update_ecs_service
        check_deployment
        ;;
    "status")
        show_outputs
        ;;
    "destroy")
        log_warning "This will destroy all AWS resources!"
        read -p "Are you sure? (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            original_dir=$(pwd)
            cd terraform
            terraform destroy
            cd "$original_dir"
            log_success "Resources destroyed"
        else
            log_info "Destruction cancelled"
        fi
        ;;
    *)
        echo "Usage: $0 {check|terraform|images|deploy|update|status|destroy}"
        echo ""
        echo "Commands:"
        echo "  check     - Check deployment requirements"
        echo "  terraform - Deploy infrastructure only"
        echo "  images    - Build and push images only"
        echo "  secrets   - Create/update application secrets"
        echo "  ip        - Configure IP address restriction"
        echo "  deploy    - Full deployment (default)"
        echo "  update    - Update application (rebuild images and restart service)"
        echo "  status    - Show deployment status and outputs"
        echo "  destroy   - Destroy all AWS resources"
        exit 1
        ;;
esac