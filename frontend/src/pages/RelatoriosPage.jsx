// ========================================================
// Relatórios Page
// ========================================================
import { BarChart3 } from 'lucide-react';

export default function RelatoriosPage() {
  return (
    <div className="p-6 max-w-7xl mx-auto">
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-gray-900 flex items-center gap-3">
          <BarChart3 className="w-8 h-8 text-indigo-600" />
          Relatórios
        </h1>
        <p className="text-gray-600 mt-1">Análise e visualização de dados</p>
      </div>

      <div className="bg-white rounded-lg shadow-sm p-8 text-center">
        <BarChart3 className="w-12 h-12 text-gray-300 mx-auto mb-3" />
        <p className="text-gray-600">Módulo de Relatórios em desenvolvimento</p>
      </div>
    </div>
  );
}
