import express from 'express';
import cors from 'cors';
import admin from 'firebase-admin';

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Inicializar Firebase
let db;
try {
  if (process.env.FIREBASE_SERVICE_ACCOUNT) {
    // Para producción (Railway/Vercel)
    const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
      databaseURL: process.env.FIREBASE_DATABASE_URL
    });
  } else {
    // Para desarrollo local - usar un mock en memoria si no hay Firebase configurado
    console.log('⚠️  Firebase no configurado - usando almacenamiento en memoria');
  }
  db = admin.database();
} catch (error) {
  console.log('⚠️  No se pudo inicializar Firebase - usando almacenamiento en memoria');
}

// Mock storage en memoria si no hay Firebase
let memoryStorage = {
  transactions: [],
  budgets: {
    housing: 2000,
    food: 800,
    transport: 200,
    childcare: 1200,
    pets: 150,
    health: 300,
    leisure: 200,
    savings: 500,
    other: 150,
  }
};

// Helper para usar Firebase o memoria
const getTransactions = async () => {
  if (db) {
    const snapshot = await db.ref('transactions').once('value');
    const data = snapshot.val();
    return data ? Object.entries(data).map(([id, tx]) => ({ id, ...tx })) : [];
  }
  return memoryStorage.transactions;
};

const saveTransaction = async (tx) => {
  if (db) {
    const ref = db.ref('transactions').push();
    const txWithId = { ...tx, id: ref.key };
    await ref.set(txWithId);
    return txWithId;
  }
  const txWithId = { ...tx, id: `tx_${Date.now()}_${Math.random().toString(36).substr(2, 9)}` };
  memoryStorage.transactions.push(txWithId);
  return txWithId;
};

const deleteTransaction = async (id) => {
  if (db) {
    await db.ref(`transactions/${id}`).remove();
  } else {
    memoryStorage.transactions = memoryStorage.transactions.filter(tx => tx.id !== id);
  }
};

const getBudgets = async () => {
  if (db) {
    const snapshot = await db.ref('budgets').once('value');
    return snapshot.val() || memoryStorage.budgets;
  }
  return memoryStorage.budgets;
};

const saveBudgets = async (budgets) => {
  if (db) {
    await db.ref('budgets').set(budgets);
  } else {
    memoryStorage.budgets = budgets;
  }
};

// Routes
app.get('/api/transactions', async (req, res) => {
  try {
    const transactions = await getTransactions();
    res.json(transactions);
  } catch (error) {
    console.error('Error obteniendo transacciones:', error);
    res.status(500).json({ error: 'Error obteniendo transacciones' });
  }
});

app.post('/api/transactions', async (req, res) => {
  try {
    const savedTx = await saveTransaction(req.body);
    res.json(savedTx);
  } catch (error) {
    console.error('Error guardando transacción:', error);
    res.status(500).json({ error: 'Error guardando transacción' });
  }
});

app.delete('/api/transactions/:id', async (req, res) => {
  try {
    await deleteTransaction(req.params.id);
    res.json({ success: true });
  } catch (error) {
    console.error('Error eliminando transacción:', error);
    res.status(500).json({ error: 'Error eliminando transacción' });
  }
});

app.get('/api/budgets', async (req, res) => {
  try {
    const budgets = await getBudgets();
    res.json(budgets);
  } catch (error) {
    console.error('Error obteniendo presupuestos:', error);
    res.status(500).json({ error: 'Error obteniendo presupuestos' });
  }
});

app.put('/api/budgets', async (req, res) => {
  try {
    await saveBudgets(req.body);
    res.json(req.body);
  } catch (error) {
    console.error('Error actualizando presupuestos:', error);
    res.status(500).json({ error: 'Error actualizando presupuestos' });
  }
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
  console.log(`\n🚀 Servidor corriendo en http://localhost:${PORT}`);
  console.log(`   Firebase: ${db ? '✅ Conectado' : '⚠️  Modo memoria'}\n`);
});
