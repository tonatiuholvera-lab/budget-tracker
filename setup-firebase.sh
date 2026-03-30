#!/bin/bash

# Script para automatizar la creación de Firebase project
# Requiere: firebase-tools instalado globalmente

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

PROJECT_NAME="budget-tracker-familia"

echo -e "${BLUE}🔥 Firebase Setup Automático${NC}"
echo ""

# Verificar si firebase-tools está instalado
if ! command -v firebase &> /dev/null; then
    echo -e "${YELLOW}📦 Instalando firebase-tools...${NC}"
    npm install -g firebase-tools
fi

# Login a Firebase
echo -e "${GREEN}🔐 Iniciando sesión en Firebase...${NC}"
firebase login --no-localhost

# Seleccionar proyecto (ya creado)
echo ""
echo -e "${GREEN}📁 Usando proyecto Firebase: ${PROJECT_NAME}${NC}"
firebase use "$PROJECT_NAME"

# Crear Realtime Database
echo ""
echo -e "${GREEN}💾 Configurando Realtime Database...${NC}"

# Nota: La creación de database se debe hacer desde la consola web
# Pero podemos preparar las reglas

mkdir -p firebase-config
cat > firebase-config/database.rules.json << 'EOF'
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
EOF

cat > firebase-config/firebase.json << 'EOF'
{
  "database": {
    "rules": "firebase-config/database.rules.json"
  }
}
EOF

echo ""
echo -e "${YELLOW}⚠️  IMPORTANTE: Debes crear la Realtime Database manualmente:${NC}"
echo ""
echo "1. Ve a: https://console.firebase.google.com/project/$PROJECT_NAME/database"
echo "2. Click 'Create Database' en la sección 'Realtime Database'"
echo "3. Selecciona ubicación: europe-west1 (Belgium)"
echo "4. Inicia en 'test mode' (reglas abiertas - es una app familiar privada)"
echo ""
read -p "Presiona ENTER cuando hayas creado la database..."

# Descargar service account key
echo ""
echo -e "${GREEN}🔑 Descargando Service Account Key...${NC}"

# Obtener el project number
PROJECT_NUMBER=$(firebase projects:list | grep "$PROJECT_NAME" | awk '{print $3}')

echo ""
echo -e "${YELLOW}Para descargar la Service Account Key:${NC}"
echo ""
echo "1. Ve a: https://console.firebase.google.com/project/$PROJECT_NAME/settings/serviceaccounts/adminsdk"
echo "2. Click 'Generate new private key'"
echo "3. Guarda el archivo como: firebase-service-account.json en este directorio"
echo ""
read -p "Presiona ENTER cuando hayas descargado el archivo..."

# Verificar que el archivo existe
if [ ! -f "firebase-service-account.json" ]; then
    echo -e "${RED}❌ No se encontró firebase-service-account.json${NC}"
    echo "Por favor descárgalo y guárdalo en este directorio, luego vuelve a correr este script"
    exit 1
fi

# Crear archivo .env con las credenciales
echo ""
echo -e "${GREEN}📝 Creando archivo .env...${NC}"

DATABASE_URL="https://$PROJECT_NAME-default-rtdb.europe-west1.firebasedatabase.app"
SERVICE_ACCOUNT=$(cat firebase-service-account.json | jq -c .)

cat > .env << EOF
# Firebase Configuration
FIREBASE_DATABASE_URL=$DATABASE_URL
FIREBASE_SERVICE_ACCOUNT='$SERVICE_ACCOUNT'

# API URL (actualizar después del deploy a Railway)
VITE_API_URL=http://localhost:3001
EOF

echo ""
echo -e "${GREEN}✅ Firebase configurado exitosamente!${NC}"
echo ""
echo "Credenciales guardadas en .env"
echo ""
echo -e "${BLUE}Siguiente paso: Deploy a Railway${NC}"
echo "Ejecuta: ./deploy-railway.sh"
