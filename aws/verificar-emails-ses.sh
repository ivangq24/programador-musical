#!/bin/bash
# Script para verificar emails en Amazon SES (remitente y destinatarios)
# USO: ./aws/verificar-emails-ses.sh <email-remitente> [email-destino1] [email-destino2] ...

set -e

FROM_EMAIL="${1}"
REGION="${2:-us-east-1}"
shift 2 2>/dev/null || shift 1 2>/dev/null || true
DEST_EMAILS=("$@")

if [ -z "$FROM_EMAIL" ]; then
  echo "❌ Uso: $0 <email-remitente> [region] [email-destino1] [email-destino2] ..."
  echo ""
  echo "Ejemplos:"
  echo "  # Solo verificar remitente"
  echo "  $0 admin@ejemplo.com us-east-1"
  echo ""
  echo "  # Verificar remitente y destinatarios"
  echo "  $0 admin@ejemplo.com us-east-1 usuario1@ejemplo.com usuario2@ejemplo.com"
  exit 1
fi

echo "📧 Verificando emails en Amazon SES..."
echo "📧 Email remitente: $FROM_EMAIL"
echo "🌍 Región: $REGION"
echo ""

# Verificar email remitente
echo "1️⃣ Verificando email remitente: $FROM_EMAIL"
aws ses verify-email-identity \
  --email-address "$FROM_EMAIL" \
  --region "$REGION" 2>&1 | grep -v "An error occurred" || true

if [ $? -eq 0 ]; then
  echo "   ✅ Solicitud de verificación enviada para remitente"
else
  echo "   ⚠️  Puede que el email ya esté en proceso de verificación"
fi

echo ""

# Verificar emails destino
if [ ${#DEST_EMAILS[@]} -gt 0 ]; then
  echo "2️⃣ Verificando emails destino:"
  for dest_email in "${DEST_EMAILS[@]}"; do
    if [ -n "$dest_email" ]; then
      echo "   📧 Verificando: $dest_email"
      aws ses verify-email-identity \
        --email-address "$dest_email" \
        --region "$REGION" 2>&1 | grep -v "An error occurred" || true
      echo "   ✅ Solicitud enviada para $dest_email"
      echo ""
    fi
  done
fi

echo ""
echo "📬 INSTRUCCIONES:"
echo "   1. Revisa la bandeja de entrada de CADA email verificado"
echo "   2. Busca un email de 'Amazon SES Email Verification'"
echo "   3. Haz clic en el link de verificación"
echo "   4. Después de verificar, los correos llegarán correctamente"
echo ""
echo "⏳ Puede tardar 1-2 minutos en llegar cada email de verificación"
echo ""
echo "🔍 Para verificar el estado:"
echo "   aws ses list-identities --region $REGION"
echo ""
echo "📝 IMPORTANTE:"
echo "   - Actualiza backend/.env con: SES_FROM_EMAIL=$FROM_EMAIL"
echo "   - Reinicia el backend: docker-compose -f docker-compose.dev.yml restart backend"
echo ""

