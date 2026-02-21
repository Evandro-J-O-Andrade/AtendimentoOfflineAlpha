// ========================================================
// Faturamento Page
// ========================================================
import { Plus, FileText } from 'lucide-react';

export default function FaturamentoPage() {
  return (
    <div className="p-6 max-w-7xl mx-auto">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 flex items-center gap-3">
            <FileText className="w-8 h-8 text-purple-600" />
            Faturamento
          </h1>
          <p className="text-gray-600 mt-1">Gestão de faturamentos e valores</p>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow-sm p-8 text-center">
        <FileText className="w-12 h-12 text-gray-300 mx-auto mb-3" />
        <p className="text-gray-600">Módulo de Faturamento em desenvolvimento</p>
      </div>
    </div>
  );
}
