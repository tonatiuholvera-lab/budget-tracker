# Budget Tracker - Familia 💰

App de presupuesto familiar con sync en tiempo real para Tona & Laure.

## Features

- ✅ Tracking de gastos por categoría
- ✅ Presupuestos editables por categoría
- ✅ Sync en tiempo real entre dispositivos
- ✅ Historial completo del mes
- ✅ Consejos de ahorro para Suiza
- ✅ Mobile-first responsive design

## Setup Local

### 1. Instalar dependencias

```bash
npm install
```

### 2. Configurar Firebase (opcional)

Si quieres usar Firebase para persistencia real:

1. Crea un proyecto en [Firebase Console](https://console.firebase.google.com/)
2. Ve a Project Settings > Service Accounts
3. Genera una nueva clave privada
4. Copia el contenido del JSON
5. Crea un archivo `.env`:

```env
FIREBASE_SERVICE_ACCOUNT={"type":"service_account","project_id":"..."}
FIREBASE_DATABASE_URL=https://YOUR-PROJECT.firebaseio.com
```

**Nota:** Si no configuras Firebase, la app funciona igual usando memoria local.

### 3. Correr en desarrollo

Terminal 1 - Backend:
```bash
npm run server
```

Terminal 2 - Frontend:
```bash
npm run dev
```

Abre [http://localhost:3000](http://localhost:3000)

## Deploy Automatizado (1 comando) 🚀

**La forma más fácil** - Todo automatizado:

```bash
./deploy-all.sh
```

Este script ejecuta:
1. Crea proyecto Firebase
2. Deploy backend a Railway
3. Deploy frontend a Vercel

El script te pedirá:
- Login a Firebase (primera vez)
- Login a Railway (primera vez)
- Login a Vercel (primera vez)
- Crear la Realtime Database manualmente (2 clicks)
- Descargar el service account key (1 click)

**Tiempo total: 10-15 minutos**

---

## Deploy Manual

Si prefieres hacerlo paso a paso:

```bash
./setup-firebase.sh   # Paso 1: Firebase
./deploy-railway.sh   # Paso 2: Railway
./deploy-vercel.sh    # Paso 3: Vercel
```

---

## Deploy a Railway (Recomendado)

### Opción 1: Deploy con Firebase

1. Ve a [railway.app](https://railway.app) y crea cuenta
2. "New Project" > "Deploy from GitHub repo"
3. Conecta este repo
4. Agrega las variables de entorno:
   - `FIREBASE_SERVICE_ACCOUNT` (el JSON completo)
   - `FIREBASE_DATABASE_URL`
   - `PORT` = 3001
5. Railway te da una URL automáticamente
6. Actualiza `.env` local con la URL de Railway para `VITE_API_URL`

### Opción 2: Deploy sin Firebase (modo memoria)

1. Railway "New Project" > "Deploy from GitHub"
2. Solo necesitas configurar `PORT=3001`
3. **Limitación:** Los datos se reinician cada vez que el servidor se reinicia

## Deploy a Vercel (Alternativa)

Para el frontend:
```bash
npm run build
vercel --prod
```

El backend deberá estar en Railway u otro servicio Node.js.

## Estructura

```
budget-tracker/
├── src/
│   ├── App.jsx          # Componente principal React
│   ├── main.jsx         # Entry point
│   └── index.css        # Estilos Tailwind
├── server/
│   └── index.js         # Backend Express + Firebase
├── package.json
└── README.md
```

## Categorías

- 🏠 Vivienda (2000 CHF default)
- 🛒 Alimentación (800 CHF)
- 🚌 Transporte (200 CHF)
- 👶 Hijo / Guardería (1200 CHF)
- 🐕 Perros (150 CHF)
- 💊 Salud (300 CHF)
- 🎵 Ocio / Cultura (200 CHF)
- 💰 Ahorro (500 CHF)
- 📦 Otros (150 CHF)

## Sync en Tiempo Real

La app hace polling cada 5 segundos para sincronizar gastos entre dispositivos.
Si usas Firebase, los cambios se propagan automáticamente.

## Tips

- Los presupuestos se pueden editar directamente desde la vista "Resumen"
- Los gastos se pueden eliminar desde "Historial"
- La app funciona offline y sincroniza al reconectar

## Soporte

Para problemas o mejoras, contacta a Tona.
