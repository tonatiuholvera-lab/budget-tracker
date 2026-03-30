#!/bin/bash

echo "🚀 Budget Tracker - Setup"
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js no está instalado. Instala Node.js primero: https://nodejs.org/"
    exit 1
fi

echo -e "${GREEN}✓${NC} Node.js encontrado: $(node --version)"

# Instalar dependencias
echo ""
echo "📦 Instalando dependencias..."
npm install

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Dependencias instaladas"
else
    echo "❌ Error instalando dependencias"
    exit 1
fi

# Crear .env si no existe
if [ ! -f .env ]; then
    echo ""
    echo "📝 Creando archivo .env..."
    cp .env.example .env
    echo -e "${GREEN}✓${NC} Archivo .env creado"
    echo ""
    echo -e "${YELLOW}⚠️  IMPORTANTE:${NC}"
    echo "   Si quieres usar Firebase, edita el archivo .env con tus credenciales."
    echo "   Si no, la app funcionará con almacenamiento en memoria."
fi

echo ""
echo -e "${GREEN}✅ Setup completo!${NC}"
echo ""
echo "Para iniciar la app:"
echo ""
echo "  Terminal 1 - Backend:"
echo "  ${GREEN}npm run server${NC}"
echo ""
echo "  Terminal 2 - Frontend:"
echo "  ${GREEN}npm run dev${NC}"
echo ""
echo "Luego abre: http://localhost:3000"
echo ""
