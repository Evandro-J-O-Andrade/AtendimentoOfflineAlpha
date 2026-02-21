// ========================================================
// Auditoria Page - Admin
// ========================================================
import { Lock } from 'lucide-react';

export default function AuditoriaPage() {
  return (
    <div className="p-6 max-w-7xl mx-auto">
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-gray-900 flex items-center gap-3">
          <Lock className="w-8 h-8 text-gray-600" />
          Auditoria
        </h1>
        <p className="text-gray-600 mt-1">Logs e rastreamento de operações</p>
      </div>

      <div className="bg-white rounded-lg shadow-sm p-8 text-center">
        <Lock className="w-12 h-12 text-gray-300 mx-auto mb-3" />
        <p className="text-gray-600">Módulo de Auditoria em desenvolvimento</p>
      </div>
    </div>
  );
}
