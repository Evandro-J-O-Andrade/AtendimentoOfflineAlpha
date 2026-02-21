// ========================================================
// Atendimento Page - Gestão de Atendimentos
// ========================================================
import { Plus, Heart } from 'lucide-react';

export default function AtendimentoPage() {
  return (
    <div className="p-6 max-w-7xl mx-auto">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 flex items-center gap-3">
            <Heart className="w-8 h-8 text-red-600" />
            Atendimento
          </h1>
          <p className="text-gray-600 mt-1">Gestão de atendimentos clínicos</p>
        </div>
        <button className="btn-primary">
          <Plus className="w-5 h-5" />
          Novo Atendimento
        </button>
      </div>

      <div className="bg-white rounded-lg shadow-sm p-8 text-center">
        <Heart className="w-12 h-12 text-gray-300 mx-auto mb-3" />
        <p className="text-gray-600">Módulo de Atendimento em desenvolvimento</p>
      </div>
    </div>
  );
}
