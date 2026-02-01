import React, { useState } from 'react';
import { useFFAs } from '../../shared/hooks/useFFAs';
import { useEvolucoes } from '../../shared/hooks/useEvolucoes';
import { useUI } from '../../shared/hooks/useUI';
import FilaLocal from '../../components/FilaLocal';
import './ConsultorioLayout.css';

/**
 * Página Consultório - Atendimento Médico
 * Médico avalia paciente, registra diagnóstico, prescreve medicações e exames
 */
export function ConsultorioLayout() {
  const { ffaSelecionada, moverFFAPara } = useFFAs();
  const { registrarEvolucao } = useEvolucoes();
  const { notificarSucesso, notificarErro, confirmar } = useUI();

  const [modo, setModo] = useState('fila'); // 'fila' | 'atendimento' | 'prescricao'

  const [atendimento, setAtendimento] = useState({
    queixa_principal: '',
    historia_doenca: '',
    exame_fisico: '',
    diagnostico: '',
    conduta: '',
  });

  const [prescricoes, setPrescricoes] = useState([]);
  const [exames, setExames] = useState([]);

  const [novaPrescricao, setNovaPrescricao] = useState({
    medicamento: '',
    dose: '',
    unidade: 'mg',
    frequencia: '',
    duracao: '',
  });

  const [novoExame, setNovoExame] = useState({
    tipo: '',
    urgencia: 'NORMAL',
  });

  const TIPOS_EXAME = [
    'Hemograma Completo',
    'Bioquímica',
    'Glicemia',
    'Colesterol',
    'Ureia e Creatinina',
    'Eletrocardiograma (ECG)',
    'Radiografia de Tórax',
    'Ultrassom',
    'Tomografia',
    'Ressonância',
  ];

  const UNIDADES = ['mg', 'ml', 'gota', 'comprimido', 'cápsula', 'injeção'];

  const FREQUENCIAS = [
    '1x ao dia',
    '2x ao dia',
    '3x ao dia',
    '4x ao dia',
    '6x ao dia',
    'A cada 4h',
    'A cada 6h',
    'A cada 8h',
    'A cada 12h',
    'Uma única vez',
  ];

  const adicionarPrescricao = () => {
    if (!novaPrescricao.medicamento || !novaPrescricao.dose || !novaPrescricao.frequencia) {
      notificarErro('Preencha todos os campos da prescrição');
      return;
    }
    setPrescricoes([...prescricoes, { ...novaPrescricao, id: Date.now() }]);
    setNovaPrescricao({ medicamento: '', dose: '', unidade: 'mg', frequencia: '', duracao: '' });
  };

  const removerPrescricao = (id) => {
    setPrescricoes(prescricoes.filter((p) => p.id !== id));
  };

  const adicionarExame = () => {
    if (!novoExame.tipo) {
      notificarErro('Selecione um tipo de exame');
      return;
    }
    setExames([...exames, { ...novoExame, id: Date.now() }]);
    setNovoExame({ tipo: '', urgencia: 'NORMAL' });
  };

  const removerExame = (id) => {
    setExames(exames.filter((e) => e.id !== id));
  };

  const finalizarAtendimento = async () => {
    if (!atendimento.diagnostico || !atendimento.conduta) {
      notificarErro('Preencha diagnóstico e conduta');
      return;
    }

    confirmar('Finalizar atendimento para este paciente?', async () => {
      try {
        // Registra evolução médica
        await registrarEvolucao({
          tipo: 'EVOLUCAO_MEDICA',
          ffa_id: ffaSelecionada.id,
          descricao: `${atendimento.queixa_principal} - ${atendimento.diagnostico}`,
          diagnostico: atendimento.diagnostico,
          conduta: atendimento.conduta,
          prescricoes: JSON.stringify(prescricoes),
          exames: JSON.stringify(exames),
        });

        // Define próximo status baseado em prescricoes/exames
        let proximoStatus = 'ALTA';
        if (exames.length > 0) {
          proximoStatus = 'AGUARDANDO_EXAME';
        } else if (prescricoes.length > 0) {
          proximoStatus = 'AGUARDANDO_MEDICACAO';
        }

        await moverFFAPara(ffaSelecionada.id, proximoStatus);

        notificarSucesso(`Atendimento finalizado. Próximo status: ${proximoStatus}`);

        // Limpa formulário
        setAtendimento({
          queixa_principal: '',
          historia_doenca: '',
          exame_fisico: '',
          diagnostico: '',
          conduta: '',
        });
        setPrescricoes([]);
        setExames([]);
        setModo('fila');
      } catch (error) {
        notificarErro(`Erro ao finalizar atendimento: ${error.message}`);
      }
    });
  };

  return (
    <div className="consultorio-layout">
      {/* Header */}
      <div className="consultorio-header">
        <h1>⚕️ Consultório Médico</h1>
        <p>Atendimento, Diagnóstico e Prescrição</p>
      </div>

      {/* Tabs */}
      <div className="consultorio-tabs">
        <button className={`tab ${modo === 'fila' ? 'ativo' : ''}`} onClick={() => setModo('fila')}>
          📋 Fila
        </button>
        <button className={`tab ${modo === 'atendimento' ? 'ativo' : ''}`} onClick={() => setModo('atendimento')}>
          📝 Atendimento
        </button>
        <button className={`tab ${modo === 'prescricao' ? 'ativo' : ''}`} onClick={() => setModo('prescricao')}>
          💊 Prescrição
        </button>
      </div>

      {/* Conteúdo */}
      <div className="consultorio-conteudo">
        {modo === 'fila' && (
          <div className="secao-fila">
            <FilaLocal local="CONSULTORIO" />
          </div>
        )}

        {modo === 'atendimento' && (
          <div className="secao-atendimento">
            {!ffaSelecionada ? (
              <div className="aviso-paciente">
                <p>⚠️ Selecione um paciente na fila para iniciar atendimento</p>
              </div>
            ) : (
              <form className="atendimento-form">
                <div className="info-paciente">
                  <h3>Paciente {ffaSelecionada.id_paciente}</h3>
                  <span className="gpat">{ffaSelecionada.gpat}</span>
                </div>

                {/* Queixa e História */}
                <div className="form-group">
                  <label>Queixa Principal *</label>
                  <input
                    type="text"
                    placeholder="Ex: Dor no peito, Febre alta, etc"
                    value={atendimento.queixa_principal}
                    onChange={(e) => setAtendimento({ ...atendimento, queixa_principal: e.target.value })}
                  />
                </div>

                <div className="form-group">
                  <label>História da Doença Atual</label>
                  <textarea
                    rows="3"
                    placeholder="Descreva o início dos sintomas, progressão, fatores agravantes..."
                    value={atendimento.historia_doenca}
                    onChange={(e) => setAtendimento({ ...atendimento, historia_doenca: e.target.value })}
                  />
                </div>

                <div className="form-group">
                  <label>Exame Físico</label>
                  <textarea
                    rows="3"
                    placeholder="Achados do exame físico..."
                    value={atendimento.exame_fisico}
                    onChange={(e) => setAtendimento({ ...atendimento, exame_fisico: e.target.value })}
                  />
                </div>

                {/* Diagnóstico e Conduta */}
                <div className="form-group">
                  <label>Diagnóstico *</label>
                  <input
                    type="text"
                    placeholder="Digite o diagnóstico"
                    value={atendimento.diagnostico}
                    onChange={(e) => setAtendimento({ ...atendimento, diagnostico: e.target.value })}
                  />
                </div>

                <div className="form-group">
                  <label>Conduta *</label>
                  <textarea
                    rows="2"
                    placeholder="Descreva a conduta terapêutica..."
                    value={atendimento.conduta}
                    onChange={(e) => setAtendimento({ ...atendimento, conduta: e.target.value })}
                  />
                </div>

                {/* Botões */}
                <div className="atendimento-buttons">
                  <button type="button" className="btn-secundario" onClick={() => setModo('fila')}>
                    Voltar
                  </button>
                  <button type="button" className="btn-primario" onClick={() => setModo('prescricao')}>
                    Próximo: Prescrição
                  </button>
                </div>
              </form>
            )}
          </div>
        )}

        {modo === 'prescricao' && (
          <div className="secao-prescricao">
            {!ffaSelecionada ? (
              <div className="aviso-paciente">
                <p>⚠️ Selecione um paciente na fila</p>
              </div>
            ) : (
              <div className="prescricao-container">
                <div className="info-paciente">
                  <h3>Paciente {ffaSelecionada.id_paciente}</h3>
                  <span className="gpat">{ffaSelecionada.gpat}</span>
                </div>

                {/* Seção Prescrições */}
                <fieldset>
                  <legend>💊 Prescrições de Medicamentos</legend>

                  <div className="nova-prescricao">
                    <div className="form-row-4">
                      <div className="form-group">
                        <label>Medicamento</label>
                        <input
                          type="text"
                          placeholder="Ex: Dipirona"
                          value={novaPrescricao.medicamento}
                          onChange={(e) => setNovaPrescricao({ ...novaPrescricao, medicamento: e.target.value })}
                        />
                      </div>
                      <div className="form-group">
                        <label>Dose</label>
                        <input
                          type="number"
                          placeholder="500"
                          value={novaPrescricao.dose}
                          onChange={(e) => setNovaPrescricao({ ...novaPrescricao, dose: e.target.value })}
                        />
                      </div>
                      <div className="form-group">
                        <label>Unidade</label>
                        <select
                          value={novaPrescricao.unidade}
                          onChange={(e) => setNovaPrescricao({ ...novaPrescricao, unidade: e.target.value })}
                        >
                          {UNIDADES.map((u) => (
                            <option key={u} value={u}>
                              {u}
                            </option>
                          ))}
                        </select>
                      </div>
                      <div className="form-group">
                        <label>Frequência</label>
                        <select
                          value={novaPrescricao.frequencia}
                          onChange={(e) => setNovaPrescricao({ ...novaPrescricao, frequencia: e.target.value })}
                        >
                          <option value="">Selecione...</option>
                          {FREQUENCIAS.map((f) => (
                            <option key={f} value={f}>
                              {f}
                            </option>
                          ))}
                        </select>
                      </div>
                    </div>
                    <button type="button" className="btn-adicionar" onClick={adicionarPrescricao}>
                      ➕ Adicionar Prescrição
                    </button>
                  </div>

                  {prescricoes.length > 0 && (
                    <div className="prescricoes-lista">
                      {prescricoes.map((p) => (
                        <div key={p.id} className="prescricao-item">
                          <span className="prescricao-info">
                            {p.dose} {p.unidade} de {p.medicamento} - {p.frequencia}
                          </span>
                          <button
                            type="button"
                            className="btn-remover"
                            onClick={() => removerPrescricao(p.id)}
                          >
                            ✕
                          </button>
                        </div>
                      ))}
                    </div>
                  )}
                </fieldset>

                {/* Seção Exames */}
                <fieldset>
                  <legend>🔬 Solicitação de Exames</legend>

                  <div className="novo-exame">
                    <div className="form-row-2">
                      <div className="form-group">
                        <label>Tipo de Exame</label>
                        <select
                          value={novoExame.tipo}
                          onChange={(e) => setNovoExame({ ...novoExame, tipo: e.target.value })}
                        >
                          <option value="">Selecione...</option>
                          {TIPOS_EXAME.map((t) => (
                            <option key={t} value={t}>
                              {t}
                            </option>
                          ))}
                        </select>
                      </div>
                      <div className="form-group">
                        <label>Urgência</label>
                        <select
                          value={novoExame.urgencia}
                          onChange={(e) => setNovoExame({ ...novoExame, urgencia: e.target.value })}
                        >
                          <option value="NORMAL">🟢 Normal</option>
                          <option value="URGENTE">🟡 Urgente</option>
                          <option value="EMERGENCIA">🔴 Emergência</option>
                        </select>
                      </div>
                    </div>
                    <button type="button" className="btn-adicionar" onClick={adicionarExame}>
                      ➕ Adicionar Exame
                    </button>
                  </div>

                  {exames.length > 0 && (
                    <div className="exames-lista">
                      {exames.map((e) => (
                        <div key={e.id} className="exame-item">
                          <span className="exame-info">
                            {e.tipo} - {e.urgencia}
                          </span>
                          <button type="button" className="btn-remover" onClick={() => removerExame(e.id)}>
                            ✕
                          </button>
                        </div>
                      ))}
                    </div>
                  )}
                </fieldset>

                {/* Botões Finais */}
                <div className="prescricao-buttons">
                  <button type="button" className="btn-secundario" onClick={() => setModo('atendimento')}>
                    ← Voltar
                  </button>
                  <button type="button" className="btn-primario" onClick={finalizarAtendimento}>
                    ✅ Finalizar Atendimento
                  </button>
                </div>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
}

export default ConsultorioLayout;
