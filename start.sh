#!/bin/bash

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Budget Tracker${NC} - Starting..."
echo ""

# Verificar que las dependencias estén instaladas
if [ ! -d "node_modules" ]; then
    echo "📦 Instalando dependencias..."
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ Error instalando dependencias"
        exit 1
    fi
fi

# Crear .env si no existe
if [ ! -f .env ]; then
    cp .env.example .env
fi

# Matar procesos previos en los puertos
echo "🧹 Limpiando puertos..."
lsof -ti:3000 | xargs kill -9 2>/dev/null
lsof -ti:3001 | xargs kill -9 2>/dev/null

# Función para limpiar al salir
cleanup() {
    echo ""
    echo "🛑 Cerrando servidores..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    exit 0
}

trap cleanup SIGINT SIGTERM

# Iniciar backend
echo ""
echo -e "${GREEN}🚀 Iniciando backend...${NC}"
npm run server > backend.log 2>&1 &
BACKEND_PID=$!

# Esperar a que el backend esté listo
sleep 3

# Iniciar frontend
echo -e "${GREEN}🎨 Iniciando frontend...${NC}"
npm run dev > frontend.log 2>&1 &
FRONTEND_PID=$!

# Esperar a que el frontend esté listo
sleep 5

echo ""
echo -e "${GREEN}✅ Todo listo!${NC}"
echo ""
echo "📱 Abre tu navegador en:"
echo -e "   ${BLUE}http://localhost:3000${NC}"
echo ""
echo "💡 Presiona Ctrl+C para detener los servidores"
echo ""
echo "📊 Logs en tiempo real:"
echo "   Backend:  tail -f backend.log"
echo "   Frontend: tail -f frontend.log"
echo ""

# Mantener el script corriendo
wait $BACKEND_PID $FRONTEND_PID
