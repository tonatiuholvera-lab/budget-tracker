#!/bin/bash

# Script maestro para deployment completo automatizado
# Ejecuta: Firebase → Railway → Vercel

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

clear

echo ""
echo -e "${BOLD}${BLUE}╔═══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${BLUE}║                                           ║${NC}"
echo -e "${BOLD}${BLUE}║   Budget Tracker - Auto Deploy 🚀        ║${NC}"
echo -e "${BOLD}${BLUE}║                                           ║${NC}"
echo -e "${BOLD}${BLUE}╚═══════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Este script va a:${NC}"
echo ""
echo "  1. 🔥 Crear proyecto Firebase"
echo "  2. 🎨 Desplegar backend a Render (GRATIS)"
echo "  3. 🤖 Configurar UptimeRobot (keep alive)"
echo "  4. ▲  Desplegar frontend a Vercel"
echo ""
echo -e "${YELLOW}Tiempo estimado: 15-20 minutos${NC}"
echo -e "${GREEN}💰 100% GRATIS (sin costos mensuales)${NC}"
echo ""
read -p "¿Continuar? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelado."
    exit 0
fi

# Verificar dependencias
echo ""
echo -e "${BLUE}📋 Verificando dependencias...${NC}"

MISSING_DEPS=0

if ! command -v node &> /dev/null; then
    echo -e "${RED}✗ Node.js no instalado${NC}"
    MISSING_DEPS=1
fi

if ! command -v npm &> /dev/null; then
    echo -e "${RED}✗ npm no instalado${NC}"
    MISSING_DEPS=1
fi

if ! command -v git &> /dev/null; then
    echo -e "${RED}✗ git no instalado${NC}"
    MISSING_DEPS=1
fi

if [ $MISSING_DEPS -eq 1 ]; then
    echo ""
    echo -e "${RED}❌ Faltan dependencias necesarias${NC}"
    echo "Instala Node.js desde: https://nodejs.org"
    exit 1
fi

# Instalar dependencias del proyecto
if [ ! -d "node_modules" ]; then
    echo ""
    echo -e "${BLUE}📦 Instalando dependencias del proyecto...${NC}"
    npm install
fi

echo -e "${GREEN}✓ Todas las dependencias OK${NC}"

# Paso 1: Firebase
echo ""
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${BLUE}  Paso 1/3: Firebase Setup${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

./setup-firebase.sh

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error en Firebase setup${NC}"
    exit 1
fi

# Paso 2: Render
echo ""
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${BLUE}  Paso 2/4: Render Deploy${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

./deploy-render.sh

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error en Render deploy${NC}"
    exit 1
fi

# Paso 3: UptimeRobot
echo ""
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${BLUE}  Paso 3/4: UptimeRobot Setup${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

./setup-uptimerobot.sh

if [ $? -ne 0 ]; then
    echo -e "${YELLOW}⚠️  UptimeRobot no configurado (opcional)${NC}"
fi

# Paso 4: Vercel
echo ""
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${BLUE}  Paso 4/4: Vercel Deploy${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

./deploy-vercel.sh

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error en Vercel deploy${NC}"
    exit 1
fi

# Success!
echo ""
echo -e "${BOLD}${GREEN}╔═══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║                                           ║${NC}"
echo -e "${BOLD}${GREEN}║   ✅ Deployment Completo! 🎉             ║${NC}"
echo -e "${BOLD}${GREEN}║                                           ║${NC}"
echo -e "${BOLD}${GREEN}╚═══════════════════════════════════════════╝${NC}"
echo ""

# Mostrar resumen
source .env
VERCEL_URL=$(grep -o 'https://[^ ]*\.vercel\.app' deploy.log 2>/dev/null | head -1)

echo -e "${BLUE}📊 Resumen del Deploy:${NC}"
echo ""
echo -e "  ${GREEN}Backend (Railway):${NC}"
echo -e "  → $VITE_API_URL"
echo ""
echo -e "  ${GREEN}Frontend (Vercel):${NC}"
echo -e "  → $VERCEL_URL"
echo ""
echo -e "  ${GREEN}Firebase:${NC}"
echo -e "  → $FIREBASE_DATABASE_URL"
echo ""
echo -e "${YELLOW}📱 Próximos pasos:${NC}"
echo ""
echo "  1. Abre la app: $VERCEL_URL"
echo "  2. Comparte la URL con Laure"
echo "  3. Ambos pueden agregar gastos desde cualquier dispositivo"
echo "  4. Los cambios se sincronizan automáticamente"
echo ""
echo -e "${GREEN}💰 Costos aproximados:${NC}"
echo ""
echo "  • Firebase: $0/mes (plan gratis)"
echo "  • Render: $0/mes (plan gratis con UptimeRobot)"
echo "  • Vercel: $0/mes (plan hobby)"
echo "  • UptimeRobot: $0/mes (plan gratis)"
echo ""
echo "  Total: $0/mes 🎉"
echo ""
echo -e "${BLUE}📚 Documentación:${NC}"
echo ""
echo "  • README.md - Documentación completa"
echo "  • DEPLOYMENT.md - Guía de deployment manual"
echo ""
