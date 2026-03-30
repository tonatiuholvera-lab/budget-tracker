# 🚀 Quick Start

## Desarrollo Local (2 comandos)

```bash
# 1. Setup inicial (solo primera vez)
./setup.sh

# 2. Iniciar app
./start.sh
```

Abre [http://localhost:3000](http://localhost:3000)

---

## Deploy a Producción (10 minutos)

### 1. Firebase Setup

```bash
# Crea proyecto en console.firebase.google.com
# → Realtime Database → Create Database (test mode)
# → Project Settings → Service Accounts → Generate new private key
# → Guarda el JSON
```

### 2. Railway Deploy

```bash
# Crea cuenta en railway.app
# → New Project → Deploy from GitHub
# → Agrega variables de entorno:

PORT=3001
FIREBASE_DATABASE_URL=https://tu-proyecto.firebaseio.com
FIREBASE_SERVICE_ACCOUNT={"type":"service_account",...}

# → Copia la URL que te da Railway
```

### 3. Frontend Deploy

```bash
# Crea .env con la URL de Railway
echo "VITE_API_URL=https://tu-app.railway.app" > .env

# Build
npm run build

# Deploy a Vercel
npm run deploy:vercel
```

**Done!** 🎉

Comparte la URL de Vercel con Laure.

---

## Estructura de la App

```
📱 4 Vistas:

📊 Resumen
   → Ver gastos del mes por categoría
   → Editar presupuestos
   → Barra de progreso total

➕ + Gasto
   → Agregar nuevo gasto
   → Seleccionar categoría
   → Agregar nota opcional

💡 Consejos
   → Tips de ahorro para Suiza
   → Prämienverbilligung, Aldi/Lidl, etc.

📜 Historial
   → Todos los gastos del mes
   → Opción de eliminar
   → Ordenados por fecha
```

---

## Features

✅ Sync en tiempo real entre dispositivos (5 seg)
✅ Datos persistentes en Firebase
✅ Mobile-first responsive
✅ Funciona offline
✅ Sin login necesario (app familiar privada)

---

## Costos

- **Desarrollo local:** $0
- **Firebase:** $0 (plan gratis)
- **Railway:** $5/mes o $0 con [Render.com](https://render.com)
- **Vercel:** $0 (plan hobby)

**Total: ~$0-5/mes**

---

## Support

Ver guías detalladas:
- `README.md` - Setup completo
- `DEPLOYMENT.md` - Deploy paso a paso
