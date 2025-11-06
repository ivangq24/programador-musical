#!/bin/bash
# Script para verificar el email remitente en SES
# USO: ./aws/setup-ses-email.sh tu-email@ejemplo.com

set -e

EMAIL="${1}"
REGION="${2:-us-east-1}"

if [ -z "$EMAIL" ]; then
  echo "❌ Uso: $0 <email> [region]"
  echo ""
  echo "Ejemplo:"
  echo "  $0 noreply@ejemplo.com us-east-1"
  exit 1
fi

echo "📧 Verificando email remitente en Amazon SES..."
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
  echo "   4. Después de verificar, actualiza SES_FROM_EMAIL en backend/.env"
  echo ""
  echo "⏳ Puede tardar unos minutos en llegar el email de verificación"
  echo ""
  echo "💡 Después de verificar, actualiza backend/.env:"
  echo "   SES_FROM_EMAIL=$EMAIL"
else
  echo "❌ Error verificando email"
  exit 1
fi

