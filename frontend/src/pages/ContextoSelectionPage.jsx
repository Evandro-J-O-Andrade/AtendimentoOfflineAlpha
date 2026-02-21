// ========================================================
// Contexto Selection Page - Escolher Unidade e Sala
// ========================================================
import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import { Building2, MapPin, ChevronRight, AlertCircle, Loader } from 'lucide-react';
import { contextService } from '../services/contextService';

export default function ContextoSelectionPage() {
  const navigate = useNavigate();
  const { usuario, selecionarContexto } = useAuth();

  const [unidades, setUnidades] = useState([]);
  const [locaisDisponiveis, setLocaisDisponiveis] = useState([]);
  const [selectedUnidade, setSelectedUnidade] = useState(null);
  const [selectedLocal, setSelectedLocal] = useState(null);
  const [loading, setLoading] = useState(true);
  const [selecionando, setSelecionando] = useState(false);
  const [error, setError] = useState('');

  // Carrega unidades ao montar
  useEffect(() => {
    loadUnidades();
  }, []);

  // Carrega locais quando unidade é selecionada
  useEffect(() => {
    if (selectedUnidade) {
      loadLocais(selectedUnidade.id_unidade);
    } else {
      setLocaisDisponiveis([]);
      setSelectedLocal(null);
    }
  }, [selectedUnidade]);

  const loadUnidades = async () => {
    try {
      setLoading(true);
      setError('');
      const result = await contextService.getUnidades();
      if (result.success) {
        setUnidades(result.unidades);
      } else {
        setError(result.message);
      }
    } catch (err) {
      console.error('Erro ao carregar unidades:', err);
      setError('Erro ao carregar unidades');
    } finally {
      setLoading(false);
    }
  };

  const loadLocais = async (idUnidade) => {
    try {
      setLoading(true);
      setError('');
      const result = await contextService.getLocaisPorUnidade(idUnidade);
      if (result.success) {
        setLocaisDisponiveis(result.locais);
      } else {
        setError(result.message);
      }
    } catch (err) {
      console.error('Erro ao carregar locais:', err);
      setError('Erro ao carregar locais');
    } finally {
      setLoading(false);
    }
  };

  const handleConfirm = async () => {
    if (!selectedUnidade || !selectedLocal) {
      setError('Por favor, selecione unidade e sala');
      return;
    }

    try {
      setSelecionando(true);
      setError('');

      await selecionarContexto(
        selectedUnidade.id_unidade,
        selectedLocal.id_local_operacional
      );

      // Redireciona para dashboard
      navigate('/dashboard');
    } catch (err) {
      console.error('Erro ao confirmar contexto:', err);
      setError(err.response?.data?.error || 'Erro ao confirmar contexto');
    } finally {
      setSelecionando(false);
    }
  };

  const getTipoLabel = (tipo) => {
    const labels = {
      UPA: 'Unidade de Pronto Atendimento',
      HOSPITAL: 'Hospital',
      PA: 'Pronto Atendimento',
      CLINICA: 'Clínica'
    };
    return labels[tipo] || tipo;
  };

  const getLocalLabel = (tipo) => {
    const labels = {
      RECEPCAO: 'Recepção',
      TRIAGEM: 'Triagem',
      MEDICO_CLINICO: 'Clínico',
      MEDICO_PEDIATRICO: 'Pediatria',
      MEDICACAO: 'Medicação',
      RX: 'Raio-X',
      LABORATORIO: 'Laboratório',
      ECG: 'ECG',
      OBSERVACAO: 'Observação',
      INTERNACAO: 'Internação',
      FARMACIA: 'Farmácia',
      TI: 'TI',
      MANUTENCAO: 'Manutenção',
      ADMIN: 'Admin'
    };
    return labels[tipo] || tipo;
  };

  if (loading && unidades.length === 0) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-600 to-blue-800 flex items-center justify-center">
        <div className="text-center text-white">
          <Loader className="w-12 h-12 animate-spin mx-auto mb-4" />
          <p>Carregando unidades...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-600 to-blue-800 py-8 px-4">
      <div className="max-w-4xl mx-auto">
        {/* Header */}
        <div className="text-center mb-8 text-white">
          <h1 className="text-4xl font-bold mb-2">Selecione sua Unidade e Sala</h1>
          <p className="text-blue-100">
            Bem-vindo, <span className="font-semibold">{usuario?.nome}</span>!
          </p>
        </div>

        {/* Error Alert */}
        {error && (
          <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg flex items-start gap-3 max-w-2xl mx-auto">
            <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
            <p className="text-red-700">{error}</p>
          </div>
        )}

        {/* Main Container */}
        <div className="bg-white rounded-lg shadow-2xl overflow-hidden">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-0">
            {/* Unidades */}
            <div className="p-6 border-r border-gray-200 md:border-r-1">
              <div className="flex items-center gap-2 mb-6">
                <Building2 className="w-6 h-6 text-blue-600" />
                <h2 className="text-xl font-bold text-gray-900">Unidades</h2>
              </div>

              {unidades.length === 0 ? (
                <p className="text-gray-500 text-center py-8">Nenhuma unidade disponível</p>
              ) : (
                <div className="space-y-2">
                  {unidades.map((unidade) => (
                    <button
                      key={unidade.id_unidade}
                      onClick={() => setSelectedUnidade(unidade)}
                      className={`w-full text-left p-4 rounded-lg border-2 transition-all ${
                        selectedUnidade?.id_unidade === unidade.id_unidade
                          ? 'border-blue-600 bg-blue-50'
                          : 'border-gray-200 hover:border-gray-300 bg-gray-50'
                      }`}
                    >
                      <div className="font-semibold text-gray-900">{unidade.nome}</div>
                      <div className="text-sm text-gray-600 mt-1">
                        {getTipoLabel(unidade.tipo)}
                      </div>
                      {unidade.cnes && (
                        <div className="text-xs text-gray-500 mt-1">CNES: {unidade.cnes}</div>
                      )}
                      {selectedUnidade?.id_unidade === unidade.id_unidade && (
                        <ChevronRight className="w-5 h-5 text-blue-600 absolute right-4 top-1/4" />
                      )}
                    </button>
                  ))}
                </div>
              )}
            </div>

            {/* Locais/Salas */}
            <div className="p-6">
              <div className="flex items-center gap-2 mb-6">
                <MapPin className="w-6 h-6 text-green-600" />
                <h2 className="text-xl font-bold text-gray-900">Salas/Locais</h2>
              </div>

              {!selectedUnidade ? (
                <p className="text-gray-500 text-center py-8">Selecione uma unidade</p>
              ) : loading ? (
                <div className="flex items-center justify-center py-8">
                  <Loader className="w-6 h-6 animate-spin text-blue-600" />
                </div>
              ) : locaisDisponiveis.length === 0 ? (
                <p className="text-gray-500 text-center py-8">Nenhuma sala disponível</p>
              ) : (
                <div className="space-y-2">
                  {locaisDisponiveis.map((local) => (
                    <button
                      key={local.id_local_operacional}
                      onClick={() => setSelectedLocal(local)}
                      className={`w-full text-left p-4 rounded-lg border-2 transition-all ${
                        selectedLocal?.id_local_operacional === local.id_local_operacional
                          ? 'border-green-600 bg-green-50'
                          : 'border-gray-200 hover:border-gray-300 bg-gray-50'
                      }`}
                    >
                      <div className="font-semibold text-gray-900">{local.nome}</div>
                      <div className="text-sm text-gray-600 mt-1">
                        {getLocalLabel(local.tipo)}
                      </div>
                      {local.sala && (
                        <div className="text-xs text-gray-500 mt-1">Sala: {local.sala}</div>
                      )}
                    </button>
                  ))}
                </div>
              )}
            </div>
          </div>

          {/* Footer - Action Button */}
          <div className="bg-gray-50 px-6 py-4 border-t border-gray-200 flex justify-between gap-3">
            <button
              onClick={() => {
                localStorage.removeItem('accessToken');
                localStorage.removeItem('refreshToken');
                localStorage.removeItem('usuario');
                navigate('/login', { replace: true });
              }}
              className="btn-secondary"
            >
              Voltar ao Login
            </button>

            <button
              onClick={handleConfirm}
              disabled={!selectedUnidade || !selectedLocal || selecionando}
              className={`btn-primary px-8 ${
                (!selectedUnidade || !selectedLocal) && 'opacity-50 cursor-not-allowed'
              }`}
            >
              {selecionando ? (
                <>
                  <Loader className="w-5 h-5 animate-spin" />
                  Confirmando...
                </>
              ) : (
                <>
                  <ChevronRight className="w-5 h-5" />
                  Confirmar e Acessar
                </>
              )}
            </button>
          </div>
        </div>

        {/* Summary */}
        {selectedUnidade && selectedLocal && (
          <div className="mt-6 p-4 bg-blue-50 border border-blue-200 rounded-lg text-center text-blue-900">
            <p className="text-sm">
              Você vai acessar <span className="font-semibold">{selectedLocal.nome}</span> da unidade{' '}
              <span className="font-semibold">{selectedUnidade.nome}</span>
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
