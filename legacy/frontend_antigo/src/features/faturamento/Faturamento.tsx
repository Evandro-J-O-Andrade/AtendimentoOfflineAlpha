import { FC } from 'react';
import { useNavigate } from 'react-router-dom';

/**
 * Faturamento - New Wave Enterprise
 * Setor de faturamento com painel de indicadores.
 * Segue LEI CANÔNICA 3: UI Premium, TypeScript.
 */
const Faturamento: FC = () => {
  const navigate = useNavigate();
  
  return (
    <div className="min-h-screen bg-slate-50">
      <div className="p-8">
        <header className="flex justify-between items-center mb-8">
          <h1 className="text-3xl font-black text-slate-900">💰 Faturamento</h1>
          <button 
            onClick={() => navigate('/operacional')} 
            className="flex items-center gap-2 text-slate-600 hover:text-slate-900 font-bold"
          >
            ← Voltar
          </button>
        </header>
        
        <div className="max-w-6xl mx-auto">
          <section className="bg-white p-8 rounded-2xl shadow-sm border border-slate-100">
            <h2 className="text-xl font-bold text-slate-800 mb-6">📊 Painel de Faturamento</h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="bg-gradient-to-br from-indigo-50 to-indigo-100 p-6 rounded-2xl">
                <h3 className="text-sm font-bold text-indigo-600 uppercase">Produção Hoje</h3>
                <p className="text-3xl font-black text-slate-900 mt-2">R$ 45.000</p>
              </div>
              <div className="bg-gradient-to-br from-amber-50 to-amber-100 p-6 rounded-2xl">
                <h3 className="text-sm font-bold text-amber-600 uppercase">Contas Pendentes</h3>
                <p className="text-3xl font-black text-slate-900 mt-2">12</p>
              </div>
              <div className="bg-gradient-to-br from-emerald-50 to-emerald-100 p-6 rounded-2xl">
                <h3 className="text-sm font-bold text-emerald-600 uppercase">Valor Pendente</h3>
                <p className="text-3xl font-black text-slate-900 mt-2">R$ 180.000</p>
              </div>
            </div>
          </section>
        </div>
      </div>
    </div>
  );
};

export default Faturamento;