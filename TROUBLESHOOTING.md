# 🔧 Troubleshooting

## Problemas Comunes y Soluciones

### 1. "firebase: command not found"

**Problema:** firebase-tools no está instalado

**Solución:**
```bash
npm install -g firebase-tools
```

---

### 2. "railway: command not found"

**Problema:** Railway CLI no está instalado

**Solución:**
```bash
npm install -g @railway/cli
```

---

### 3. "vercel: command not found"

**Problema:** Vercel CLI no está instalado

**Solución:**
```bash
npm install -g vercel
```

---

### 4. Firebase login falla

**Problema:** No se puede autenticar con Firebase

**Solución:**
```bash
# Usar modo no-localhost
firebase login --no-localhost

# O usar reauth
firebase login --reauth
```

---

### 5. Railway login falla

**Problema:** No se puede autenticar con Railway

**Solución:**
```bash
# Logout y volver a login
railway logout
railway login
```

---

### 6. "FIREBASE_SERVICE_ACCOUNT is not valid JSON"

**Problema:** El service account key no se copió correctamente

**Solución:**
1. Ve a Firebase Console
2. Project Settings → Service Accounts
3. Generate new private key
4. Guarda el archivo como `firebase-service-account.json`
5. Vuelve a correr `./setup-firebase.sh`

---

### 7. "Cannot read property 'database' of undefined"

**Problema:** Firebase no está inicializado correctamente

**Solución:**
```bash
# Verifica que las variables estén bien en Railway
railway variables

# Re-sube las variables
railway variables set FIREBASE_SERVICE_ACCOUNT="$(cat firebase-service-account.json | jq -c .)"
```

---

### 8. CORS Error en el frontend

**Problema:** El frontend no puede conectarse al backend

**Solución:**

Verifica que `VITE_API_URL` en `.env` tenga la URL correcta:

```bash
# Ver el valor actual
cat .env | grep VITE_API_URL

# Actualizarlo
echo "VITE_API_URL=https://tu-app.railway.app" > .env
```

Luego re-deploy del frontend:
```bash
npm run build
vercel --prod
```

---

### 9. Los datos no se sincronizan

**Problema:** Firebase no está conectado o hay un error de permisos

**Solución:**

1. Verifica que la Database esté en test mode:
   - Firebase Console → Realtime Database → Rules
   - Debe ser:
   ```json
   {
     "rules": {
       ".read": true,
       ".write": true
     }
   }
   ```

2. Verifica los logs del backend:
   ```bash
   railway logs
   ```

3. Busca errores relacionados con Firebase

---

### 10. "Port 3000/3001 already in use"

**Problema:** Los puertos están ocupados

**Solución:**
```bash
# En macOS/Linux
lsof -ti:3000 | xargs kill -9
lsof -ti:3001 | xargs kill -9

# Luego vuelve a iniciar
./start.sh
```

---

### 11. Build falla en Vercel

**Problema:** El build del frontend tiene errores

**Solución:**
```bash
# Probar el build localmente
npm run build

# Ver errores
cat dist/index.html

# Limpiar cache y reinstalar
rm -rf node_modules dist
npm install
npm run build
```

---

### 12. Railway no encuentra el comando de inicio

**Problema:** El start command no está bien configurado

**Solución:**

Verifica `railway.json`:
```json
{
  "deploy": {
    "startCommand": "node server/index.js"
  }
}
```

O configúralo manualmente:
```bash
railway up --start "node server/index.js"
```

---

### 13. Los cambios no se reflejan después de un push

**Problema:** El deploy automático no está configurado

**Solución:**

**Railway:**
- Settings → Deploy Triggers → Enable GitHub trigger

**Vercel:**
- Se auto-deploya por defecto en cada push

Para force deploy:
```bash
railway up --force
vercel --prod --force
```

---

### 14. Firebase Realtime Database no aparece

**Problema:** No se creó la Database

**Solución:**
1. Ve a [Firebase Console](https://console.firebase.google.com)
2. Selecciona tu proyecto
3. En el menú lateral: "Realtime Database"
4. Click "Create Database"
5. Selecciona región: europe-west1
6. Start in test mode

---

### 15. "Module not found" en producción

**Problema:** Dependencias no instaladas correctamente

**Solución:**
```bash
# Limpiar y reinstalar
rm -rf node_modules package-lock.json
npm install

# Re-deploy
railway up
```

---

### 16. Costos inesperados

**Problema:** Railway cobra más de lo esperado

**Solución:**

Railway cobra por:
- Uso de CPU/RAM
- Tiempo activo

Para minimizar costos:
1. Usa plan Hobby ($5/mes fijo)
2. O cambia a [Render.com](https://render.com) (gratis con sleep)

**Alternativa gratis:**
```bash
# Deploy a Render en lugar de Railway
# 1. Crea cuenta en render.com
# 2. New Web Service
# 3. Conecta GitHub
# 4. Configura variables
# 5. Deploy
```

---

### 17. La app es muy lenta

**Problema:** Latencia en las requests

**Solución:**

1. **Usar región más cercana:**
   - Railway: Selecciona región Europe
   - Firebase: Ya está en europe-west1

2. **Optimizar polling:**
   En `src/App.jsx`, cambiar intervalo:
   ```javascript
   // De 5000 (5 seg) a 10000 (10 seg)
   setInterval(async () => { ... }, 10000);
   ```

3. **Implementar WebSockets (avanzado):**
   - Usa Socket.io para sync verdaderamente en tiempo real
   - Requiere modificar backend y frontend

---

### 18. Quiero cambiar el dominio

**Problema:** La URL de Vercel es fea

**Solución:**

1. Compra un dominio (ej: budgettracker.familia en Namecheap)
2. En Vercel:
   - Settings → Domains
   - Add `budgettracker.familia`
3. En tu proveedor DNS:
   - Agrega CNAME: `budgettracker` → `cname.vercel-dns.com`

---

## 🆘 Ayuda Adicional

Si nada de esto funciona:

1. **Revisa los logs:**
   ```bash
   railway logs
   vercel logs
   ```

2. **Busca el error en Google/Stack Overflow**

3. **Re-deploy desde cero:**
   ```bash
   rm -rf node_modules .env
   ./deploy-all.sh
   ```

4. **Contacta soporte:**
   - Railway: support@railway.app
   - Vercel: support@vercel.com
   - Firebase: Firebase Console → Support

---

## ✅ Verificación Post-Deploy

Checklist para verificar que todo funciona:

- [ ] Backend responde en `https://tu-app.railway.app/health`
- [ ] Frontend carga en `https://tu-app.vercel.app`
- [ ] Puedes agregar un gasto
- [ ] El gasto aparece en otro dispositivo en ~5 seg
- [ ] Puedes editar presupuestos
- [ ] El historial muestra todos los gastos
- [ ] No hay errores en la consola del navegador (F12)

Si todas las casillas están marcadas → ✅ Todo funciona!
