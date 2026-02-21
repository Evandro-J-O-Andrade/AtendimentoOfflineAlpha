// ========================================================
// Estoque Page - Gestão de Movimentos e Lotes
// ========================================================
import { useState, useEffect } from 'react';
import { Package, Plus, AlertCircle } from 'lucide-react';
import api from '../services/api';

export default function EstoquePage() {
  const [lotes, setLotes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    loadLotes();
  }, []);

  const loadLotes = async () => {
    try {
      setLoading(true);
      setError('');
      const response = await api.get('/estoque/saldo');
      setLotes(response.data.data || []);
    } catch (err) {
      console.error('Erro ao carregar lotes:', err);
      setError('Erro ao carregar lotes');
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
            <Package className="w-8 h-8 text-green-600" />
            Estoque
          </h1>
          <p className="text-gray-600 mt-1">Gestão de lotes e movimentos</p>
        </div>
        <button className="btn-primary">
          <Plus className="w-5 h-5" />
          Novo Movimento
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
            <p className="text-gray-600">Carregando lotes...</p>
          </div>
        </div>
      ) : (
        <div className="bg-white rounded-lg shadow-sm border border-gray-200">
          {lotes.length === 0 ? (
            <div className="p-8 text-center">
              <Package className="w-12 h-12 text-gray-300 mx-auto mb-3" />
              <p className="text-gray-600">Nenhum lote disponível</p>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="table-base w-full">
                <thead>
                  <tr>
                    <th>ID Lote</th>
                    <th>Produto</th>
                    <th>Quantidade</th>
                    <th>Validade</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  {lotes.map((lote) => (
                    <tr key={lote.id}>
                      <td className="font-medium">#{lote.id}</td>
                      <td>{lote.produto_nome || '-'}</td>
                      <td>{lote.quantidade}</td>
                      <td>{lote.data_validade ? new Date(lote.data_validade).toLocaleDateString('pt-BR') : '-'}</td>
                      <td>
                        <span className="badge badge-success">Ativo</span>
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
