#!/bin/bash

# Script para automatizar el deploy a Railway
# Requiere: railway CLI instalado

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🚂 Railway Deploy Automático${NC}"
echo ""

# Verificar que exista .env
if [ ! -f ".env" ]; then
    echo -e "${RED}❌ No existe archivo .env${NC}"
    echo "Ejecuta primero: ./setup-firebase.sh"
    exit 1
fi

# Instalar Railway CLI si no está instalado
if ! command -v railway &> /dev/null; then
    echo -e "${YELLOW}📦 Instalando Railway CLI...${NC}"
    npm install -g @railway/cli
fi

# Login a Railway
echo -e "${GREEN}🔐 Iniciando sesión en Railway...${NC}"
railway login

# Inicializar proyecto
echo ""
echo -e "${GREEN}📁 Creando proyecto en Railway...${NC}"
railway init

# Obtener las variables de .env
echo ""
echo -e "${GREEN}⚙️  Configurando variables de entorno...${NC}"

source .env

railway variables set PORT=3001
railway variables set FIREBASE_DATABASE_URL="$FIREBASE_DATABASE_URL"
railway variables set FIREBASE_SERVICE_ACCOUNT="$FIREBASE_SERVICE_ACCOUNT"

# Deploy
echo ""
echo -e "${GREEN}🚀 Desplegando a Railway...${NC}"
railway up

# Obtener la URL
echo ""
echo -e "${GREEN}🌐 Obteniendo URL del proyecto...${NC}"
sleep 5

RAILWAY_URL=$(railway domain | grep -o 'https://[^ ]*')

if [ -z "$RAILWAY_URL" ]; then
    echo -e "${YELLOW}⚠️  No se pudo obtener la URL automáticamente${NC}"
    echo ""
    echo "Obtén tu URL manualmente:"
    echo "1. Ve a: https://railway.app/dashboard"
    echo "2. Click en tu proyecto 'budget-tracker'"
    echo "3. Tab 'Settings' → 'Domains' → 'Generate Domain'"
    echo ""
    read -p "Ingresa la URL de Railway: " RAILWAY_URL
fi

# Actualizar .env con la URL de Railway
echo ""
echo -e "${GREEN}📝 Actualizando .env con URL de producción...${NC}"

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s|VITE_API_URL=.*|VITE_API_URL=$RAILWAY_URL|" .env
else
    # Linux
    sed -i "s|VITE_API_URL=.*|VITE_API_URL=$RAILWAY_URL|" .env
fi

echo ""
echo -e "${GREEN}✅ Backend desplegado exitosamente!${NC}"
echo ""
echo -e "${BLUE}URL del backend:${NC} $RAILWAY_URL"
echo ""
echo -e "${BLUE}Siguiente paso: Deploy del Frontend${NC}"
echo "Ejecuta: ./deploy-vercel.sh"
