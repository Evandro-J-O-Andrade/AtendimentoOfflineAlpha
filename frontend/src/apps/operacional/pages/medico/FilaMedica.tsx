import React, { useEffect, useState } from 'react';
import DashboardBase from '@/pages/dashboard/DashboardBase';
import { useRuntime } from '@/app/providers/RuntimeContext';
import { runtimeService } from '@/services/runtime.service';
import ProntuarioClinico from './ProntuarioClinico';
import api from '@/services/api';
import { 
  Users, 
  Play, 
  Clock, 
  ChevronRight, 
  AlertCircle,
  CheckCircle2,
  UserPlus,
  Activity
} from 'lucide-react';

interface FilaItem {
  id_fila: number;
  id_ffa: number;
  paciente_nome: string;
  senha_codigo: string;
  prioridade: string;
  tempo_espera: number;
  status: 'AGUARDANDO' | 'CHAMANDO' | 'EM_ATENDIMENTO';
}

/**
 * FilaMedica - New Wave Enterprise
 * Gerenciamento de fluxo clínico baseado no Semantic Dispatcher.
 * Segue LEI CANÔNICA 3: UI Premium, TypeScript e Contexto de Operação.
 */
const FilaMedica: React.FC = () => {
  const { runtime } = useRuntime();
  const [fila, setFila] = useState<FilaItem[]>([]);
  const [loading, setLoading] = useState(false);
  const [atendimentoAtivo, setAtendimentoAtivo] = useState<FilaItem | null>(null);

  // Carrega a fila com base no Local Operacional (Consultório/Sala)
  const carregarFila = async () => {
    setLoading(true);
    try {
      // Query baseada no item 2.3 do MAPA_FRONTEND_TABELAS_CAMPOS.md
      const response = await api.get(`/operacional/fila?id_local_operacional=${runtime.id_local_operacional}`);
      setFila(response.data || []);
    } catch (err) {
      console.error("Erro ao carregar fila médica:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (runtime.id_local_operacional) {
      carregarFila();
    }
  }, [runtime.id_local_operacional]);

  // Dispara ação de chamada via Dispatcher Central (sp_master_senha_chamar)
  const handleChamarPaciente = async (item?: FilaItem) => {
    try {
      setLoading(true);
      
      // Se item for nulo, o Dispatcher chama o próximo por prioridade (lógica da SP)
      const payload = item ? { id_fila: item.id_fila, id_ffa: item.id_ffa } : {};

      await runtimeService.dispatch('SENHA_CHAMAR', payload, runtime);
      
      // Feedback sonoro/visual integrado ao ecossistema
      carregarFila();
    } catch (err) {
      console.error("Erro no dispatch de chamada:", err);
      alert("Erro ao processar chamada no Ledger.");
    } finally {
      setLoading(false);
    }
  };

  const getPriorityColor = (cor: string) => {
    const c = cor?.toUpperCase();
    if (c === 'VERMELHO') return 'bg-rose-500';
    if (c === 'LARANJA') return 'bg-orange-500';
    if (c === 'AMARELO') return 'bg-amber-400';
    if (c === 'VERDE') return 'bg-emerald-500';
    return 'bg-slate-400';
  };

  return (
    <DashboardBase appName="Painel de Fila Médica">
      <div className="max-w-6xl mx-auto space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-700">
        
        {/* Top Header Section */}
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <h1 className="text-3xl font-black text-slate-900 tracking-tight">Fila de Atendimento</h1>
            <p className="text-slate-500 font-medium italic">Gerenciamento dinâmico de prioridades e fluxo clínico.</p>
          </div>
          <button 
            onClick={() => handleChamarPaciente()}
            disabled={loading}
            className="flex items-center gap-2 bg-indigo-600 hover:bg-indigo-700 text-white px-8 py-4 rounded-2xl font-bold shadow-xl shadow-indigo-200 transition-all transform active:scale-95 disabled:opacity-50"
          >
            <UserPlus size={20} />
            Chamar Próximo
          </button>
        </div>

        {/* Quick Stats Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
          <div className="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-4 group hover:border-indigo-100 transition-colors">
            <div className="p-3 bg-amber-50 text-amber-600 rounded-xl group-hover:bg-amber-100 transition-colors"><Clock size={24} /></div>
            <div>
              <p className="text-[10px] font-black text-slate-400 uppercase tracking-widest">Em Espera</p>
              <h4 className="text-2xl font-black text-slate-900">{fila.filter(f => f.status === 'AGUARDANDO').length}</h4>
            </div>
          </div>
          <div className="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-4 group hover:border-indigo-100 transition-colors">
            <div className="p-3 bg-indigo-50 text-indigo-600 rounded-xl group-hover:bg-indigo-100 transition-colors"><Activity size={24} /></div>
            <div>
              <p className="text-[10px] font-black text-slate-400 uppercase tracking-widest">Chamando</p>
              <h4 className="text-2xl font-black text-slate-900">{fila.filter(f => f.status === 'CHAMANDO').length}</h4>
            </div>
          </div>
          <div className="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-4 group hover:border-indigo-100 transition-colors">
            <div className="p-3 bg-emerald-50 text-emerald-600 rounded-xl group-hover:bg-emerald-100 transition-colors"><CheckCircle2 size={24} /></div>
            <div>
              <p className="text-[10px] font-black text-slate-400 uppercase tracking-widest">Concluídos</p>
              <h4 className="text-2xl font-black text-slate-900">0</h4>
            </div>
          </div>
        </div>

        {/* Main Queue Table */}
        <div className="bg-white rounded-[2.5rem] border border-slate-100 shadow-sm overflow-hidden">
          <div className="p-8 border-b border-slate-50 flex items-center justify-between">
            <h3 className="font-bold text-lg text-slate-800 flex items-center gap-2">
              <Users size={20} className="text-indigo-500" />
              Lista de Pacientes
            </h3>
            <button onClick={carregarFila} className="text-xs text-indigo-600 font-bold hover:underline">Recarregar Fila</button>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead className="bg-slate-50/50">
                <tr>
                  <th className="p-5 px-8 text-[10px] font-black uppercase text-slate-400 tracking-widest">Risco</th>
                  <th className="p-5 text-[10px] font-black uppercase text-slate-400 tracking-widest">Identificador</th>
                  <th className="p-5 text-[10px] font-black uppercase text-slate-400 tracking-widest">Paciente</th>
                  <th className="p-5 text-[10px] font-black uppercase text-slate-400 tracking-widest">Tempo</th>
                  <th className="p-5 text-right px-8 text-[10px] font-black uppercase text-slate-400 tracking-widest">Ações</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-50">
                {fila.length === 0 ? (
                  <tr>
                    <td colSpan={5} className="p-20 text-center text-slate-300">
                      <div className="flex flex-col items-center gap-4 opacity-30">
                        <Users size={48} />
                        <span className="font-bold tracking-tight">Fila vazia no momento</span>
                      </div>
                    </td>
                  </tr>
                ) : (
                  fila.map((item) => (
                    <tr key={item.id_fila} className="hover:bg-indigo-50/30 transition-colors group">
                      <td className="p-5 px-8">
                        <div className={`w-3 h-3 rounded-full ${getPriorityColor(item.prioridade)} shadow-lg shadow-black/10`} />
                      </td>
                      <td className="p-5">
                        <span className="font-black text-slate-900 bg-slate-100 px-3 py-1 rounded-xl text-xs tracking-tighter">
                          {item.senha_codigo}
                        </span>
                      </td>
                      <td className="p-5">
                        <div className="flex flex-col leading-tight">
                          <span className="font-bold text-slate-900 group-hover:text-indigo-600 transition-colors">{item.paciente_nome}</span>
                          <span className="text-[10px] text-slate-400 font-bold uppercase">{item.prioridade}</span>
                        </div>
                      </td>
                      <td className="p-5">
                        <div className="flex items-center gap-1.5 text-slate-500 font-semibold text-sm">
                          <Clock size={14} className="opacity-50" />
                          {item.tempo_espera} min
                        </div>
                      </td>
                      <td className="p-5 px-8 text-right">
                        <button 
                          onClick={() => {
                            handleChamarPaciente(item);
                            setAtendimentoAtivo(item);
                          }}
                          className="p-3 bg-white border border-slate-100 rounded-2xl text-indigo-600 shadow-sm hover:shadow-xl hover:-translate-y-1 transition-all active:scale-95"
                          title="Chamar e Atender"
                        >
                          <Play size={18} fill="currentColor" />
                        </button>
                        <button 
                          className="p-3 text-slate-300 hover:text-indigo-600 transition-colors ml-2"
                        >
                          <ChevronRight size={20} />
                        </button>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>

      {/* Modal de Prontuário Clínico Integrado */}
      {atendimentoAtivo && (
        <ProntuarioClinico 
          atendimento={atendimentoAtivo} 
          onClose={() => setAtendimentoAtivo(null)}
          onSuccess={() => {
            setAtendimentoAtivo(null);
            carregarFila();
          }}
        />
      )}
    </DashboardBase>
  );
};

export default FilaMedica;