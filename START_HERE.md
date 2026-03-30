# 🚀 Budget Tracker - Deploy Automatizado

Tracker de gastos familiar con sync en tiempo real para Tona & Laure.

---

## 📋 Índice

- [⚡ Quick Start](#-quick-start)
- [🎯 Lo que hace la app](#-lo-que-hace-la-app)
- [🛠️ Stack Tecnológico](#️-stack-tecnológico)
- [💰 Costos](#-costos)
- [📚 Documentación](#-documentación)
- [🆘 Soporte](#-soporte)

---

## ⚡ Quick Start

### Opción 1: Deploy Automatizado (Recomendado)

Un solo comando hace todo el deployment:

```bash
cd budget-tracker
./deploy-all.sh
```

**Tiempo:** 10-15 minutos
**Resultado:** App live y funcionando

### Opción 2: Desarrollo Local

Para probar localmente primero:

```bash
./setup.sh    # Setup inicial
./start.sh    # Iniciar app
```

Abre [http://localhost:3000](http://localhost:3000)

---

## 🎯 Lo que hace la app

### 📊 Vista Resumen
- Ver gastos del mes por categoría
- Editar presupuestos on-the-fly
- Barra de progreso visual
- Alertas cuando te acercas al límite

### ➕ Agregar Gasto
- Input rápido: monto + categoría + nota
- Se sincroniza automáticamente
- Visible en todos los dispositivos en ~5 seg

### 💡 Consejos
- Tips de ahorro específicos para Suiza
- Prämienverbilligung, Aldi/Lidl, Comparis, etc.
- Consejos prácticos testeados

### 📜 Historial
- Todos los gastos del mes
- Opción de eliminar
- Ordenados por fecha

---

## 🛠️ Stack Tecnológico

**Frontend**
- React 18
- Tailwind CSS
- Vite (build)
- Responsive mobile-first

**Backend**
- Node.js + Express
- Firebase Realtime Database
- CORS habilitado
- RESTful API

**Hosting**
- Frontend: Vercel (gratis)
- Backend: Railway (~$5/mes)
- Database: Firebase (gratis)

---

## 💰 Costos

| Servicio | Costo | Plan |
|----------|-------|------|
| Firebase | $0/mes | Spark (gratis) |
| Railway | ~$5/mes | Hobby |
| Vercel | $0/mes | Hobby (gratis) |
| **Total** | **~$5/mes** | |

### Alternativa 100% Gratis

Usa [Render.com](https://render.com) en lugar de Railway:
- $0/mes
- La app "duerme" después de 15 min inactivo
- Se despierta automáticamente al acceder

---

## 📚 Documentación

### Para empezar:
- **[TLDR.md](TLDR.md)** → 1 comando, todo el deployment
- **[QUICKSTART.md](QUICKSTART.md)** → 2 minutos de lectura
- **[CHECKLIST.md](CHECKLIST.md)** → Checklist paso a paso

### Para deployment:
- **[README.md](README.md)** → Documentación completa
- **[DEPLOYMENT.md](DEPLOYMENT.md)** → Deploy manual paso a paso

### Para problemas:
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** → Soluciones a errores comunes

---

## 🔧 Scripts Disponibles

```bash
# Desarrollo local
./setup.sh          # Setup inicial (solo primera vez)
./start.sh          # Iniciar frontend + backend

# Deployment
./deploy-all.sh     # Deploy completo automatizado
./setup-firebase.sh # Solo Firebase setup
./deploy-railway.sh # Solo Railway deploy
./deploy-vercel.sh  # Solo Vercel deploy

# Utilities
npm run dev         # Frontend dev server
npm run server      # Backend dev server
npm run build       # Build producción
```

---

## 🚀 Deployment Workflow

```
┌─────────────────┐
│  1. Firebase    │  → Crear proyecto + Database
│     Setup       │     Descargar credentials
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  2. Railway     │  → Deploy backend
│     Deploy      │     Configurar env vars
└────────┬────────┘     Obtener URL
         │
         ▼
┌─────────────────┐
│  3. Vercel      │  → Build frontend
│     Deploy      │     Deploy con env vars
└────────┬────────┘     Obtener URL final
         │
         ▼
    ✅ DONE!
```

---

## 🎯 Features

✅ Sync en tiempo real (5 seg polling)
✅ Funciona offline (último estado)
✅ Mobile-first responsive
✅ Sin login necesario (app familiar)
✅ Presupuestos editables
✅ Categorías personalizadas
✅ Historial completo
✅ Consejos de ahorro

---

## 📱 Categorías Predefinidas

| Categoría | Presupuesto Default | Emoji |
|-----------|---------------------|-------|
| Vivienda | 2000 CHF | 🏠 |
| Alimentación | 800 CHF | 🛒 |
| Transporte | 200 CHF | 🚌 |
| Hijo / Guardería | 1200 CHF | 👶 |
| Perros | 150 CHF | 🐕 |
| Salud | 300 CHF | 💊 |
| Ocio / Cultura | 200 CHF | 🎵 |
| Ahorro | 500 CHF | 💰 |
| Otros | 150 CHF | 📦 |

**Total:** 5500 CHF/mes

Todos los presupuestos son editables desde la app.

---

## 🆘 Soporte

### ¿Algo no funciona?

1. Lee [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. Revisa los logs: `railway logs` / `vercel logs`
3. Re-corre el script: `./deploy-all.sh`
4. Contacta soporte:
   - Railway: support@railway.app
   - Vercel: support@vercel.com
   - Firebase: Console → Support

---

## 📊 Estructura del Proyecto

```
budget-tracker/
├── src/
│   ├── App.jsx          # Componente principal
│   ├── main.jsx         # Entry point
│   └── index.css        # Estilos Tailwind
├── server/
│   └── index.js         # Backend Express + Firebase
├── *.sh                 # Scripts de deployment
├── *.md                 # Documentación
└── package.json         # Dependencias
```

---

## 🔐 Seguridad

- Sin login necesario (app familiar privada)
- Credenciales Firebase en variables de entorno
- HTTPS por defecto (Vercel + Railway)
- CORS configurado
- Database rules en test mode (solo para familia)

**Nota:** Para producción con múltiples usuarios, implementar autenticación Firebase Auth.

---

## 🎉 Próximos Pasos

Después del deployment:

1. ✅ Abre la URL de Vercel
2. ✅ Agrega tu primer gasto
3. ✅ Comparte URL con Laure
4. ✅ Agregar app al Home Screen (móviles)
5. ✅ Disfrutar del tracker! 💰

---

## 🤝 Contribuir

Esta es una app familiar privada, pero si quieres agregar features:

1. Fork el repo
2. Crea branch: `git checkout -b feature/nueva-feature`
3. Commit: `git commit -am 'Add feature'`
4. Push: `git push origin feature/nueva-feature`
5. Pull Request

---

## 📄 Licencia

MIT License - Uso libre para proyectos personales.

---

## 👨‍💻 Creado por

**Tona** - Creative Director & Brand Strategist
- Studio: [Daffy](mailto:tona@daffy.studio)
- Location: Zurich, Switzerland

Construido con ❤️ para tracking de gastos familiar.

---

**¿Preguntas?** Lee la [documentación completa](README.md) o el [TL;DR](TLDR.md).

**¿Listo?** Ejecuta: `./deploy-all.sh` 🚀
