// ========================================================
// Configurações Page - Admin
// ========================================================
import { Settings } from 'lucide-react';

export default function ConfiguracoesPage() {
  return (
    <div className="p-6 max-w-7xl mx-auto">
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-gray-900 flex items-center gap-3">
          <Settings className="w-8 h-8 text-gray-600" />
          Configurações
        </h1>
        <p className="text-gray-600 mt-1">Configurações gerais do sistema</p>
      </div>

      <div className="bg-white rounded-lg shadow-sm p-8 text-center">
        <Settings className="w-12 h-12 text-gray-300 mx-auto mb-3" />
        <p className="text-gray-600">Módulo de Configurações em desenvolvimento</p>
      </div>
    </div>
  );
}
