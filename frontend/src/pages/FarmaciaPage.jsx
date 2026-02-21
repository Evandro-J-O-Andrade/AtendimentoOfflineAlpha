// ========================================================
// Farmácia Page - Gestão de Dispensações e Reservas
// ========================================================
import { useState, useEffect } from 'react';
import { Pill, Plus, AlertCircle } from 'lucide-react';
import api from '../services/api';

export default function FarmaciaPage() {
  const [dispensacoes, setDispensacoes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    loadDispensacoes();
  }, []);

  const loadDispensacoes = async () => {
    try {
      setLoading(true);
      setError('');
      const response = await api.get('/farmacia/dispensacoes');
      setDispensacoes(response.data.data || []);
    } catch (err) {
      console.error('Erro ao carregar dispensações:', err);
      setError('Erro ao carregar dispensações');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="p-6 max-w-7xl mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 flex items-center gap-3">
            <Pill className="w-8 h-8 text-blue-600" />
            Farmácia
          </h1>
          <p className="text-gray-600 mt-1">Gestão de dispensações e reservas</p>
        </div>
        <button className="btn-primary">
          <Plus className="w-5 h-5" />
          Nova Dispensação
        </button>
      </div>

      {/* Error Alert */}
      {error && (
        <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg flex items-start gap-3">
          <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
          <p className="text-red-700">{error}</p>
        </div>
      )}

      {/* Content */}
      {loading ? (
        <div className="flex items-center justify-center py-12">
          <div className="text-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
            <p className="text-gray-600">Carregando dispensações...</p>
          </div>
        </div>
      ) : (
        <div className="bg-white rounded-lg shadow-sm border border-gray-200">
          {dispensacoes.length === 0 ? (
            <div className="p-8 text-center">
              <Pill className="w-12 h-12 text-gray-300 mx-auto mb-3" />
              <p className="text-gray-600">Nenhuma dispensação registrada</p>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="table-base w-full">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Produto</th>
                    <th>Quantidade</th>
                    <th>Data</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  {dispensacoes.map((disp) => (
                    <tr key={disp.id}>
                      <td className="font-medium">#{disp.id}</td>
                      <td>{disp.produto_nome || '-'}</td>
                      <td>{disp.quantidade}</td>
                      <td>{new Date(disp.data_criacao).toLocaleDateString('pt-BR')}</td>
                      <td>
                        <span className="badge badge-success">Ativa</span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
