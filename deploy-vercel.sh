#!/bin/bash

# Script para automatizar el deploy del frontend a Vercel

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}▲ Vercel Deploy Automático${NC}"
echo ""

# Verificar que exista .env con la URL de Railway
if [ ! -f ".env" ]; then
    echo -e "${RED}❌ No existe archivo .env${NC}"
    exit 1
fi

source .env

if [[ "$VITE_API_URL" == *"localhost"* ]]; then
    echo -e "${RED}❌ VITE_API_URL todavía apunta a localhost${NC}"
    echo "Ejecuta primero: ./deploy-railway.sh"
    exit 1
fi

# Instalar Vercel CLI si no está instalado
if ! command -v vercel &> /dev/null; then
    echo -e "${YELLOW}📦 Instalando Vercel CLI...${NC}"
    npm install -g vercel
fi

# Login a Vercel
echo -e "${GREEN}🔐 Iniciando sesión en Vercel...${NC}"
vercel login

# Build
echo ""
echo -e "${GREEN}🏗️  Building frontend...${NC}"
npm run build

# Deploy a producción
echo ""
echo -e "${GREEN}🚀 Desplegando a Vercel...${NC}"

# Configurar variables de entorno en Vercel
vercel env add VITE_API_URL production <<< "$VITE_API_URL"

# Deploy
vercel --prod --yes

# Obtener la URL
VERCEL_URL=$(vercel ls | grep -o 'https://[^ ]*\.vercel\.app' | head -1)

echo ""
echo -e "${GREEN}✅ Frontend desplegado exitosamente!${NC}"
echo ""
echo -e "${BLUE}🌐 URLs de tu app:${NC}"
echo ""
echo -e "   Backend:  $VITE_API_URL"
echo -e "   Frontend: $VERCEL_URL"
echo ""
echo -e "${GREEN}🎉 Todo listo!${NC}"
echo ""
echo "Comparte esta URL con Laure: $VERCEL_URL"
echo ""
echo "Prueba la app:"
echo "1. Abre $VERCEL_URL"
echo "2. Agrega un gasto"
echo "3. Abre la misma URL en otro dispositivo"
echo "4. El gasto debería aparecer en ~5 segundos"
echo ""
