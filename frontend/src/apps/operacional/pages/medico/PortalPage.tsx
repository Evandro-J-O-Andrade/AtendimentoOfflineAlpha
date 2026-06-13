import React from 'react';
import { useNavigate } from 'react-router-dom';

/**
 * Portal Corporativo - New Wave Enterprise
 * Grid de aplicações permitidas ao usuário.
 */
const PortalPage: React.FC = () => {
  const navigate = useNavigate();

  const apps = [
    { id: 'atendimento', name: 'Atendimento', desc: 'Fluxo operacional de assistência', icon: '🏥', type: 'OPERACIONAL', route: '/operacional/medico/fila' },
    { id: 'intranet', name: 'Intranet', desc: 'Comunicações internas e avisos', icon: '🏢', type: 'UNIVERSAL', route: '/corporativo/intranet' },
    { id: 'bi', name: 'BI & Analytics', desc: 'Painéis de inteligência e gestão', icon: '📊', type: 'OPERACIONAL', route: '/analytics/dashboards' },
    { id: 'rh', name: 'Recursos Humanos', desc: 'Gestão de pessoas e treinamentos', icon: '👥', type: 'UNIVERSAL', route: '/operacional/rh' },
  ];

  return (
    <div className="min-h-screen bg-slate-50 p-8 md:p-12">
      <header className="max-w-7xl mx-auto mb-12 flex justify-between items-end">
        <div>
          <p className="text-indigo-600 font-bold uppercase tracking-widest text-xs mb-2">Bem-vindo ao Portal</p>
          <h1 className="text-4xl font-black text-slate-900">Aplicações <span className="text-slate-400">Corporativas</span></h1>
        </div>
        <div className="text-right">
          <p className="font-bold text-slate-900">Tenant Exemplo</p>
          <p className="text-slate-500 text-sm">SaaS Enterprise Platform</p>
        </div>
      </header>

      <main className="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {apps.map(app => (
          <div 
            key={app.id}
            onClick={() => navigate(app.route)}
            className="group bg-white p-8 rounded-3xl border border-slate-100 shadow-sm hover:shadow-xl hover:border-indigo-100 transition-all cursor-pointer relative overflow-hidden"
          >
            <div className="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
               <span className="text-6xl grayscale group-hover:grayscale-0">{app.icon}</span>
            </div>
            
            <div className="w-12 h-12 bg-slate-50 rounded-2xl flex items-center justify-center text-2xl mb-6 group-hover:bg-indigo-600 group-hover:text-white transition-colors">
              {app.icon}
            </div>
            
            <h3 className="text-xl font-bold text-slate-900 mb-2">{app.name}</h3>
            <p className="text-slate-500 text-sm leading-relaxed mb-6">{app.desc}</p>
            
            <div className="flex items-center justify-between">
               <span className={`text-[10px] font-black px-2 py-1 rounded-md ${app.type === 'OPERACIONAL' ? 'bg-amber-100 text-amber-700' : 'bg-emerald-100 text-emerald-700'}`}>
                 {app.type}
               </span>
               <svg className="w-5 h-5 text-slate-300 group-hover:text-indigo-500 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                 <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
               </svg>
            </div>
          </div>
        ))}
      </main>
    </div>
  );
};

export default PortalPage;