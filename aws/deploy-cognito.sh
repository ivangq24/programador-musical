#!/bin/bash
set -e

# Script para desplegar solo Cognito con Terraform
# Uso: ./deploy-cognito.sh [plan|apply|destroy]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="${SCRIPT_DIR}/terraform"

cd "$TERRAFORM_DIR"

ACTION="${1:-plan}"

echo "🚀 Desplegando Cognito con Terraform..."
echo "Directorio: $TERRAFORM_DIR"
echo "Acción: $ACTION"
echo ""

# Verificar que terraform está instalado
if ! command -v terraform &> /dev/null; then
    echo "❌ Error: Terraform no está instalado"
    echo "Instala Terraform desde: https://www.terraform.io/downloads"
    exit 1
fi

# Verificar que AWS está configurado
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ Error: AWS CLI no está configurado"
    echo "Configura AWS CLI con: aws configure"
    exit 1
fi

# Inicializar Terraform si es necesario
if [ ! -d ".terraform" ]; then
    echo "📦 Inicializando Terraform..."
    terraform init
fi

# Validar configuración
echo "✅ Validando configuración de Terraform..."
terraform validate

# Ejecutar acción
case $ACTION in
    plan)
        echo "📋 Generando plan de ejecución..."
        terraform plan -target=aws_cognito_user_pool.main \
                       -target=aws_cognito_user_pool_client.web \
                       -target=aws_cognito_user_pool_domain.main \
                       -target=aws_cognito_user_group.admin \
                       -target=aws_cognito_user_group.manager \
                       -target=aws_cognito_user_group.operador \
                       -out=tfplan
        echo ""
        echo "✅ Plan generado. Para aplicar: ./deploy-cognito.sh apply"
        ;;
    apply)
        if [ -f "tfplan" ]; then
            echo "🚀 Aplicando plan..."
            terraform apply tfplan
        else
            echo "🚀 Aplicando cambios directamente..."
            terraform apply -target=aws_cognito_user_pool.main \
                            -target=aws_cognito_user_pool_client.web \
                            -target=aws_cognito_user_pool_domain.main \
                            -target=aws_cognito_user_group.admin \
                            -target=aws_cognito_user_group.manager \
                            -target=aws_cognito_user_group.operador \
                            -auto-approve
        fi
        
        echo ""
        echo "✅ Cognito desplegado exitosamente!"
        echo ""
        echo "📋 Obtén los valores de configuración:"
        echo ""
        echo "=== Frontend (.env.local) ==="
        terraform output -raw cognito_user_pool_id > /tmp/cognito_pool_id 2>/dev/null || echo "Error obteniendo Pool ID"
        terraform output -raw cognito_client_id > /tmp/cognito_client_id 2>/dev/null || echo "Error obteniendo Client ID"
        terraform output -raw cognito_domain > /tmp/cognito_domain 2>/dev/null || echo "Error obteniendo Domain"
        
        if [ -f /tmp/cognito_pool_id ] && [ -f /tmp/cognito_client_id ] && [ -f /tmp/cognito_domain ]; then
            POOL_ID=$(cat /tmp/cognito_pool_id)
            CLIENT_ID=$(cat /tmp/cognito_client_id)
            DOMAIN=$(cat /tmp/cognito_domain)
            
            echo "NEXT_PUBLIC_COGNITO_USER_POOL_ID=$POOL_ID"
            echo "NEXT_PUBLIC_COGNITO_CLIENT_ID=$CLIENT_ID"
            echo "NEXT_PUBLIC_COGNITO_DOMAIN=$DOMAIN"
            echo "NEXT_PUBLIC_COGNITO_REGION=us-east-1"
            echo ""
            echo "=== Backend (.env) ==="
            echo "COGNITO_USER_POOL_ID=$POOL_ID"
            echo "COGNITO_CLIENT_ID=$CLIENT_ID"
            echo "COGNITO_REGION=us-east-1"
        else
            terraform output
        fi
        
        rm -f /tmp/cognito_pool_id /tmp/cognito_client_id /tmp/cognito_domain 2>/dev/null || true
        ;;
    destroy)
        echo "⚠️  DESTRUYENDO recursos de Cognito..."
        read -p "¿Estás seguro? (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            terraform destroy -target=aws_cognito_identity_provider.apple \
                              -target=aws_cognito_identity_provider.google \
                              -target=aws_cognito_user_group.operador \
                              -target=aws_cognito_user_group.manager \
                              -target=aws_cognito_user_group.admin \
                              -target=aws_cognito_user_pool_domain.main \
                              -target=aws_cognito_user_pool_client.web \
                              -target=aws_cognito_user_pool.main \
                              -auto-approve
            echo "✅ Recursos de Cognito destruidos"
        else
            echo "❌ Operación cancelada"
        fi
        ;;
    *)
        echo "❌ Acción inválida: $ACTION"
        echo "Uso: $0 [plan|apply|destroy]"
        exit 1
        ;;
esac

