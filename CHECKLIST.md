# ✅ Deployment Checklist

Usa este checklist para asegurarte de que todo esté listo.

---

## Pre-Deployment

- [ ] Node.js instalado (`node --version`)
- [ ] npm instalado (`npm --version`)
- [ ] Git instalado (`git --version`)
- [ ] Dependencias del proyecto instaladas (`npm install`)
- [ ] Cuenta GitHub creada
- [ ] Repositorio creado en GitHub (opcional, para auto-deploy)

---

## Firebase Setup

- [ ] Cuenta Firebase creada
- [ ] `firebase-tools` instalado (`npm install -g firebase-tools`)
- [ ] Login exitoso (`firebase login`)
- [ ] Proyecto Firebase creado (`budget-tracker-familia`)
- [ ] Realtime Database creada (europe-west1)
- [ ] Database en test mode (reglas `.read: true, .write: true`)
- [ ] Service Account Key descargado (`firebase-service-account.json`)
- [ ] Archivo `.env` creado con credenciales

---

## Railway Deployment

- [ ] Cuenta Railway creada
- [ ] Railway CLI instalado (`npm install -g @railway/cli`)
- [ ] Login exitoso (`railway login`)
- [ ] Proyecto Railway creado
- [ ] Variables de entorno configuradas:
  - [ ] `PORT=3001`
  - [ ] `FIREBASE_DATABASE_URL`
  - [ ] `FIREBASE_SERVICE_ACCOUNT`
- [ ] Deploy exitoso (`railway up`)
- [ ] URL del backend obtenida
- [ ] Backend responde en `/health` endpoint

**Test:** Visita `https://tu-app.railway.app/health`
Debe responder: `{"status":"ok","timestamp":"..."}`

---

## Vercel Deployment

- [ ] Cuenta Vercel creada
- [ ] Vercel CLI instalado (`npm install -g vercel`)
- [ ] Login exitoso (`vercel login`)
- [ ] `.env` actualizado con `VITE_API_URL` de Railway
- [ ] Build exitoso (`npm run build`)
- [ ] Deploy exitoso (`vercel --prod`)
- [ ] URL del frontend obtenida
- [ ] Frontend carga correctamente

**Test:** Visita `https://tu-app.vercel.app`
Debe cargar la app sin errores

---

## Verificación Final

- [ ] Agregar gasto desde desktop → Aparece en el historial
- [ ] Abrir app en móvil → Ver el mismo gasto
- [ ] Agregar gasto desde móvil → Aparece en desktop (~5 seg)
- [ ] Editar presupuesto → Se guarda correctamente
- [ ] Eliminar gasto → Se elimina en ambos dispositivos
- [ ] No hay errores en consola del navegador (F12)
- [ ] App funciona sin internet (muestra último estado)
- [ ] Al reconectar internet → Sincroniza cambios

---

## Post-Deployment

- [ ] URL del frontend compartida con Laure
- [ ] Ambos pueden acceder a la app
- [ ] App agregada a Home Screen en móviles
- [ ] Notificaciones de costos configuradas (opcional)
- [ ] Backup manual de Firebase (opcional)

---

## URLs para Guardar

```
Frontend (Vercel):
→ https://_______________________.vercel.app

Backend (Railway):
→ https://_______________________.up.railway.app

Firebase Console:
→ https://console.firebase.google.com/project/budget-tracker-familia

Railway Dashboard:
→ https://railway.app/dashboard

Vercel Dashboard:
→ https://vercel.com/dashboard
```

---

## Comandos Útiles

```bash
# Ver logs
railway logs          # Backend
vercel logs          # Frontend

# Re-deploy
railway up           # Backend
vercel --prod        # Frontend

# Ver variables
railway variables    # Railway env vars
cat .env            # Local env vars

# Test local
./start.sh          # Correr local
```

---

## Costos Mensuales Estimados

- Firebase: **$0** (plan Spark)
- Railway: **~$5** (plan Hobby)
- Vercel: **$0** (plan Hobby)
- Dominio custom (opcional): **~$12/año**

**Total: ~$5/mes**

---

## Si Algo Falla

1. Lee `TROUBLESHOOTING.md`
2. Revisa los logs
3. Re-corre el script de ese paso
4. Si nada funciona: `./deploy-all.sh` desde cero

---

## ✅ Done!

Si todas las casillas están marcadas:

🎉 **¡Felicidades! Tu app está live y funcionando.**

Comparte la URL con Laure y disfruten del Budget Tracker!
