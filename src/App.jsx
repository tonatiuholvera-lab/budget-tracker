import { useState, useEffect, useMemo } from 'react';

const CATEGORIES = {
  housing: { label: 'Vivienda', icon: '🏠', color: '#E8D5B7' },
  food: { label: 'Alimentación', icon: '🛒', color: '#B7D5B4' },
  transport: { label: 'Transporte', icon: '🚌', color: '#B7C8D5' },
  childcare: { label: 'Hijo / Guardería', icon: '👶', color: '#D5B7D0' },
  pets: { label: 'Perros', icon: '🐕', color: '#D5CCB7' },
  health: { label: 'Salud', icon: '💊', color: '#D5B7B7' },
  leisure: { label: 'Ocio / Cultura', icon: '🎵', color: '#B7D5D3' },
  savings: { label: 'Ahorro', icon: '💰', color: '#C8D5B7' },
  other: { label: 'Otros', icon: '📦', color: '#D5D5B7' },
};

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3001';

function App() {
  const [view, setView] = useState('summary');
  const [transactions, setTransactions] = useState([]);
  const [budgets, setBudgets] = useState({
    housing: 2000,
    food: 800,
    transport: 200,
    childcare: 1200,
    pets: 150,
    health: 300,
    leisure: 200,
    savings: 500,
    other: 150,
  });
  const [editingBudget, setEditingBudget] = useState(null);
  const [newTransaction, setNewTransaction] = useState({
    amount: '',
    category: 'food',
    note: '',
  });
  const [loading, setLoading] = useState(true);
  const [syncing, setSyncing] = useState(false);

  // Cargar datos iniciales
  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    try {
      setLoading(true);
      const [txRes, budgetRes] = await Promise.all([
        fetch(`${API_URL}/api/transactions`),
        fetch(`${API_URL}/api/budgets`)
      ]);
      
      if (txRes.ok) {
        const txData = await txRes.json();
        setTransactions(txData);
      }
      
      if (budgetRes.ok) {
        const budgetData = await budgetRes.json();
        setBudgets(budgetData);
      }
    } catch (error) {
      console.error('Error cargando datos:', error);
    } finally {
      setLoading(false);
    }
  };

  // Sync en tiempo real usando polling (alternativa simple a Firebase SDK en cliente)
  useEffect(() => {
    const interval = setInterval(async () => {
      try {
        setSyncing(true);
        const res = await fetch(`${API_URL}/api/transactions`);
        if (res.ok) {
          const data = await res.json();
          setTransactions(data);
        }
      } catch (error) {
        console.error('Error sincronizando:', error);
      } finally {
        setSyncing(false);
      }
    }, 5000); // Sync cada 5 segundos

    return () => clearInterval(interval);
  }, []);

  const currentMonth = useMemo(() => {
    const now = new Date();
    return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
  }, []);

  const monthTransactions = useMemo(() => {
    return transactions.filter(tx => tx.date.startsWith(currentMonth));
  }, [transactions, currentMonth]);

  const categoryTotals = useMemo(() => {
    const totals = {};
    Object.keys(CATEGORIES).forEach(cat => {
      totals[cat] = monthTransactions
        .filter(tx => tx.category === cat)
        .reduce((sum, tx) => sum + tx.amount, 0);
    });
    return totals;
  }, [monthTransactions]);

  const totalSpent = useMemo(() => {
    return Object.values(categoryTotals).reduce((sum, val) => sum + val, 0);
  }, [categoryTotals]);

  const totalBudget = useMemo(() => {
    return Object.values(budgets).reduce((sum, val) => sum + val, 0);
  }, [budgets]);

  const addTransaction = async (e) => {
    e.preventDefault();
    const amount = parseFloat(newTransaction.amount);
    if (!amount || amount <= 0) return;

    const tx = {
      amount,
      category: newTransaction.category,
      note: newTransaction.note,
      date: new Date().toISOString().split('T')[0],
      timestamp: Date.now(),
    };

    try {
      const res = await fetch(`${API_URL}/api/transactions`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(tx)
      });

      if (res.ok) {
        const saved = await res.json();
        setTransactions(prev => [...prev, saved]);
        setNewTransaction({ amount: '', category: 'food', note: '' });
        setView('summary');
      }
    } catch (error) {
      console.error('Error guardando transacción:', error);
    }
  };

  const updateBudget = async (category, value) => {
    const newBudgets = { ...budgets, [category]: parseFloat(value) || 0 };
    setBudgets(newBudgets);
    
    try {
      await fetch(`${API_URL}/api/budgets`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(newBudgets)
      });
    } catch (error) {
      console.error('Error actualizando presupuesto:', error);
    }
  };

  const deleteTransaction = async (id) => {
    if (!window.confirm('¿Eliminar este gasto?')) return;
    
    try {
      const res = await fetch(`${API_URL}/api/transactions/${id}`, {
        method: 'DELETE'
      });
      
      if (res.ok) {
        setTransactions(prev => prev.filter(tx => tx.id !== id));
      }
    } catch (error) {
      console.error('Error eliminando transacción:', error);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-gray-900 mx-auto mb-4"></div>
          <p className="text-gray-600">Cargando...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-md mx-auto bg-white min-h-screen shadow-lg">
      {/* Header */}
      <div className="bg-gradient-to-r from-amber-100 to-orange-100 p-6 text-center relative">
        <h1 className="text-2xl font-bold text-gray-800">Budget Tracker</h1>
        <p className="text-sm text-gray-600 mt-1">
          {new Date().toLocaleDateString('es-ES', { month: 'long', year: 'numeric' })}
        </p>
        {syncing && (
          <div className="absolute top-2 right-2 text-xs text-gray-500 flex items-center gap-1">
            <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
            Sync
          </div>
        )}
      </div>

      {/* Navigation */}
      <div className="flex border-b border-gray-200">
        {[
          { id: 'summary', label: 'Resumen', icon: '📊' },
          { id: 'add', label: '+ Gasto', icon: '➕' },
          { id: 'tips', label: 'Consejos', icon: '💡' },
          { id: 'history', label: 'Historial', icon: '📜' },
        ].map(tab => (
          <button
            key={tab.id}
            onClick={() => setView(tab.id)}
            className={`flex-1 py-3 text-sm font-medium transition ${
              view === tab.id
                ? 'border-b-2 border-orange-500 text-orange-600'
                : 'text-gray-500 hover:text-gray-700'
            }`}
          >
            <span className="mr-1">{tab.icon}</span>
            {tab.label}
          </button>
        ))}
      </div>

      <div className="p-4">
        {/* Summary View */}
        {view === 'summary' && (
          <div className="space-y-4">
            {/* Progress Bar */}
            <div className="bg-gray-100 rounded-lg p-4">
              <div className="flex justify-between mb-2 text-sm">
                <span className="text-gray-600">Gastado</span>
                <span className="font-bold">
                  CHF {totalSpent.toFixed(2)} / {totalBudget.toFixed(2)}
                </span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-3 overflow-hidden">
                <div
                  className={`h-full rounded-full transition-all ${
                    (totalSpent / totalBudget) > 0.9 ? 'bg-red-500' :
                    (totalSpent / totalBudget) > 0.7 ? 'bg-yellow-500' :
                    'bg-green-500'
                  }`}
                  style={{ width: `${Math.min((totalSpent / totalBudget) * 100, 100)}%` }}
                ></div>
              </div>
              <p className="text-xs text-gray-500 mt-2 text-center">
                {totalBudget - totalSpent >= 0 
                  ? `Quedan CHF ${(totalBudget - totalSpent).toFixed(2)}`
                  : `Excedido por CHF ${(totalSpent - totalBudget).toFixed(2)}`
                }
              </p>
            </div>

            {/* Categories */}
            {Object.entries(CATEGORIES).map(([key, cat]) => {
              const spent = categoryTotals[key];
              const budget = budgets[key];
              const percentage = budget > 0 ? (spent / budget) * 100 : 0;
              const isOverBudget = spent > budget;

              return (
                <div
                  key={key}
                  className="border border-gray-200 rounded-lg p-3 hover:shadow-md transition"
                  style={{ borderLeftWidth: '4px', borderLeftColor: cat.color }}
                >
                  <div className="flex items-center justify-between mb-2">
                    <div className="flex items-center gap-2">
                      <span className="text-xl">{cat.icon}</span>
                      <span className="text-sm font-medium">{cat.label}</span>
                    </div>
                    <button
                      onClick={() => setEditingBudget(editingBudget === key ? null : key)}
                      className="text-xs text-blue-600 hover:underline"
                    >
                      {editingBudget === key ? 'Guardar' : 'Editar'}
                    </button>
                  </div>

                  {editingBudget === key ? (
                    <input
                      type="number"
                      value={budgets[key]}
                      onChange={(e) => updateBudget(key, e.target.value)}
                      onBlur={() => setEditingBudget(null)}
                      className="w-full px-2 py-1 border border-gray-300 rounded text-sm"
                      autoFocus
                    />
                  ) : (
                    <>
                      <div className="flex justify-between text-xs mb-1">
                        <span className={isOverBudget ? 'text-red-600 font-bold' : 'text-gray-600'}>
                          CHF {spent.toFixed(2)}
                        </span>
                        <span className="text-gray-500">/ CHF {budget.toFixed(2)}</span>
                      </div>
                      <div className="w-full bg-gray-200 rounded-full h-2 overflow-hidden">
                        <div
                          className={`h-full transition-all ${
                            isOverBudget ? 'bg-red-500' :
                            percentage > 70 ? 'bg-yellow-500' :
                            'bg-green-500'
                          }`}
                          style={{ width: `${Math.min(percentage, 100)}%` }}
                        ></div>
                      </div>
                    </>
                  )}
                </div>
              );
            })}
          </div>
        )}

        {/* Add Transaction View */}
        {view === 'add' && (
          <form onSubmit={addTransaction} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Monto (CHF)
              </label>
              <input
                type="number"
                step="0.01"
                value={newTransaction.amount}
                onChange={(e) => setNewTransaction(prev => ({ ...prev, amount: e.target.value }))}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                placeholder="0.00"
                required
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Categoría
              </label>
              <select
                value={newTransaction.category}
                onChange={(e) => setNewTransaction(prev => ({ ...prev, category: e.target.value }))}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent"
              >
                {Object.entries(CATEGORIES).map(([key, cat]) => (
                  <option key={key} value={key}>
                    {cat.icon} {cat.label}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Nota (opcional)
              </label>
              <input
                type="text"
                value={newTransaction.note}
                onChange={(e) => setNewTransaction(prev => ({ ...prev, note: e.target.value }))}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                placeholder="Ej: Migros, gasolina..."
              />
            </div>

            <button
              type="submit"
              className="w-full bg-orange-500 text-white py-3 rounded-lg font-medium hover:bg-orange-600 transition"
            >
              Guardar Gasto
            </button>
          </form>
        )}

        {/* Tips View */}
        {view === 'tips' && (
          <div className="space-y-3">
            {[
              { title: 'Supermercados', tip: 'Aldi y Lidl son hasta 40% más baratos que Migros/Coop' },
              { title: 'Seguro médico', tip: 'Solicita Prämienverbilligung si ganas menos de 90k/año' },
              { title: 'Transporte', tip: 'GA Tageskarte para días puntuales (CHF 52 vs 130)' },
              { title: 'Compras online', tip: 'Usa comparis.ch antes de cualquier compra grande' },
              { title: 'Restaurantes', tip: 'Menu del día al mediodía ahorra 30-50%' },
              { title: 'Guardería', tip: 'Algunas comunas ofrecen subsidios según ingresos' },
            ].map((item, idx) => (
              <div key={idx} className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
                <h3 className="font-medium text-gray-800 mb-1">{item.title}</h3>
                <p className="text-sm text-gray-600">{item.tip}</p>
              </div>
            ))}
          </div>
        )}

        {/* History View */}
        {view === 'history' && (
          <div className="space-y-2">
            {monthTransactions.length === 0 ? (
              <div className="text-center py-12 text-gray-400">
                <p>Aún no hay gastos registrados.</p>
                <p className="text-sm mt-2">Empieza en "+ Gasto"</p>
              </div>
            ) : (
              monthTransactions
                .sort((a, b) => b.timestamp - a.timestamp)
                .map((tx) => (
                  <div
                    key={tx.id}
                    className="bg-white border border-gray-200 rounded-lg p-3 hover:shadow-md transition"
                  >
                    <div className="flex justify-between items-start">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-1">
                          <span className="text-lg">{CATEGORIES[tx.category]?.icon}</span>
                          <span className="text-sm font-medium">
                            {CATEGORIES[tx.category]?.label}
                          </span>
                        </div>
                        <div className="text-xs text-gray-500">
                          {new Date(tx.date).toLocaleDateString('es-ES')}
                          {tx.note && ` · ${tx.note}`}
                        </div>
                      </div>
                      <div className="flex items-center gap-3">
                        <span className="text-lg font-bold">CHF {tx.amount.toFixed(2)}</span>
                        <button
                          onClick={() => deleteTransaction(tx.id)}
                          className="text-red-500 hover:text-red-700 text-xs"
                        >
                          ✕
                        </button>
                      </div>
                    </div>
                  </div>
                ))
            )}
          </div>
        )}
      </div>
    </div>
  );
}

export default App;
