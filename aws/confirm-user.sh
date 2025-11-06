#!/bin/bash
# Script para confirmar manualmente un usuario en Cognito

set -e

USER_POOL_ID="us-east-1_vIAPyQrO3"
EMAIL="${1:-}"

if [ -z "$EMAIL" ]; then
    echo "Uso: $0 <email>"
    exit 1
fi

echo "✅ Confirmando usuario: $EMAIL"
echo ""

aws cognito-idp admin-confirm-sign-up \
  --user-pool-id "$USER_POOL_ID" \
  --username "$EMAIL" \
  --region us-east-1

echo ""
echo "✅ Usuario confirmado exitosamente. Ya puede iniciar sesión."

