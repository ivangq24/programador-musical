#!/bin/bash
# Script para crear un usuario de prueba en Cognito

set -e

USER_POOL_ID="us-east-1_vIAPyQrO3"
EMAIL="${1:-admin@example.com}"
PASSWORD="${2:-TempPass123!}"
ROLE="${3:-admin}"

echo "👤 Creando usuario de prueba en Cognito..."
echo "Email: $EMAIL"
echo "Rol: $ROLE"
echo ""

# Crear usuario
aws cognito-idp admin-create-user \
  --user-pool-id "$USER_POOL_ID" \
  --username "$EMAIL" \
  --user-attributes \
    Name=email,Value="$EMAIL" \
    Name=custom:rol,Value="$ROLE" \
    Name=name,Value="Usuario $ROLE" \
  --temporary-password "$PASSWORD" \
  --message-action SUPPRESS \
  --region us-east-1

echo "✅ Usuario creado"

# Asignar al grupo
echo "📋 Asignando usuario al grupo '$ROLE'..."
aws cognito-idp admin-add-user-to-group \
  --user-pool-id "$USER_POOL_ID" \
  --username "$EMAIL" \
  --group-name "$ROLE" \
  --region us-east-1

echo "✅ Usuario asignado al grupo '$ROLE'"
echo ""
echo "📝 Credenciales de acceso:"
echo "   Email: $EMAIL"
echo "   Contraseña temporal: $PASSWORD"
echo ""
echo "⚠️  IMPORTANTE: Al iniciar sesión por primera vez, Cognito te pedirá cambiar la contraseña."
echo ""
echo "🌐 Puedes iniciar sesión en: http://localhost:3000/auth/login"

