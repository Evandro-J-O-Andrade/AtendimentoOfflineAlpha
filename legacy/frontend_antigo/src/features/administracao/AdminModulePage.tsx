import React from 'react';

/**
 * AdminModulePage - Página de teste
 */
const AdminModulePage: React.FC = () => {
  return (
    <div className="min-h-screen bg-slate-50">
      <div className="p-8">
        <h1 className="text-3xl font-black text-slate-900">⚙️ Admin - Módulo</h1>
        <p className="text-slate-600 mt-2">Detalhe do módulo administrativo</p>
        <div className="mt-6 p-6 bg-white rounded-xl border">
          <p className="text-slate-800">Página de teste - Admin Módulo</p>
        </div>
      </div>
    </div>
  );
};

export default AdminModulePage;