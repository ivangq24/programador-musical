#!/bin/bash

# AWS Secrets Manager utility script for Programador Musical
# This script helps manage application secrets in AWS Secrets Manager

set -e

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
SECRET_NAME="pm-${ENVIRONMENT:0:4}-app-secrets"

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

check_aws_cli() {
    if ! command -v aws &> /dev/null; then
        log_error "AWS CLI is not installed"
        exit 1
    fi
    
    if ! aws sts get-caller-identity &> /dev/null; then
        log_error "AWS credentials not configured"
        exit 1
    fi
}

generate_secret() {
    openssl rand -base64 32
}

generate_password() {
    openssl rand -base64 24 | tr -d "=+/" | cut -c1-20
}

create_secrets() {
    log_info "Creating application secrets..."
    
    # Generate secure values
    JWT_SECRET=$(generate_secret)
    DB_PASSWORD=$(generate_password)
    
    # Get RDS endpoint if it exists
    RDS_ENDPOINT=""
    if aws rds describe-db-instances --db-instance-identifier "${PROJECT_NAME}-${ENVIRONMENT}-db" --region $AWS_REGION &> /dev/null; then
        RDS_ENDPOINT=$(aws rds describe-db-instances \
            --db-instance-identifier "${PROJECT_NAME}-${ENVIRONMENT}-db" \
            --region $AWS_REGION \
            --query 'DBInstances[0].Endpoint.Address' \
            --output text)
        log_info "Found RDS endpoint: $RDS_ENDPOINT"
    else
        log_warning "RDS instance not found, using placeholder endpoint"
        RDS_ENDPOINT="localhost"
    fi
    
    # Create the secret JSON
    SECRET_JSON=$(cat <<EOF
{
  "jwt_secret_key": "$JWT_SECRET",
  "database_url": "postgresql://programador_user:$DB_PASSWORD@$RDS_ENDPOINT/programador_musical",
  "database_host": "$RDS_ENDPOINT",
  "database_name": "programador_musical",
  "database_username": "programador_user",
  "database_password": "$DB_PASSWORD"
}
EOF
)
    
    # Create or update the secret
    if aws secretsmanager describe-secret --secret-id "$SECRET_NAME" --region $AWS_REGION &> /dev/null; then
        log_info "Updating existing secret: $SECRET_NAME"
        aws secretsmanager update-secret \
            --secret-id "$SECRET_NAME" \
            --secret-string "$SECRET_JSON" \
            --region $AWS_REGION
    else
        log_info "Creating new secret: $SECRET_NAME"
        aws secretsmanager create-secret \
            --name "$SECRET_NAME" \
            --description "Application secrets for $PROJECT_NAME" \
            --secret-string "$SECRET_JSON" \
            --region $AWS_REGION
    fi
    
    log_success "Secrets created/updated successfully"
    log_warning "Database password: $DB_PASSWORD"
    log_warning "Please save this password securely and update your Terraform variables"
}

get_secrets() {
    log_info "Retrieving secrets from AWS Secrets Manager..."
    
    if ! aws secretsmanager describe-secret --secret-id "$SECRET_NAME" --region $AWS_REGION &> /dev/null; then
        log_error "Secret not found: $SECRET_NAME"
        exit 1
    fi
    
    SECRET_VALUE=$(aws secretsmanager get-secret-value \
        --secret-id "$SECRET_NAME" \
        --region $AWS_REGION \
        --query 'SecretString' \
        --output text)
    
    echo "Secret contents:"
    echo "$SECRET_VALUE" | jq .
}

get_secret_value() {
    local key=$1
    if [ -z "$key" ]; then
        log_error "Please specify a secret key"
        exit 1
    fi
    
    SECRET_VALUE=$(aws secretsmanager get-secret-value \
        --secret-id "$SECRET_NAME" \
        --region $AWS_REGION \
        --query 'SecretString' \
        --output text)
    
    echo "$SECRET_VALUE" | jq -r ".$key"
}

update_secret_value() {
    local key=$1
    local value=$2
    
    if [ -z "$key" ] || [ -z "$value" ]; then
        log_error "Please specify both key and value"
        echo "Usage: $0 update-value <key> <value>"
        exit 1
    fi
    
    log_info "Updating secret value for key: $key"
    
    # Get current secret
    CURRENT_SECRET=$(aws secretsmanager get-secret-value \
        --secret-id "$SECRET_NAME" \
        --region $AWS_REGION \
        --query 'SecretString' \
        --output text)
    
    # Update the specific key
    UPDATED_SECRET=$(echo "$CURRENT_SECRET" | jq --arg key "$key" --arg value "$value" '.[$key] = $value')
    
    # Update the secret
    aws secretsmanager update-secret \
        --secret-id "$SECRET_NAME" \
        --secret-string "$UPDATED_SECRET" \
        --region $AWS_REGION
    
    log_success "Secret value updated successfully"
}

rotate_jwt_secret() {
    log_info "Rotating JWT secret..."
    
    NEW_JWT_SECRET=$(generate_secret)
    update_secret_value "jwt_secret_key" "$NEW_JWT_SECRET"
    
    log_success "JWT secret rotated successfully"
    log_warning "You may need to restart your application for the new secret to take effect"
}

rotate_db_password() {
    log_info "Rotating database password..."
    log_warning "This will update the secret but NOT the actual database password"
    log_warning "You need to update the RDS password separately"
    
    NEW_DB_PASSWORD=$(generate_password)
    
    # Get current values to update database_url
    CURRENT_SECRET=$(aws secretsmanager get-secret-value \
        --secret-id "$SECRET_NAME" \
        --region $AWS_REGION \
        --query 'SecretString' \
        --output text)
    
    DB_HOST=$(echo "$CURRENT_SECRET" | jq -r '.database_host')
    DB_NAME=$(echo "$CURRENT_SECRET" | jq -r '.database_name')
    DB_USER=$(echo "$CURRENT_SECRET" | jq -r '.database_username')
    
    NEW_DB_URL="postgresql://$DB_USER:$NEW_DB_PASSWORD@$DB_HOST/$DB_NAME"
    
    # Update both password and URL
    UPDATED_SECRET=$(echo "$CURRENT_SECRET" | jq \
        --arg password "$NEW_DB_PASSWORD" \
        --arg url "$NEW_DB_URL" \
        '.database_password = $password | .database_url = $url')
    
    aws secretsmanager update-secret \
        --secret-id "$SECRET_NAME" \
        --secret-string "$UPDATED_SECRET" \
        --region $AWS_REGION
    
    log_success "Database password in secret updated"
    log_warning "New password: $NEW_DB_PASSWORD"
    log_warning "Remember to update the actual RDS password using:"
    log_warning "aws rds modify-db-instance --db-instance-identifier ${PROJECT_NAME}-${ENVIRONMENT}-db --master-user-password $NEW_DB_PASSWORD"
}

delete_secrets() {
    log_warning "This will permanently delete the secret: $SECRET_NAME"
    read -p "Are you sure? (yes/no): " confirm
    
    if [ "$confirm" = "yes" ]; then
        aws secretsmanager delete-secret \
            --secret-id "$SECRET_NAME" \
            --force-delete-without-recovery \
            --region $AWS_REGION
        log_success "Secret deleted successfully"
    else
        log_info "Deletion cancelled"
    fi
}

list_secrets() {
    log_info "Listing all secrets for project: $PROJECT_NAME"
    
    aws secretsmanager list-secrets \
        --region $AWS_REGION \
        --query "SecretList[?contains(Name, '$PROJECT_NAME')].{Name:Name,Description:Description,LastChanged:LastChangedDate}" \
        --output table
}

# Main script
case "${1:-help}" in
    "create")
        check_aws_cli
        create_secrets
        ;;
    "get")
        check_aws_cli
        get_secrets
        ;;
    "get-value")
        check_aws_cli
        get_secret_value "$2"
        ;;
    "update-value")
        check_aws_cli
        update_secret_value "$2" "$3"
        ;;
    "rotate-jwt")
        check_aws_cli
        rotate_jwt_secret
        ;;
    "rotate-db")
        check_aws_cli
        rotate_db_password
        ;;
    "delete")
        check_aws_cli
        delete_secrets
        ;;
    "list")
        check_aws_cli
        list_secrets
        ;;
    "help"|*)
        echo "AWS Secrets Manager utility for Programador Musical"
        echo ""
        echo "Usage: $0 <command> [arguments]"
        echo ""
        echo "Commands:"
        echo "  create              - Create initial secrets with generated values"
        echo "  get                 - Retrieve and display all secrets"
        echo "  get-value <key>     - Get a specific secret value"
        echo "  update-value <key> <value> - Update a specific secret value"
        echo "  rotate-jwt          - Generate new JWT secret"
        echo "  rotate-db           - Generate new database password (secret only)"
        echo "  list                - List all project secrets"
        echo "  delete              - Delete the secrets (permanent)"
        echo "  help                - Show this help message"
        echo ""
        echo "Environment variables:"
        echo "  AWS_REGION          - AWS region (default: us-east-1)"
        echo "  ENVIRONMENT         - Environment name (default: production)"
        echo ""
        echo "Examples:"
        echo "  $0 create                           # Create initial secrets"
        echo "  $0 get                              # View all secrets"
        echo "  $0 get-value jwt_secret_key         # Get JWT secret"
        echo "  $0 update-value database_name mydb  # Update database name"
        echo "  $0 rotate-jwt                       # Rotate JWT secret"
        ;;
esac