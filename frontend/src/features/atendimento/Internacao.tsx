import React from 'react';
import DynamicSidebar from '@/components/layout/DynamicSidebar';
import { useAuth } from '@/app/providers/AuthProvider';

/**
 * Internacao - Página de teste
 */
const Internacao: React.FC = () => {
  const { session } = useAuth();
  
  return (
    <div className="min-h-screen bg-slate-50">
      <DynamicSidebar session={session} />
      <div className="ml-64 p-8">
        <h1 className="text-3xl font-black text-slate-900">🛏️ Internação</h1>
        <p className="text-slate-600 mt-2">Módulo de internação</p>
        <div className="mt-6 p-6 bg-white rounded-xl border">
          <p className="text-slate-800">Página de teste - Internação</p>
        </div>
      </div>
    </div>
  );
};

export default Internacao;