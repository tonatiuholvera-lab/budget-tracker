# 🚀 Deployment Guide - Railway

## Paso 1: Crear proyecto Firebase (5 minutos)

1. Ve a [console.firebase.google.com](https://console.firebase.google.com)
2. "Add project" → Nombre: `budget-tracker-familia`
3. Desactiva Google Analytics (no necesario)
4. Una vez creado, ve a **Realtime Database** en el menú lateral
5. Click "Create Database" → Ubicación: Europe (belgium) → Start in **test mode**

### Obtener credenciales:

6. Ve a **Project Settings** (⚙️ arriba izquierda)
7. Tab "Service accounts"
8. Click "Generate new private key"
9. Se descarga un archivo JSON → **guárdalo seguro, lo necesitarás**

## Paso 2: Deploy en Railway (5 minutos)

### Primera vez:

1. Ve a [railway.app](https://railway.app)
2. "Login" con GitHub
3. "New Project" → "Deploy from GitHub repo"
4. Si no ves este repo: "Configure GitHub App" → Da acceso a tu repo
5. Selecciona el repo `budget-tracker`

### Configurar variables de entorno:

6. Una vez deployed, click en tu proyecto
7. Tab "Variables"
8. Agrega estas variables:

```
PORT=3001

FIREBASE_DATABASE_URL=https://budget-tracker-familia-default-rtdb.europe-west1.firebasedatabase.app

FIREBASE_SERVICE_ACCOUNT=
```

Para `FIREBASE_SERVICE_ACCOUNT`, **copia TODO el contenido** del JSON que descargaste de Firebase (debe verse así):

```json
{
  "type": "service_account",
  "project_id": "budget-tracker-familia",
  "private_key_id": "abc123...",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...",
  "client_email": "firebase-adminsdk-xxx@budget-tracker-familia.iam.gserviceaccount.com",
  ...
}
```

9. "Deploy" → Railway reiniciará el servicio

### Obtener tu URL:

10. En la vista del proyecto, click "Settings"
11. Sección "Domains" → "Generate Domain"
12. Railway te da una URL como: `budget-tracker-production-xxxx.up.railway.app`

## Paso 3: Configurar el Frontend

En tu computadora local:

1. Crea archivo `.env` en la raíz del proyecto:

```env
VITE_API_URL=https://tu-app.up.railway.app
```

(Reemplaza con la URL que te dio Railway)

2. Build y deploy del frontend:

```bash
npm run build
```

### Opción A: Deploy frontend en Vercel (recomendado)

```bash
npm install -g vercel
vercel --prod
```

- Te pedirá login con GitHub
- Configuración:
  - Framework preset: Vite
  - Build command: `npm run build`
  - Output directory: `dist`
  - Environment variable: `VITE_API_URL` = tu URL de Railway

### Opción B: Servir frontend desde Railway

Edita `railway.json`:

```json
{
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "npm run build && node server/index.js",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

Y agrega esto al `server/index.js` antes de las rutas API:

```javascript
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// Servir archivos estáticos del build
app.use(express.static(path.join(__dirname, '../dist')));

// Todas las rutas no-API van al index.html
app.get('*', (req, res) => {
  if (!req.path.startsWith('/api')) {
    res.sendFile(path.join(__dirname, '../dist/index.html'));
  }
});
```

## Paso 4: Testing

1. Abre la URL de tu app
2. Agrega un gasto desde tu teléfono
3. Abre la URL en otra pestaña/dispositivo
4. Debería aparecer el gasto en 5 segundos (sync automático)

## Troubleshooting

### Error: Firebase no conecta

- Verifica que `FIREBASE_SERVICE_ACCOUNT` sea el JSON completo (con comillas)
- Verifica que `FIREBASE_DATABASE_URL` termine en `.firebasedatabase.app`
- Revisa los logs en Railway: Click proyecto → "Deployments" → Click en el deployment → "View Logs"

### Error: CORS

En `server/index.js`, verifica que el cors esté así:

```javascript
app.use(cors({
  origin: '*', // O especifica tu dominio de Vercel
  credentials: true
}));
```

### Los datos se borran

- Si no configuraste Firebase correctamente, la app usa memoria
- Cada vez que Railway reinicia el servidor, se pierden los datos
- Solución: Configurar Firebase correctamente

## URLs finales

Guarda estas URLs:

- **Backend (Railway):** https://tu-app.up.railway.app
- **Frontend (Vercel):** https://tu-app.vercel.app
- **Firebase Console:** https://console.firebase.google.com/project/budget-tracker-familia

Comparte la URL del frontend con Laure y listo! 🎉

## Costos

- **Firebase:** Plan Spark (gratis) - Suficiente para uso familiar
- **Railway:** $5/mes después de 500 horas gratis
- **Vercel:** Plan Hobby (gratis) - Sin límites para proyectos personales

**Alternativa 100% gratis:** Usa [Render.com](https://render.com) en lugar de Railway (tiene sleep después de 15 min inactivo pero es gratis forever).
