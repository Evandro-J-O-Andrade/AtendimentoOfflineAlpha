// ========================================================
// Usuários Page - Admin
// ========================================================
import { Users, Plus } from 'lucide-react';

export default function UsuariosPage() {
  return (
    <div className="p-6 max-w-7xl mx-auto">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 flex items-center gap-3">
            <Users className="w-8 h-8 text-gray-600" />
            Usuários
          </h1>
          <p className="text-gray-600 mt-1">Gestão de usuários do sistema</p>
        </div>
        <button className="btn-primary">
          <Plus className="w-5 h-5" />
          Novo Usuário
        </button>
      </div>

      <div className="bg-white rounded-lg shadow-sm p-8 text-center">
        <Users className="w-12 h-12 text-gray-300 mx-auto mb-3" />
        <p className="text-gray-600">módulo de Gestão de Usuários em desenvolvimento</p>
      </div>
    </div>
  );
}
