#!/bin/bash
# Script para verificar un email en Amazon SES
# USO: ./aws/verify-email-ses.sh tu-email@ejemplo.com

set -e

EMAIL="${1}"
REGION="${2:-us-east-1}"

if [ -z "$EMAIL" ]; then
  echo "❌ Uso: $0 <email> [region]"
  echo ""
  echo "Ejemplo:"
  echo "  $0 admin@ejemplo.com us-east-1"
  exit 1
fi

echo "📧 Verificando email en Amazon SES..."
echo "📧 Email: $EMAIL"
echo "🌍 Región: $REGION"
echo ""

# Verificar email
aws ses verify-email-identity \
  --email-address "$EMAIL" \
  --region "$REGION"

if [ $? -eq 0 ]; then
  echo ""
  echo "✅ Solicitud de verificación enviada"
  echo ""
  echo "📬 INSTRUCCIONES:"
  echo "   1. Revisa tu bandeja de entrada en: $EMAIL"
  echo "   2. Busca un email de Amazon SES"
  echo "   3. Haz clic en el link de verificación"
  echo "   4. Después de verificar, los correos de Cognito llegarán a este email"
  echo ""
  echo "⏳ Puede tardar unos minutos en llegar el email de verificación"
else
  echo "❌ Error verificando email"
  exit 1
fi

