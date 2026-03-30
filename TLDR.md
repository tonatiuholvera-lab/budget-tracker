# 🚀 TL;DR - Deploy en 1 Comando

## Para deployment completo automatizado:

```bash
cd budget-tracker
./deploy-all.sh
```

**Eso es todo.** El script maneja todo automáticamente. ✨

---

## Lo que hace el script:

### 1️⃣ Firebase Setup (5 min)
- Instala firebase-tools
- Te hace login (abre navegador)
- Crea proyecto `budget-tracker-familia`
- Te pide crear la Database (2 clicks en consola web)
- Te pide descargar service account key (1 click)
- Crea archivo `.env` con credenciales

### 2️⃣ Render Deploy (5 min)
- Crear cuenta en Render.com
- Conectar GitHub
- Configurar web service
- Agregar variables de entorno
- Deploy automático
- Te da la URL del backend

### 3️⃣ UptimeRobot Setup (2 min)
- Crear cuenta en UptimeRobot
- Agregar monitor con tu URL
- Ping cada 5 minutos
- App siempre despierta (sin sleep)

### 4️⃣ Vercel Deploy (2 min)
- Instala vercel CLI
- Te hace login (abre navegador)
- Build del frontend
- Deploy a producción
- Te da la URL del frontend

---

## Resultado final:

```
✅ Backend desplegado en Render
   → https://budget-tracker-backend-xxxx.onrender.com

✅ UptimeRobot configurado
   → App siempre despierta (sin sleep)

✅ Frontend desplegado en Vercel
   → https://budget-tracker-xxxx.vercel.app

✅ Firebase configurado
   → Base de datos en tiempo real funcionando
```

**Comparte la URL de Vercel con Laure y listo!** 🎉

---

## Costos:

- Firebase: $0/mes (plan gratis)
- Render: $0/mes (plan gratis)
- UptimeRobot: $0/mes (plan gratis)
- Vercel: $0/mes (plan hobby)

**Total: $0/mes** 🎉🎉🎉

---

## Si algo falla:

```bash
# Ver logs detallados
cat deploy.log

# Re-intentar solo un paso:
./setup-firebase.sh       # Solo Firebase
./deploy-render.sh        # Solo Render
./setup-uptimerobot.sh    # Solo UptimeRobot
./deploy-vercel.sh        # Solo Vercel
```

---

## Alternativa con Railway ($5/mes):

Si prefieres Railway (sin sleep, sin UptimeRobot):

```bash
./deploy-railway.sh  # Usa este en lugar de deploy-render.sh
```

- No necesitas UptimeRobot
- App siempre instantánea
- Costo: ~$5/mes

---

## Testing post-deploy:

```bash
# 1. Abre la app en tu navegador
# 2. Agrega un gasto
# 3. Abre la misma URL en tu teléfono
# 4. El gasto debe aparecer en ~5 segundos
```

✅ Si ves el gasto en ambos dispositivos → Todo funcionó!

---

## Comandos útiles:

```bash
# Ver logs de Render
# → Render Dashboard → tu servicio → Logs tab

# Ver logs de Vercel
vercel logs

# Re-deploy después de cambios
git commit -am "cambios"
git push  # Render auto-deploya
vercel --prod  # Re-deploy frontend

# Ver status de UptimeRobot
# → Dashboard en uptimerobot.com
```

---

**¿Dudas?** Lee `DEPLOYMENT.md` para guía detallada paso a paso.
