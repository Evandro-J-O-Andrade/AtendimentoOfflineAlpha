import React from 'react';
import DashboardBase from '@/pages/dashboard/DashboardBase';
import { 
  TrendingUp, 
  TrendingDown, 
  DollarSign, 
  Wallet, 
  CreditCard, 
  Activity 
} from 'lucide-react';

/**
 * Dashboard - New Wave Enterprise
 * Refatorado para utilizar DashboardBase com foco em indicadores financeiros.
 * Segue LEI CANÔNICA 3 e padrões visuais de SaaS Enterprise (Microsoft 365 / ClickUp style).
 */
const Dashboard: React.FC = () => {
  // Mock de Indicadores Financeiros (BI Analytics)
  const financialWidgets = [
    { 
      label: 'Faturamento Total', 
      value: 'R$ 248.590,00', 
      change: '+12.5%', 
      trend: 'up', 
      icon: DollarSign,
      bgColor: 'bg-indigo-50',
      textColor: 'text-indigo-600'
    },
    { 
      label: 'Contas a Receber', 
      value: 'R$ 42.150,00', 
      change: '+5.2%', 
      trend: 'up', 
      icon: Wallet,
      bgColor: 'bg-emerald-50',
      textColor: 'text-emerald-600'
    },
    { 
      label: 'Despesas Operacionais', 
      value: 'R$ 84.200,00', 
      change: '-2.1%', 
      trend: 'down', 
      icon: CreditCard,
      bgColor: 'bg-rose-50', 
      textColor: 'text-rose-600'
    },
    { 
      label: 'EBITDA / Margem', 
      value: '34.5%', 
      change: '+1.8%', 
      trend: 'up', 
      icon: Activity,
      bgColor: 'bg-amber-50',
      textColor: 'text-amber-600'
    },
  ];

  return (
    <DashboardBase appName="Gestão & Business Intelligence">
      <div className="flex flex-col gap-8 animate-in fade-in slide-in-from-bottom-4 duration-700">
        {/* Header da Dashboard */}
        <div>
          <h1 className="text-3xl font-black text-slate-900 tracking-tight">Painel de Performance</h1>
          <p className="text-slate-500 font-medium">Indicadores financeiros e analíticos consolidados.</p>
        </div>

        {/* Grid de Widgets de Indicadores Financeiros */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {financialWidgets.map((stat, idx) => (
            <div key={idx} className="bg-white p-6 rounded-[2rem] border border-slate-100 shadow-sm hover:shadow-xl hover:-translate-y-1 transition-all duration-300">
              <div className="flex items-center justify-between mb-6">
                <div className={`p-3 rounded-2xl ${stat.bgColor} ${stat.textColor}`}>
                  <stat.icon size={24} />
                </div>
                <span className={`text-xs font-black px-2 py-1 rounded-lg flex items-center gap-1 ${
                  stat.trend === 'up' ? 'bg-emerald-50 text-emerald-600' : 'bg-rose-50 text-rose-600'
                }`}>
                  {stat.trend === 'up' ? <TrendingUp size={14} /> : <TrendingDown size={14} />}
                  {stat.change}
                </span>
              </div>
              <div>
                <p className="text-xs font-black text-slate-400 uppercase tracking-widest mb-1">{stat.label}</p>
                <h3 className="text-2xl font-black text-slate-900 tracking-tighter">{stat.value}</h3>
              </div>
            </div>
          ))}
        </div>

        {/* Placeholder para Gráficos Analíticos */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2 bg-white/40 backdrop-blur-md border border-white/20 p-8 rounded-[2.5rem] h-[400px] flex items-center justify-center text-slate-400 font-bold border-dashed border-2">
            [ Gráfico de Tendência de Faturamento ]
          </div>
          <div className="bg-white/40 backdrop-blur-md border border-white/20 p-8 rounded-[2.5rem] h-[400px] flex items-center justify-center text-slate-400 font-bold border-dashed border-2">
            [ Distribuição de Custos por Categoria ]
          </div>
        </div>
      </div>
    </DashboardBase>
  );
};

export default Dashboard;