#!/bin/bash
# Script para solicitar salida del sandbox de SES (modo producción)
# USO: ./aws/request-ses-production.sh

set -e

REGION="${1:-us-east-1}"

echo "🚀 Solicitando salida del sandbox de SES para modo producción..."
echo "🌍 Región: $REGION"
echo ""

echo "⚠️  IMPORTANTE:"
echo "   Esta solicitud debe hacerse desde la consola de AWS SES"
echo "   El proceso puede tardar 24-48 horas en ser aprobado"
echo ""
echo "📋 Pasos para solicitar salida del sandbox:"
echo ""
echo "1. Ve a la consola de AWS SES:"
echo "   https://console.aws.amazon.com/ses/home?region=$REGION#/account"
echo ""
echo "2. Haz clic en 'Request production access'"
echo ""
echo "3. Completa el formulario con:"
echo "   - Mail Type: Transactional"
echo "   - Website URL: Tu sitio web"
echo "   - Use case description: Sistema de gestión de programación musical"
echo "   - Expected sending volume: [Tu volumen estimado]"
echo "   - How do you plan to handle bounces and complaints: [Tu plan]"
echo ""
echo "4. Espera la aprobación (24-48 horas)"
echo ""
echo "✅ Una vez aprobado:"
echo "   - Actualiza backend/.env: SES_PRODUCTION_MODE=true"
echo "   - Reinicia el backend: docker-compose -f docker-compose.dev.yml restart backend"
echo "   - Ya no necesitarás verificar cada email destino"
echo ""
echo "📊 Estado actual de SES:"
aws ses get-send-quota --region "$REGION" --output json | jq '.'
echo ""
echo "💡 Alternativa: Verificar dominio completo"
echo "   Si verificas tu dominio completo en SES, puedes enviar a cualquier email"
echo "   del dominio sin verificar cada uno individualmente"
echo "   aws ses verify-domain-identity --domain tudominio.com --region $REGION"

