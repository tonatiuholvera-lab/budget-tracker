# 🤖 UptimeRobot - Keep Render Alive 24/7

## ¿Por qué UptimeRobot?

El plan gratuito de Render duerme tu app después de 15 minutos de inactividad. UptimeRobot hace ping cada 5 minutos, manteniendo tu app despierta constantemente.

**Resultado:** App siempre instantánea, 100% gratis, sin costos adicionales.

---

## Setup Rápido (5 minutos)

### 1. Crear cuenta

Ve a [uptimerobot.com/signUp](https://uptimerobot.com/signUp)
- Sign Up (gratis, no requiere tarjeta)
- Confirma tu email

### 2. Agregar monitor

Dashboard → **Add New Monitor**

**Configuración:**
```
Monitor Type: HTTP(s)
Friendly Name: Budget Tracker
URL (or IP): https://tu-app.onrender.com/health
Monitoring Interval: 5 minutes
```

**Importante:** La URL debe terminar en `/health` - este endpoint ya está configurado en el backend.

### 3. Configurar alertas (opcional)

- Alert Contacts → Add email
- Recibirás notificación si la app se cae
- Útil para debugging

### 4. Guardar

Click **Create Monitor**

**¡Listo!** En 5 minutos hará el primer ping y tu app estará siempre despierta.

---

## Verificación

### Dashboard de UptimeRobot

Verás tu monitor con estos estados:

- 🟢 **Up** - Todo funcionando
- 🔴 **Down** - App no responde
- 🟡 **Paused** - Monitor pausado

### Testing Manual

Prueba tu endpoint:

```bash
curl https://tu-app.onrender.com/health
```

Debe responder:
```json
{"status":"ok","timestamp":"2026-03-30T..."}
```

---

## Cómo Funciona

### El Problema

```
Usuario abre app después de 20 min
         ↓
Render despierta la app (30-60 seg)
         ↓
Usuario espera... 😴
         ↓
App finalmente carga
```

### La Solución

```
UptimeRobot hace ping cada 5 min
         ↓
Render piensa: "¡Hay actividad!"
         ↓
App nunca se duerme
         ↓
Usuario abre app → Carga instantánea ✅
```

---

## Planes de UptimeRobot

| Plan | Costo | Monitores | Intervalo |
|------|-------|-----------|-----------|
| **Free** | $0/mes | 50 | 5 min |
| Pro | $7/mes | 100 | 1 min |

**Para Budget Tracker:** El plan gratuito es perfecto (solo necesitas 1 monitor).

---

## Alternativas a UptimeRobot

### 1. Cron-job.org

Similar a UptimeRobot, también gratis:
- https://cron-job.org
- Hasta 5 cron jobs gratis
- Ping cada 5 minutos

### 2. Healthchecks.io

Monitoreo de salud gratuito:
- https://healthchecks.io
- 20 checks gratis
- Ping manual o automático

### 3. Script propio (avanzado)

Crea tu propio pinger con GitHub Actions:

```yaml
# .github/workflows/keep-alive.yml
name: Keep Render Alive
on:
  schedule:
    - cron: '*/5 * * * *'  # Cada 5 minutos
jobs:
  ping:
    runs-on: ubuntu-latest
    steps:
      - name: Ping Render
        run: curl https://tu-app.onrender.com/health
```

---

## Monitoreo en Tiempo Real

### UptimeRobot Dashboard

- **Response Time**: Tiempo de respuesta del endpoint
- **Uptime Percentage**: % de tiempo activo (objetivo: 100%)
- **Downtime History**: Historial de caídas

### Render Dashboard

En Render puedes ver:
- Logs en tiempo real
- Métricas de CPU/RAM
- Cuándo la app se despierta

---

## Troubleshooting

### Monitor marca "Down"

**Problema:** UptimeRobot no puede conectarse

**Soluciones:**

1. Verifica que tu app esté deployed:
   ```bash
   curl https://tu-app.onrender.com/health
   ```

2. Revisa logs en Render Dashboard

3. Asegúrate que el endpoint `/health` existe

4. Verifica que CORS esté habilitado

### App sigue durmiéndose

**Problema:** A pesar de UptimeRobot, la app duerme

**Causas posibles:**

1. **Intervalo mayor a 15 min**
   - Verifica: debe ser 5 minutos, no más

2. **URL incorrecta**
   - Debe ser: `https://tu-app.onrender.com/health`
   - NO: `https://tu-app.onrender.com` (sin /health)

3. **Monitor pausado**
   - Verifica en dashboard que esté activo (verde)

### Demasiadas requests

**Problema:** 750 horas/mes no son suficientes

**Matemática:**
- 12 pings/hora × 24 horas × 30 días = 8,640 pings/mes
- Cada ping consume ~1 segundo
- Total: ~2.4 horas/mes

**Conclusión:** UptimeRobot usa MUY pocas de tus 750 horas. No es problema.

---

## Costos Render con UptimeRobot

| Item | Costo |
|------|-------|
| Render Free Tier | $0 |
| UptimeRobot Free | $0 |
| Firebase | $0 |
| Vercel | $0 |
| **Total** | **$0/mes** |

**¡Todo 100% gratis!** 🎉

---

## Optimizaciones Avanzadas

### 1. Múltiples endpoints

Monitorea varios endpoints:
- `/health` - Backend health
- `/api/transactions` - API funcional
- Frontend URL - Vercel activo

### 2. Notificaciones

Configura alertas:
- Email cuando app se cae
- Webhook a Slack
- SMS (plan pago)

### 3. Status Page

UptimeRobot puede generar una página de status pública:
- Comparte con Laure
- Muestra uptime en tiempo real
- Historial de incidentes

---

## FAQ

**¿Es legal usar UptimeRobot para evitar el sleep?**
- ✅ Sí, totalmente legal
- Render no lo prohíbe
- Uso común en la comunidad

**¿Afecta el rendimiento?**
- ❌ No, el ping es súper ligero
- Solo consume ~0.3% de tus 750 horas/mes

**¿Qué pasa si UptimeRobot se cae?**
- Tu app volverá a dormirse después de 15 min
- Pero UptimeRobot tiene 99.9% uptime

**¿Puedo usar esto en producción?**
- ✅ Sí, muchas apps lo usan
- Para apps pequeñas/familiares es perfecto
- Para apps con tráfico real, mejor plan pago

---

## Recursos

- [UptimeRobot Docs](https://uptimerobot.com/api/)
- [Render Free Tier](https://render.com/docs/free)
- [Keep Render Alive - Guide](https://medium.com/@prajju.18gryphon/keep-your-render-free-apps-alive-24-7-41aa85d71256)

---

## Resumen

1. ✅ Crea cuenta en UptimeRobot
2. ✅ Agrega monitor con tu URL + `/health`
3. ✅ Intervalo: 5 minutos
4. ✅ Tu app nunca duerme
5. ✅ 100% gratis para siempre

**¡Disfruta de tu app siempre activa sin pagar!** 🚀
