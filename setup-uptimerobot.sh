#!/bin/bash

# Script para configurar UptimeRobot y mantener Render despierto 24/7

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}${BLUE}╔═══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${BLUE}║                                           ║${NC}"
echo -e "${BOLD}${BLUE}║   🤖 UptimeRobot - Keep Alive Setup      ║${NC}"
echo -e "${BOLD}${BLUE}║                                           ║${NC}"
echo -e "${BOLD}${BLUE}╚═══════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}¿Qué hace UptimeRobot?${NC}"
echo ""
echo "→ Hace ping a tu app cada 5 minutos"
echo "→ Render piensa que hay actividad constante"
echo "→ Tu app nunca se duerme = siempre instantánea ✅"
echo "→ 100% gratis (hasta 50 monitores)"
echo ""
echo -e "${GREEN}¡Tu app estará siempre activa sin pagar!${NC}"
echo ""
read -p "¿Configurar UptimeRobot? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Saltado. Puedes configurarlo después siguiendo: UPTIMEROBOT.md"
    exit 0
fi

# Verificar que tengamos la URL de Render
source .env 2>/dev/null || true

if [[ "$VITE_API_URL" == *"localhost"* ]] || [ -z "$VITE_API_URL" ]; then
    echo -e "${RED}❌ Primero debes desplegar a Render${NC}"
    echo "Ejecuta: ./deploy-render.sh"
    exit 1
fi

RENDER_URL="$VITE_API_URL"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Configuración Paso a Paso${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo "1️⃣  Crear cuenta en UptimeRobot"
echo ""
echo "   → Ve a: https://uptimerobot.com/signUp"
echo "   → Sign Up (gratis, no tarjeta requerida)"
echo ""
read -p "Presiona ENTER cuando hayas creado tu cuenta..."

echo ""
echo "2️⃣  Agregar nuevo monitor"
echo ""
echo "   → Dashboard → 'Add New Monitor'"
echo ""
read -p "Presiona ENTER cuando estés en 'Add New Monitor'..."

echo ""
echo "3️⃣  Configurar el monitor:"
echo ""
echo "   Monitor Type: HTTP(s)"
echo "   Friendly Name: Budget Tracker"
echo "   URL (or IP): $RENDER_URL/health"
echo "   Monitoring Interval: 5 minutes"
echo ""
echo -e "${YELLOW}📋 URL para copiar:${NC}"
echo -e "${GREEN}$RENDER_URL/health${NC}"
echo ""
read -p "Presiona ENTER cuando hayas configurado el monitor..."

echo ""
echo "4️⃣  Alertas (opcional):"
echo ""
echo "   → Alert Contacts: Agrega tu email"
echo "   → Te notifica si la app se cae"
echo ""
read -p "¿Configuraste alertas? (y/n) " -n 1 -r
echo

echo ""
echo "5️⃣  Click 'Create Monitor'"
echo ""
read -p "Presiona ENTER cuando hayas creado el monitor..."

echo ""
echo -e "${BOLD}${GREEN}╔═══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║                                           ║${NC}"
echo -e "${BOLD}${GREEN}║   ✅ UptimeRobot Configurado!            ║${NC}"
echo -e "${BOLD}${GREEN}║                                           ║${NC}"
echo -e "${BOLD}${GREEN}╚═══════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BLUE}📊 Resumen:${NC}"
echo ""
echo "→ Monitor: $RENDER_URL/health"
echo "→ Intervalo: Cada 5 minutos"
echo "→ Tu app ahora está SIEMPRE despierta"
echo "→ Sin costos adicionales"
echo ""
echo -e "${GREEN}💡 Verificación:${NC}"
echo ""
echo "1. Ve a tu dashboard de UptimeRobot"
echo "2. Verás el monitor como 'Up' (verde)"
echo "3. En 5 minutos hará el primer ping"
echo "4. Render nunca dormirá tu app"
echo ""
echo -e "${YELLOW}📱 Siguiente paso:${NC}"
echo "Tu backend ya está 100% configurado y siempre activo."
echo "Ahora despliega el frontend: ./deploy-vercel.sh"
echo ""
