import React from 'react';
import DynamicSidebar from '@/components/layout/DynamicSidebar';

interface DashboardBaseProps {
  appName: string;
  children: React.ReactNode;
}

/**
 * DashboardBase - New Wave Enterprise
 * Wrapper padrão para dashboards operacionais com Sidebar dinâmico.
 * Segue LEI CANÔNICA 3: UI Premium, TypeScript e Contexto de Operação.
 */
const DashboardBase: React.FC<DashboardBaseProps> = ({ appName, children }) => {
  return (
    <div className="min-h-screen bg-slate-50">
      <DynamicSidebar />
      
      <div className="ml-64 p-8 md:p-12">
        <header className="max-w-7xl mx-auto mb-8">
          <p className="text-indigo-600 font-bold uppercase tracking-widest text-xs mb-2">Aplicação Ativa</p>
          <h1 className="text-3xl font-black text-slate-900">{appName}</h1>
        </header>
        
        <main className="max-w-7xl mx-auto">
          {children}
        </main>
      </div>
    </div>
  );
};

export default DashboardBase;