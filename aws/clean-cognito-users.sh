#!/bin/bash
# Script para limpiar todos los usuarios de Cognito
# USO: ./aws/clean-cognito-users.sh

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

REGION="${1:-us-east-1}"

echo "🧹 Limpiando usuarios de Cognito..."
echo "🔑 User Pool ID: $USER_POOL_ID"
echo "🌍 Región: $REGION"
echo ""

# Confirmar acción
read -p "⚠️  ¿Estás seguro de que quieres eliminar TODOS los usuarios? (escribe 'SI' para confirmar): " confirm
if [ "$confirm" != "SI" ]; then
  echo "❌ Operación cancelada"
  exit 0
fi

echo ""
echo "📋 Listando usuarios..."

# Listar todos los usuarios
PAGINATION_TOKEN=""
USER_COUNT=0
DELETED_COUNT=0

while true; do
  if [ -z "$PAGINATION_TOKEN" ]; then
    RESPONSE=$(aws cognito-idp list-users \
      --user-pool-id "$USER_POOL_ID" \
      --region "$REGION" \
      --output json 2>&1)
  else
    RESPONSE=$(aws cognito-idp list-users \
      --user-pool-id "$USER_POOL_ID" \
      --region "$REGION" \
      --pagination-token "$PAGINATION_TOKEN" \
      --output json 2>&1)
  fi

  if [ $? -ne 0 ]; then
    echo "❌ Error listando usuarios: $RESPONSE"
    exit 1
  fi

  # Extraer usuarios y pagination token
  USERS=$(echo "$RESPONSE" | jq -r '.Users[]?.Username // empty')
  PAGINATION_TOKEN=$(echo "$RESPONSE" | jq -r '.PaginationToken // empty')

  # Eliminar cada usuario
  while IFS= read -r username; do
    if [ -n "$username" ]; then
      USER_COUNT=$((USER_COUNT + 1))
      echo "🗑️  Eliminando usuario: $username"
      
      aws cognito-idp admin-delete-user \
        --user-pool-id "$USER_POOL_ID" \
        --username "$username" \
        --region "$REGION" 2>&1
      
      if [ $? -eq 0 ]; then
        DELETED_COUNT=$((DELETED_COUNT + 1))
        echo "   ✅ Usuario $username eliminado"
      else
        echo "   ⚠️  Error eliminando usuario $username"
      fi
    fi
  done <<< "$USERS"

  # Si no hay más páginas, salir
  if [ -z "$PAGINATION_TOKEN" ] || [ "$PAGINATION_TOKEN" == "null" ]; then
    break
  fi
done

echo ""
echo "✅ Limpieza completada"
echo "📊 Resumen:"
echo "   Usuarios encontrados: $USER_COUNT"
echo "   Usuarios eliminados: $DELETED_COUNT"
echo ""
echo "⚠️  NOTA: Los usuarios también deben eliminarse de la base de datos local"
echo "   Ejecuta en el contenedor de la base de datos:"
echo "   docker-compose -f docker-compose.dev.yml exec db psql -U postgres -d programador-musical -c \"DELETE FROM usuarios;\""

