// ========================================================
// Dashboard Page - Visão Geral do Sistema
// ========================================================
import { useEffect, useState } from 'react';
import { BarChart3, Package, Pill, Heart, TrendingUp, AlertCircle } from 'lucide-react';
import { useAuth } from '../hooks/useAuth';
import api from '../services/api';

export default function DashboardPage() {
  const { usuario } = useAuth();
  const [stats, setStats] = useState({
    dispensacoes: 0,
    movimentos: 0,
    saldo: 0,
    alertas: 0
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    loadStats();
  }, []);

  const loadStats = async () => {
    try {
      setLoading(true);
      setError('');

      // Carrega dados dos módulos (simplificado)
      const [dispensacoes, movimentos] = await Promise.all([
        api.get('/farmacia/dispensacoes?limit=1000').catch(() => ({ data: { data: [] } })),
        api.get('/estoque/movimentos?limit=1000').catch(() => ({ data: { data: [] } }))
      ]);

      setStats({
        dispensacoes: dispensacoes.data.data.length,
        movimentos: movimentos.data.data.length,
        saldo: 0, // Será calculado
        alertas: 0
      });
    } catch (err) {
      console.error('Erro ao carregar stats:', err);
      setError('Erro ao carregar dados do dashboard');
    } finally {
      setLoading(false);
    }
  };

  const StatCard = ({ icon: Icon, title, value, color }) => (
    <div className={`bg-white rounded-lg shadow-sm p-6 border-l-4 ${color}`}>
      <div className="flex items-center justify-between">
        <div>
          <p className="text-gray-600 text-sm font-medium">{title}</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">{value}</p>
        </div>
        <Icon className="w-12 h-12 text-gray-300" />
      </div>
    </div>
  );

  return (
    <div className="p-6 max-w-7xl mx-auto">
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
        <p className="text-gray-600 mt-1">
          Bem-vindo de volta, <span className="font-semibold">{usuario?.nome}</span>!
        </p>
      </div>

      {/* Error Alert */}
      {error && (
        <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg flex items-start gap-3">
          <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
          <p className="text-red-700">{error}</p>
        </div>
      )}

      {/* Loading State */}
      {loading ? (
        <div className="text-center py-12">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Carregando dados...</p>
        </div>
      ) : (
        <>
          {/* Stats Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <StatCard
              icon={Pill}
              title="Dispensações"
              value={stats.dispensacoes}
              color="border-blue-500"
            />
            <StatCard
              icon={Package}
              title="Movimentos"
              value={stats.movimentos}
              color="border-green-500"
            />
            <StatCard
              icon={Heart}
              title="Atendimentos"
              value="0"
              color="border-purple-500"
            />
            <StatCard
              icon={AlertCircle}
              title="Alertas"
              value={stats.alertas}
              color="border-red-500"
            />
          </div>

          {/* Charts Grid */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Activity Chart */}
            <div className="bg-white rounded-lg shadow-sm p-6">
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-lg font-semibold text-gray-900">Atividade Recente</h2>
                <BarChart3 className="w-5 h-5 text-gray-400" />
              </div>
              <div className="text-center py-8 text-gray-500">
                Gráfico de atividade será exibido aqui
              </div>
            </div>

            {/* Quick Actions */}
            <div className="bg-white rounded-lg shadow-sm p-6">
              <h2 className="text-lg font-semibold text-gray-900 mb-6">Ações Rápidas</h2>
              <div className="space-y-3">
                <a
                  href="/farmacia"
                  className="block w-full px-4 py-3 text-left rounded-lg border border-gray-200 hover:bg-gray-50 transition-colors"
                >
                  <p className="font-medium text-gray-900">Registrar Dispensação</p>
                  <p className="text-sm text-gray-500">Ir para farmácia</p>
                </a>
                <a
                  href="/estoque"
                  className="block w-full px-4 py-3 text-left rounded-lg border border-gray-200 hover:bg-gray-50 transition-colors"
                >
                  <p className="font-medium text-gray-900">Consultar Estoque</p>
                  <p className="text-sm text-gray-500">Ir para estoque</p>
                </a>
                <a
                  href="/atendimento"
                  className="block w-full px-4 py-3 text-left rounded-lg border border-gray-200 hover:bg-gray-50 transition-colors"
                >
                  <p className="font-medium text-gray-900">Novo Atendimento</p>
                  <p className="text-sm text-gray-500">Ir para atendimento</p>
                </a>
              </div>
            </div>
          </div>
        </>
      )}
    </div>
  );
}
