#!/bin/bash
# Script para crear el primer administrador del sistema
# USO: ./aws/create-first-admin.sh email@ejemplo.com "Nombre Completo" "Password123!@#"

set -e

# Obtener User Pool ID desde Terraform
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/terraform"

USER_POOL_ID=$(terraform output -raw cognito_user_pool_id 2>/dev/null || echo "")

if [ -z "$USER_POOL_ID" ]; then
  echo "❌ Error: No se pudo obtener el User Pool ID"
  echo "   Asegúrate de que Terraform esté inicializado y Cognito desplegado"
  exit 1
fi

EMAIL="${1}"
NOMBRE="${2}"
PASSWORD="${3}"
REGION="${4:-us-east-1}"

if [ -z "$EMAIL" ] || [ -z "$NOMBRE" ] || [ -z "$PASSWORD" ]; then
  echo "❌ Uso: $0 <email> <nombre> <password> [region]"
  echo ""
  echo "Ejemplo:"
  echo "  $0 admin@ejemplo.com 'Super Administrador' 'SuperPass123!@#' us-east-1"
  exit 1
fi

echo "🔐 Creando Super Administrador..."
echo "📧 Email: $EMAIL"
echo "👤 Nombre: $NOMBRE"
echo "🔑 User Pool ID: $USER_POOL_ID"
echo ""

# 1. Crear usuario
echo "📝 Paso 1: Creando usuario en Cognito..."
aws cognito-idp admin-create-user \
  --user-pool-id "$USER_POOL_ID" \
  --username "$EMAIL" \
  --user-attributes \
    Name=email,Value="$EMAIL" \
    Name=email_verified,Value="true" \
    Name=name,Value="$NOMBRE" \
  --temporary-password "$PASSWORD" \
  --message-action SUPPRESS \
  --region "$REGION"

if [ $? -ne 0 ]; then
  echo "❌ Error creando usuario"
  exit 1
fi

echo "✅ Usuario creado"

# 2. Asignar al grupo admin
echo ""
echo "📋 Paso 2: Asignando al grupo 'admin'..."
aws cognito-idp admin-add-user-to-group \
  --user-pool-id "$USER_POOL_ID" \
  --username "$EMAIL" \
  --group-name "admin" \
  --region "$REGION"

if [ $? -ne 0 ]; then
  echo "❌ Error asignando al grupo"
  exit 1
fi

echo "✅ Usuario asignado al grupo admin"

# 3. Confirmar usuario
echo ""
echo "✅ Paso 3: Confirmando usuario..."
aws cognito-idp admin-confirm-sign-up \
  --user-pool-id "$USER_POOL_ID" \
  --username "$EMAIL" \
  --region "$REGION"

# 4. Establecer contraseña permanente
echo ""
echo "🔑 Paso 4: Estableciendo contraseña permanente..."
aws cognito-idp admin-set-user-password \
  --user-pool-id "$USER_POOL_ID" \
  --username "$EMAIL" \
  --password "$PASSWORD" \
  --permanent \
  --region "$REGION"

if [ $? -eq 0 ]; then
  echo "✅ Contraseña establecida como permanente"
else
  echo "⚠️  Error estableciendo contraseña permanente"
fi

echo ""
echo "🎉 ¡Super Administrador creado exitosamente!"
echo ""
echo "📝 Credenciales:"
echo "   Email: $EMAIL"
echo "   Contraseña: $PASSWORD"
echo ""
echo "🌐 Puedes iniciar sesión en:"
echo "   Desarrollo: http://localhost:3000/auth/login"
echo "   Producción: https://tu-dominio.com/auth/login"
echo ""
echo "⚠️  IMPORTANTE:"
echo "   - Guarda estas credenciales de forma segura"
echo "   - El auto-registro está deshabilitado"
echo "   - Solo los admins pueden invitar nuevos usuarios"
