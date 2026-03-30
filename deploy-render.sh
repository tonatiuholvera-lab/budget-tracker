#!/bin/bash

# Script para automatizar el deploy a Render.com (gratis)

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🎨 Render Deploy Automático${NC}"
echo ""

# Verificar que exista .env
if [ ! -f ".env" ]; then
    echo -e "${RED}❌ No existe archivo .env${NC}"
    echo "Ejecuta primero: ./setup-firebase.sh"
    exit 1
fi

echo -e "${YELLOW}📋 Pasos a seguir:${NC}"
echo ""
echo "1. Crear cuenta en Render.com (si no tienes)"
echo "2. Conectar tu repositorio GitHub"
echo "3. Configurar variables de entorno"
echo "4. Deploy automático"
echo ""
echo -e "${GREEN}💰 100% GRATIS${NC} (con sleep después de 15 min inactivo)"
echo ""
read -p "¿Continuar? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelado."
    exit 0
fi

# Push a GitHub si no está
echo ""
echo -e "${BLUE}📤 Preparando repositorio...${NC}"

if [ ! -d ".git" ]; then
    echo -e "${YELLOW}Inicializando Git...${NC}"
    git init
    git add .
    git commit -m "Initial commit - Budget Tracker"
fi

# Verificar si hay remote
if ! git remote | grep -q 'origin'; then
    echo ""
    echo -e "${YELLOW}⚠️  No hay repositorio remoto configurado${NC}"
    echo ""
    echo "Opciones:"
    echo "1. Crear nuevo repo en GitHub:"
    echo "   → Ve a https://github.com/new"
    echo "   → Nombre: budget-tracker"
    echo "   → Privado o Público"
    echo ""
    read -p "Pega la URL del repo (ej: https://github.com/tu-usuario/budget-tracker.git): " REPO_URL
    
    if [ -n "$REPO_URL" ]; then
        git remote add origin "$REPO_URL"
        git branch -M main
        git push -u origin main
        echo -e "${GREEN}✓ Código subido a GitHub${NC}"
    else
        echo -e "${RED}❌ URL no proporcionada${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ Repositorio ya configurado${NC}"
    git add .
    git commit -m "Update for Render deployment" || true
    git push
fi

# Instrucciones para Render
echo ""
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${GREEN}  Configuración en Render.com${NC}"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Sigue estos pasos:"
echo ""
echo "1️⃣  Ve a: https://render.com/"
echo "   → Sign Up (usa tu cuenta GitHub)"
echo ""
echo "2️⃣  Dashboard → 'New +' → 'Web Service'"
echo ""
echo "3️⃣  Conecta tu repositorio:"
echo "   → Busca: budget-tracker"
echo "   → Click 'Connect'"
echo ""
echo "4️⃣  Configuración del servicio:"
echo ""
echo "   Name: budget-tracker-backend"
echo "   Region: Oregon (US West) o Frankfurt (EU)"
echo "   Branch: main"
echo "   Root Directory: (dejar vacío)"
echo "   Runtime: Node"
echo "   Build Command: npm install"
echo "   Start Command: node server/index.js"
echo "   Instance Type: Free"
echo ""
echo "5️⃣  Environment Variables (sección 'Advanced'):"
echo ""

# Leer variables del .env
source .env

echo "   PORT = 3001"
echo ""
echo "   FIREBASE_DATABASE_URL = $FIREBASE_DATABASE_URL"
echo ""
echo "   FIREBASE_SERVICE_ACCOUNT ="
echo "   (Copia todo el contenido del archivo firebase-service-account.json)"
echo ""

cat > render-env-vars.txt << EOF
PORT=3001
FIREBASE_DATABASE_URL=$FIREBASE_DATABASE_URL
FIREBASE_SERVICE_ACCOUNT=$(cat firebase-service-account.json | jq -c .)
EOF

echo -e "${GREEN}✓ Variables guardadas en: render-env-vars.txt${NC}"
echo ""
echo "6️⃣  Click 'Create Web Service'"
echo ""
echo "7️⃣  Espera el deploy (2-3 minutos)..."
echo ""
echo "8️⃣  Copia la URL de tu servicio:"
echo "   → Se verá como: https://budget-tracker-backend-xxxx.onrender.com"
echo ""
read -p "Pega tu URL de Render aquí: " RENDER_URL

if [ -z "$RENDER_URL" ]; then
    echo -e "${RED}❌ URL no proporcionada${NC}"
    exit 1
fi

# Actualizar .env con la URL de Render
echo ""
echo -e "${GREEN}📝 Actualizando .env con URL de producción...${NC}"

if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s|VITE_API_URL=.*|VITE_API_URL=$RENDER_URL|" .env
else
    sed -i "s|VITE_API_URL=.*|VITE_API_URL=$RENDER_URL|" .env
fi

echo ""
echo -e "${GREEN}✅ Backend desplegado en Render!${NC}"
echo ""
echo -e "${BLUE}URL del backend:${NC} $RENDER_URL"
echo ""
echo -e "${YELLOW}⚠️  Importante sobre el plan gratis:${NC}"
echo ""
echo "→ Tu app se 'duerme' después de 15 min sin uso"
echo "→ Al acceder, tarda 30-60 seg en 'despertar'"
echo "→ Para evitar esto, configura UptimeRobot (siguiente paso)"
echo ""
echo -e "${BLUE}Siguiente paso: Deploy del Frontend${NC}"
echo "Ejecuta: ./deploy-vercel.sh"
