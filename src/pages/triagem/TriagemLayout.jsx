import React, { useState } from 'react';
import { useFFAs } from '../../shared/hooks/useFFAs';
import { useEvolucoes } from '../../shared/hooks/useEvolucoes';
import { useUI } from '../../shared/hooks/useUI';
import FilaLocal from '../../components/FilaLocal';
import './TriagemLayout.css';

/**
 * Página Triagem - Registro de Sinais Vitais
 * Profissional de saúde registra sinais vitais e realiza triagem Manchester
 */
export function TriagemLayout() {
  const { ffaSelecionada, moverFFAPara } = useFFAs();
  const { registrarEvolucao } = useEvolucoes();
  const { notificarSucesso, notificarErro, confirmar } = useUI();

  const [modo, setModo] = useState('fila'); // 'fila' | 'triagem'
  const [sinaisVitais, setSinaisVitais] = useState({
    pressao_sistolica: '',
    pressao_diastolica: '',
    frequencia_cardiaca: '',
    frequencia_respiratoria: '',
    temperatura: '',
    glicemia: '',
    saturacao_oxigenio: '',
    observacoes: '',
  });

  const [manchesterSelecionada, setManchesterSelecionada] = useState(null);

  const MANCHESTER = {
    VERMELHO: { label: '🔴 Emergência', descricao: 'Risco imediato de morte', urgencia: 0 },
    LARANJA: { label: '🟠 Muito Urgente', descricao: 'Ameaça potencial à vida', urgencia: 10 },
    AMARELO: { label: '🟡 Urgente', descricao: 'Possível necessidade de investigação urgente', urgencia: 60 },
    VERDE: { label: '🟢 Pouco Urgente', descricao: 'Investigação não urgente', urgencia: 120 },
    AZUL: { label: '🔵 Não Urgente', descricao: 'Queixa menor', urgencia: 240 },
  };

  const handleRegistroTriagem = async (e) => {
    e.preventDefault();

    if (!manchesterSelecionada) {
      notificarErro('Selecione uma classificação de prioridade');
      return;
    }

    if (!ffaSelecionada) {
      notificarErro('Selecione um paciente da fila');
      return;
    }

    confirmar(`Confirma triagem para paciente ${ffaSelecionada.id_paciente} com prioridade ${MANCHESTER[manchesterSelecionada].label}?`, async () => {
      try {
        // Registra evolução de triagem
        await registrarEvolucao({
          tipo: 'TRIAGEM',
          ffa_id: ffaSelecionada.id,
          descricao: `Triagem realizada. ${JSON.stringify(sinaisVitais)}`,
          prioridade: manchesterSelecionada,
        });

        // Move FFA para TRIAGEM EM ANDAMENTO
        await moverFFAPara(ffaSelecionada.id, 'EM_TRIAGEM');

        notificarSucesso('Triagem registrada com sucesso');
        setSinaisVitais({
          pressao_sistolica: '',
          pressao_diastolica: '',
          frequencia_cardiaca: '',
          frequencia_respiratoria: '',
          temperatura: '',
          glicemia: '',
          saturacao_oxigenio: '',
          observacoes: '',
        });
        setManchesterSelecionada(null);
        setModo('fila');
      } catch (error) {
        notificarErro(`Erro ao registrar triagem: ${error.message}`);
      }
    });
  };

  return (
    <div className="triagem-layout">
      {/* Header */}
      <div className="triagem-header">
        <h1>🏥 Triagem</h1>
        <p>Registro de Sinais Vitais e Classificação Manchester</p>
      </div>

      {/* Abas */}
      <div className="triagem-tabs">
        <button className={`tab ${modo === 'fila' ? 'ativo' : ''}`} onClick={() => setModo('fila')}>
          📋 Fila
        </button>
        <button className={`tab ${modo === 'triagem' ? 'ativo' : ''}`} onClick={() => setModo('triagem')}>
          ✅ Registrar Triagem
        </button>
      </div>

      {/* Conteúdo */}
      <div className="triagem-conteudo">
        {modo === 'fila' && (
          <div className="secao-fila">
            <FilaLocal local="TRIAGEM" />
          </div>
        )}

        {modo === 'triagem' && (
          <div className="secao-triagem">
            {!ffaSelecionada ? (
              <div className="aviso-paciente">
                <p>⚠️ Selecione um paciente na fila para registrar triagem</p>
              </div>
            ) : (
              <form onSubmit={handleRegistroTriagem} className="triagem-form">
                {/* Info Paciente */}
                <div className="info-paciente">
                  <h3>Paciente {ffaSelecionada.id_paciente}</h3>
                  <span className="gpat">{ffaSelecionada.gpat}</span>
                </div>

                {/* Sinais Vitais */}
                <fieldset className="fieldset-sinais-vitais">
                  <legend>📊 Sinais Vitais</legend>

                  <div className="form-grid-3">
                    <div className="form-group">
                      <label>Pressão Sistólica (mmHg)</label>
                      <input
                        type="number"
                        min="50"
                        max="250"
                        placeholder="120"
                        value={sinaisVitais.pressao_sistolica}
                        onChange={(e) => setSinaisVitais({ ...sinaisVitais, pressao_sistolica: e.target.value })}
                      />
                    </div>
                    <div className="form-group">
                      <label>Pressão Diastólica (mmHg)</label>
                      <input
                        type="number"
                        min="30"
                        max="150"
                        placeholder="80"
                        value={sinaisVitais.pressao_diastolica}
                        onChange={(e) => setSinaisVitais({ ...sinaisVitais, pressao_diastolica: e.target.value })}
                      />
                    </div>
                    <div className="form-group">
                      <label>Frequência Cardíaca (bpm)</label>
                      <input
                        type="number"
                        min="30"
                        max="200"
                        placeholder="70"
                        value={sinaisVitais.frequencia_cardiaca}
                        onChange={(e) => setSinaisVitais({ ...sinaisVitais, frequencia_cardiaca: e.target.value })}
                      />
                    </div>
                  </div>

                  <div className="form-grid-3">
                    <div className="form-group">
                      <label>Frequência Respiratória (ipm)</label>
                      <input
                        type="number"
                        min="8"
                        max="50"
                        placeholder="16"
                        value={sinaisVitais.frequencia_respiratoria}
                        onChange={(e) => setSinaisVitais({ ...sinaisVitais, frequencia_respiratoria: e.target.value })}
                      />
                    </div>
                    <div className="form-group">
                      <label>Temperatura (°C)</label>
                      <input
                        type="number"
                        min="34"
                        max="42"
                        step="0.1"
                        placeholder="36.5"
                        value={sinaisVitais.temperatura}
                        onChange={(e) => setSinaisVitais({ ...sinaisVitais, temperatura: e.target.value })}
                      />
                    </div>
                    <div className="form-group">
                      <label>Saturação de O₂ (%)</label>
                      <input
                        type="number"
                        min="0"
                        max="100"
                        placeholder="98"
                        value={sinaisVitais.saturacao_oxigenio}
                        onChange={(e) => setSinaisVitais({ ...sinaisVitais, saturacao_oxigenio: e.target.value })}
                      />
                    </div>
                  </div>

                  <div className="form-group">
                    <label>Glicemia (mg/dL)</label>
                    <input
                      type="number"
                      min="0"
                      max="600"
                      placeholder="100"
                      value={sinaisVitais.glicemia}
                      onChange={(e) => setSinaisVitais({ ...sinaisVitais, glicemia: e.target.value })}
                    />
                  </div>
                </fieldset>

                {/* Manchester */}
                <fieldset className="fieldset-manchester">
                  <legend>⚕️ Classificação de Prioridade (Manchester)</legend>
                  <div className="manchester-opcoes">
                    {Object.entries(MANCHESTER).map(([key, value]) => (
                      <label key={key} className={`manchester-radio ${manchesterSelecionada === key ? 'selecionada' : ''}`}>
                        <input
                          type="radio"
                          name="manchester"
                          value={key}
                          checked={manchesterSelecionada === key}
                          onChange={(e) => setManchesterSelecionada(e.target.value)}
                        />
                        <div className="manchester-content">
                          <span className="manchester-label">{value.label}</span>
                          <span className="manchester-descricao">{value.descricao}</span>
                          <span className="manchester-urgencia">{value.urgencia} minutos de espera</span>
                        </div>
                      </label>
                    ))}
                  </div>
                </fieldset>

                {/* Observações */}
                <div className="form-group">
                  <label>Observações da Triagem</label>
                  <textarea
                    rows="4"
                    placeholder="Digite qualquer observação relevante sobre o paciente..."
                    value={sinaisVitais.observacoes}
                    onChange={(e) => setSinaisVitais({ ...sinaisVitais, observacoes: e.target.value })}
                  />
                </div>

                {/* Botões */}
                <div className="triagem-buttons">
                  <button type="button" className="btn-secundario" onClick={() => setModo('fila')}>
                    Cancelar
                  </button>
                  <button type="submit" className="btn-primario">
                    ✅ Registrar Triagem
                  </button>
                </div>
              </form>
            )}
          </div>
        )}
      </div>
    </div>
  );
}

export default TriagemLayout;
