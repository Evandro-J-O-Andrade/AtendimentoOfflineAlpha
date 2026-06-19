import React, { useState, useEffect } from 'react';
import { useRuntime } from '@/app/providers/RuntimeContext';
import { runtimeService } from '@/services/runtime.service';
import { 
  FileText, 
  Pill, 
  Save, 
  X, 
  Plus, 
  Trash2, 
  ClipboardCheck,
  Stethoscope
} from 'lucide-react';

interface ProntuarioProps {
  atendimento: any;
  onClose: () => void;
  onSuccess: () => void;
}

/**
 * ProntuarioClinico - New Wave Enterprise
 * Interface de atendimento médico com Evolução e Prescrição.
 * Integrado ao Dispatcher Semântico e Ledger de Auditoria.
 */
const ProntuarioClinico: React.FC<ProntuarioProps> = ({ atendimento, onClose, onSuccess }) => {
  const { runtime } = useRuntime();
  const [activeTab, setActiveTab] = useState<'evolucao' | 'prescricao'>('evolucao');
  const [loading, setLoading] = useState(false);

  // Estado da Evolução
  const [evolucao, setEvolucao] = useState({
    queixa: '',
    historico: '',
    exame_fisico: '',
    conduta: ''
  });

  // Estado da Prescrição
  const [itensPrescricao, setItensPrescricao] = useState<any[]>([]);
  const [novoItem, setNovoItem] = useState({ medicamento: '', posologia: '', quantidade: '' });
  const [sugestoes, setSugestoes] = useState<any[]>([]);
  const [showSugestoes, setShowSugestoes] = useState(false);

  // Busca de medicamentos em tempo real integrada ao estoque (Novo Modelo)
  useEffect(() => {
    const debounceTimer = setTimeout(async () => {
      if (novoItem.medicamento.length > 2 && showSugestoes) {
        try {
          const response = await runtimeService.dispatch('FARMACIA_BUSCAR_ESTOQUE', { 
            termo: novoItem.medicamento 
          }, runtime);
          setSugestoes(response.data?.payload || []);
        } catch (err) {
          console.error("Erro ao consultar estoque:", err);
        }
      } else if (novoItem.medicamento.length <= 2) {
        setSugestoes([]);
      }
    }, 400);
    return () => clearTimeout(debounceTimer);
  }, [novoItem.medicamento, runtime, showSugestoes]);

  const addMedicamento = () => {
    if (!novoItem.medicamento) return;
    setItensPrescricao([...itensPrescricao, { ...novoItem, id: Date.now() }]);
    setNovoItem({ medicamento: '', posologia: '', quantidade: '' });
  };

  const removerMedicamento = (id: number) => {
    setItensPrescricao(itensPrescricao.filter(i => i.id !== id));
  };

  const handleFinalizarAtendimento = async () => {
    setLoading(true);
    try {
      // 1. Salva Evolução e Prescrição em uma transação única via Dispatcher
      await runtimeService.dispatch('MEDICO_FINALIZAR_ATENDIMENTO', {
        id_ffa: atendimento.id_ffa,
        id_atendimento: atendimento.id_atendimento,
        evolucao,
        prescricao: itensPrescricao,
        status_final: 'FINALIZADO'
      }, runtime);

      alert('Atendimento finalizado e gravado no Ledger com sucesso!');
      onSuccess();
    } catch (err) {
      console.error("Erro ao finalizar atendimento:", err);
      alert("Erro ao processar transação no Ledger.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div className="bg-white w-full max-w-5xl h-[85vh] rounded-[2.5rem] shadow-2xl flex flex-col overflow-hidden animate-in zoom-in-95 duration-300">
        
        {/* Header do Prontuário */}
        <header className="p-6 border-b border-slate-100 flex items-center justify-between bg-slate-50/50">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 bg-indigo-600 rounded-2xl flex items-center justify-center text-white shadow-lg">
              <Stethoscope size={24} />
            </div>
            <div>
              <h2 className="text-xl font-black text-slate-900 leading-none mb-1">{atendimento.paciente_nome}</h2>
              <p className="text-xs text-slate-500 font-bold uppercase tracking-wider">
                Senha: {atendimento.senha_codigo} • FFA: {atendimento.id_ffa}
              </p>
            </div>
          </div>
          <button onClick={onClose} className="p-2 hover:bg-white rounded-xl transition-colors text-slate-400 hover:text-rose-500">
            <X size={24} />
          </button>
        </header>

        {/* Navegação de Abas */}
        <div className="flex border-b border-slate-100 px-8 bg-white">
          <button 
            onClick={() => setActiveTab('evolucao')}
            className={`py-4 px-6 flex items-center gap-2 font-bold text-sm transition-all border-b-2 ${activeTab === 'evolucao' ? 'border-indigo-600 text-indigo-600' : 'border-transparent text-slate-400 hover:text-slate-600'}`}
          >
            <FileText size={18} /> Evolução Clínica
          </button>
          <button 
            onClick={() => setActiveTab('prescricao')}
            className={`py-4 px-6 flex items-center gap-2 font-bold text-sm transition-all border-b-2 ${activeTab === 'prescricao' ? 'border-indigo-600 text-indigo-600' : 'border-transparent text-slate-400 hover:text-slate-600'}`}
          >
            <Pill size={18} /> Prescrição Médica
          </button>
        </div>

        {/* Área de Conteúdo */}
        <main className="flex-1 overflow-y-auto p-8">
          {activeTab === 'evolucao' ? (
            <div className="space-y-6 max-w-3xl">
              <div>
                <label className="block text-xs font-black text-slate-400 uppercase tracking-widest mb-2">Histórico e Queixa Principal</label>
                <textarea 
                  className="w-full border-slate-200 rounded-2xl p-4 min-h-[120px] focus:ring-2 focus:ring-indigo-500 transition-all outline-none bg-slate-50"
                  placeholder="Descreva a queixa do paciente e histórico atual..."
                  value={evolucao.queixa}
                  onChange={e => setEvolucao({...evolucao, queixa: e.target.value})}
                />
              </div>
              <div>
                <label className="block text-xs font-black text-slate-400 uppercase tracking-widest mb-2">Exame Físico / Observações</label>
                <textarea 
                  className="w-full border-slate-200 rounded-2xl p-4 min-h-[120px] focus:ring-2 focus:ring-indigo-500 transition-all outline-none bg-slate-50"
                  placeholder="Resultados do exame físico..."
                  value={evolucao.exame_fisico}
                  onChange={e => setEvolucao({...evolucao, exame_fisico: e.target.value})}
                />
              </div>
              <div>
                <label className="block text-xs font-black text-slate-400 uppercase tracking-widest mb-2">Conduta e Diagnóstico</label>
                <textarea 
                  className="w-full border-slate-200 rounded-2xl p-4 min-h-[100px] focus:ring-2 focus:ring-indigo-500 transition-all outline-none bg-slate-50"
                  placeholder="Conduta terapêutica e HD..."
                  value={evolucao.conduta}
                  onChange={e => setEvolucao({...evolucao, conduta: e.target.value})}
                />
              </div>
            </div>
          ) : (
            <div className="space-y-6">
              <div className="bg-slate-50 p-6 rounded-3xl border border-dashed border-slate-200">
                <h4 className="font-bold text-slate-700 mb-4 flex items-center gap-2">
                  <Plus size={18} className="text-indigo-600" /> Adicionar Medicamento
                </h4>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4 relative">
                  <div className="relative">
                    <input 
                      type="text" 
                      placeholder="Medicamento (mín. 3 letras)" 
                      className="w-full border-none rounded-xl p-3 shadow-sm outline-none focus:ring-2 focus:ring-indigo-500 transition-all" 
                      value={novoItem.medicamento} 
                      onChange={e => {
                        setNovoItem({...novoItem, medicamento: e.target.value});
                        setShowSugestoes(true);
                      }}
                    />
                    
                    {/* Dropdown de Sugestões com Saldo em Estoque */}
                    {showSugestoes && sugestoes.length > 0 && (
                      <div className="absolute left-0 right-0 top-full mt-2 bg-white border border-slate-100 rounded-2xl shadow-2xl z-[60] overflow-hidden animate-in fade-in slide-in-from-top-2 duration-200">
                        <div className="max-h-60 overflow-y-auto">
                          {sugestoes.map((s, idx) => (
                            <div 
                              key={idx}
                              onClick={() => {
                                setNovoItem({ ...novoItem, medicamento: `${s.nome} ${s.concentracao || ''}` });
                                setShowSugestoes(false);
                              }}
                              className="p-4 hover:bg-indigo-50 cursor-pointer border-b border-slate-50 last:border-none transition-colors"
                            >
                              <div className="flex justify-between items-start">
                                <span className="font-bold text-slate-900 text-sm">{s.nome}</span>
                                <span className={`text-[10px] font-black px-2 py-0.5 rounded ${s.quantidade_saldo > 0 ? 'bg-emerald-100 text-emerald-700' : 'bg-rose-100 text-rose-700'}`}>
                                  ESTOQUE: {s.quantidade_saldo}
                                </span>
                              </div>
                              <p className="text-[10px] text-slate-400 font-bold uppercase mt-1">{s.principio_ativo} • {s.concentracao}</p>
                            </div>
                          ))}
                        </div>
                      </div>
                    )}
                  </div>
                  <input 
                    type="text" placeholder="Posologia (ex: 12/12h)" className="border-none rounded-xl p-3 shadow-sm outline-none" 
                    value={novoItem.posologia} onChange={e => setNovoItem({...novoItem, posologia: e.target.value})}
                  />
                  <div className="flex gap-2">
                    <input 
                      type="text" placeholder="Qtd" className="border-none rounded-xl p-3 shadow-sm outline-none w-20" 
                      value={novoItem.quantidade} onChange={e => setNovoItem({...novoItem, quantidade: e.target.value})}
                    />
                    <button onClick={addMedicamento} className="flex-1 bg-indigo-600 text-white rounded-xl font-bold hover:bg-indigo-700 transition-colors">
                      Inserir
                    </button>
                  </div>
                </div>
              </div>

              <div className="space-y-3">
                <label className="block text-xs font-black text-slate-400 uppercase tracking-widest">Itens da Prescrição</label>
                {itensPrescricao.length === 0 ? (
                  <p className="text-slate-400 italic text-sm p-4 text-center">Nenhum medicamento adicionado.</p>
                ) : (
                  itensPrescricao.map((item) => (
                    <div key={item.id} className="flex items-center justify-between p-4 bg-white border border-slate-100 rounded-2xl shadow-sm group hover:border-indigo-100">
                      <div className="flex items-center gap-4">
                        <div className="p-2 bg-indigo-50 text-indigo-600 rounded-lg">
                          <Pill size={20} />
                        </div>
                        <div>
                          <p className="font-bold text-slate-900 leading-none">{item.medicamento}</p>
                          <p className="text-xs text-slate-500 font-medium">{item.posologia} • Qtd: {item.quantidade}</p>
                        </div>
                      </div>
                      <button onClick={() => removerMedicamento(item.id)} className="p-2 text-slate-300 hover:text-rose-500 transition-colors">
                        <Trash2 size={18} />
                      </button>
                    </div>
                  ))
                )}
              </div>
            </div>
          )}
        </main>

        {/* Footer com Ações */}
        <footer className="p-6 border-t border-slate-100 bg-white flex justify-between items-center px-8">
          <button onClick={onClose} className="text-slate-500 font-bold hover:text-slate-700 transition-colors">
            Descartar Alterações
          </button>
          <div className="flex gap-4">
            <button className="flex items-center gap-2 px-6 py-3 border border-slate-200 rounded-2xl text-slate-600 font-bold hover:bg-slate-50 transition-all">
              <Save size={18} /> Salvar Rascunho
            </button>
            <button 
              onClick={handleFinalizarAtendimento}
              disabled={loading}
              className="flex items-center gap-2 px-8 py-3 bg-indigo-600 text-white rounded-2xl font-black shadow-xl shadow-indigo-100 hover:bg-indigo-700 transition-all transform active:scale-95 disabled:opacity-50"
            >
              <ClipboardCheck size={20} /> {loading ? 'Processando...' : 'Finalizar Atendimento'}
            </button>
          </div>
        </footer>
      </div>
    </div>
  );
};

export default ProntuarioClinico;