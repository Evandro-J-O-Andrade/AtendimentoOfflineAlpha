import React, { useState } from 'react';
import { useFFAs } from '../../shared/hooks/useFFAs';
import { useEvolucoes } from '../../shared/hooks/useEvolucoes';
import { useUI } from '../../shared/hooks/useUI';
import FilaLocal from '../../components/FilaLocal';
import './InternacaoLayout.css';

/**
 * Página Internação - Movimentação de Leitos e Evoluções
 * Enfermeiro registra evoluções e coordena leitos de internação
 */
export function InternacaoLayout() {
  const { ffaSelecionada, moverFFAPara } = useFFAs();
  const { registrarEvolucao, evolucoesInternacao } = useEvolucoes();
  const { notificarSucesso, notificarErro, confirmar } = useUI();

  const [modo, setModo] = useState('fila'); // 'fila' | 'movimentacao' | 'evolucoes'

  const [internacao, setInternacao] = useState({
    id_setor: '',
    numero_leito: '',
    observacoes_admissao: '',
  });

  const [evolucaoEnfermagem, setEvolucaoEnfermagem] = useState({
    descricao: '',
    sinais_vitais: '',
    cuidados_realizados: '',
    medicacoes_administradas: '',
  });

  const SETORES = [
    'Clínica Geral',
    'Pediatria',
    'Cardiologia',
    'Neurologia',
    'Terapia Intensiva (UTI)',
    'Isolamento',
  ];

  const admitirInternacao = async () => {
    if (!internacao.id_setor || !internacao.numero_leito) {
      notificarErro('Selecione setor e leito');
      return;
    }

    confirmar(
      `Internar paciente ${ffaSelecionada?.id_paciente} no leito ${internacao.numero_leito}?`,
      async () => {
        try {
          await registrarEvolucao({
            tipo: 'INTERNACAO_ADMISSAO',
            ffa_id: ffaSelecionada?.id,
            descricao: `Internado em ${internacao.id_setor} - Leito ${internacao.numero_leito}`,
            observacoes: internacao.observacoes_admissao,
          });

          await moverFFAPara(ffaSelecionada?.id, 'INTERNACAO');

          notificarSucesso(`Paciente internado no leito ${internacao.numero_leito}`);
          setInternacao({ id_setor: '', numero_leito: '', observacoes_admissao: '' });
          setModo('fila');
        } catch (error) {
          notificarErro(`Erro ao internar: ${error.message}`);
        }
      }
    );
  };

  const registrarEvolucaoEnfermagem = async () => {
    if (!evolucaoEnfermagem.descricao || !evolucaoEnfermagem.sinais_vitais) {
      notificarErro('Preencha descrição e sinais vitais');
      return;
    }

    try {
      await registrarEvolucao({
        tipo: 'EVOLUCAO_ENFERMAGEM',
        ffa_id: ffaSelecionada?.id,
        descricao: evolucaoEnfermagem.descricao,
        sinais_vitais: evolucaoEnfermagem.sinais_vitais,
        cuidados: evolucaoEnfermagem.cuidados_realizados,
        medicacoes: evolucaoEnfermagem.medicacoes_administradas,
      });

      notificarSucesso('Evolução registrada com sucesso');
      setEvolucaoEnfermagem({
        descricao: '',
        sinais_vitais: '',
        cuidados_realizados: '',
        medicacoes_administradas: '',
      });
    } catch (error) {
      notificarErro(`Erro ao registrar evolução: ${error.message}`);
    }
  };

  const solicitarAlta = async () => {
    confirmar(`Solicitar alta para paciente ${ffaSelecionada?.id_paciente}?`, async () => {
      try {
        await moverFFAPara(ffaSelecionada?.id, 'ALTA');
        notificarSucesso('Paciente marcado para alta');
        setModo('fila');
      } catch (error) {
        notificarErro(`Erro ao solicitar alta: ${error.message}`);
      }
    });
  };

  return (
    <div className="internacao-layout">
      {/* Header */}
      <div className="internacao-header">
        <h1>🏥 Internação</h1>
        <p>Movimentação de Leitos e Evoluções de Enfermagem</p>
      </div>

      {/* Tabs */}
      <div className="internacao-tabs">
        <button className={`tab ${modo === 'fila' ? 'ativo' : ''}`} onClick={() => setModo('fila')}>
          📋 Fila
        </button>
        <button className={`tab ${modo === 'movimentacao' ? 'ativo' : ''}`} onClick={() => setModo('movimentacao')}>
          🛏️ Movimentação de Leitos
        </button>
        <button className={`tab ${modo === 'evolucoes' ? 'ativo' : ''}`} onClick={() => setModo('evolucoes')}>
          📝 Evoluções de Enfermagem
        </button>
      </div>

      {/* Conteúdo */}
      <div className="internacao-conteudo">
        {modo === 'fila' && (
          <div className="secao-fila">
            <FilaLocal local="INTERNACAO" />
          </div>
        )}

        {modo === 'movimentacao' && (
          <div className="secao-movimentacao">
            {!ffaSelecionada ? (
              <div className="aviso-paciente">
                <p>⚠️ Selecione um paciente na fila para movimentação de leito</p>
              </div>
            ) : (
              <form className="movimentacao-form" onSubmit={(e) => { e.preventDefault(); admitirInternacao(); }}>
                <div className="info-paciente">
                  <h3>Paciente {ffaSelecionada.id_paciente}</h3>
                  <span className="gpat">{ffaSelecionada.gpat}</span>
                </div>

                <div className="form-group">
                  <label>Setor de Internação *</label>
                  <select
                    value={internacao.id_setor}
                    onChange={(e) => setInternacao({ ...internacao, id_setor: e.target.value })}
                    required
                  >
                    <option value="">Selecione um setor...</option>
                    {SETORES.map((setor) => (
                      <option key={setor} value={setor}>
                        {setor}
                      </option>
                    ))}
                  </select>
                </div>

                <div className="form-group">
                  <label>Número do Leito *</label>
                  <input
                    type="number"
                    min="1"
                    max="500"
                    placeholder="Ex: 105"
                    value={internacao.numero_leito}
                    onChange={(e) => setInternacao({ ...internacao, numero_leito: e.target.value })}
                    required
                  />
                </div>

                <div className="form-group">
                  <label>Observações de Admissão</label>
                  <textarea
                    rows="4"
                    placeholder="Observações importantes sobre a internação..."
                    value={internacao.observacoes_admissao}
                    onChange={(e) => setInternacao({ ...internacao, observacoes_admissao: e.target.value })}
                  />
                </div>

                <div className="movimentacao-buttons">
                  <button type="button" className="btn-secundario" onClick={() => setModo('fila')}>
                    Cancelar
                  </button>
                  <button type="submit" className="btn-primario">
                    🛏️ Internar Paciente
                  </button>
                </div>
              </form>
            )}
          </div>
        )}

        {modo === 'evolucoes' && (
          <div className="secao-evolucoes">
            {!ffaSelecionada ? (
              <div className="aviso-paciente">
                <p>⚠️ Selecione um paciente na fila</p>
              </div>
            ) : (
              <div className="evolucoes-container">
                <div className="info-paciente">
                  <h3>Paciente {ffaSelecionada.id_paciente}</h3>
                  <span className="gpat">{ffaSelecionada.gpat}</span>
                </div>

                {/* Forma de Nova Evolução */}
                <fieldset>
                  <legend>📝 Nova Evolução de Enfermagem</legend>

                  <div className="form-group">
                    <label>Descrição Clínica *</label>
                    <textarea
                      rows="3"
                      placeholder="Descreva o estado clínico do paciente, comportamento, queixas..."
                      value={evolucaoEnfermagem.descricao}
                      onChange={(e) => setEvolucaoEnfermagem({ ...evolucaoEnfermagem, descricao: e.target.value })}
                    />
                  </div>

                  <div className="form-group">
                    <label>Sinais Vitais Atuais *</label>
                    <input
                      type="text"
                      placeholder="Ex: PA 120/80, FC 75, T 36.5°C, FR 16, O2 98%"
                      value={evolucaoEnfermagem.sinais_vitais}
                      onChange={(e) => setEvolucaoEnfermagem({ ...evolucaoEnfermagem, sinais_vitais: e.target.value })}
                    />
                  </div>

                  <div className="form-group">
                    <label>Cuidados Realizados</label>
                    <textarea
                      rows="2"
                      placeholder="Curativo, higiene, mobilizações, etc..."
                      value={evolucaoEnfermagem.cuidados_realizados}
                      onChange={(e) => setEvolucaoEnfermagem({ ...evolucaoEnfermagem, cuidados_realizados: e.target.value })}
                    />
                  </div>

                  <div className="form-group">
                    <label>Medicações Administradas</label>
                    <textarea
                      rows="2"
                      placeholder="Listae medicações e horários..."
                      value={evolucaoEnfermagem.medicacoes_administradas}
                      onChange={(e) => setEvolucaoEnfermagem({ ...evolucaoEnfermagem, medicacoes_administradas: e.target.value })}
                    />
                  </div>

                  <button type="button" className="btn-adicionar" onClick={registrarEvolucaoEnfermagem}>
                    ➕ Registrar Evolução
                  </button>
                </fieldset>

                {/* Histórico de Evoluções */}
                {evolucoesInternacao && evolucoesInternacao.length > 0 && (
                  <fieldset>
                    <legend>📋 Histórico de Evoluções</legend>
                    <div className="evolucoes-lista">
                      {evolucoesInternacao.map((evo, idx) => (
                        <div key={idx} className="evolucao-item">
                          <span className="evolucao-timestamp">{evo.data_hora}</span>
                          <p className="evolucao-descricao">{evo.descricao}</p>
                        </div>
                      ))}
                    </div>
                  </fieldset>
                )}

                {/* Botões Finais */}
                <div className="evolucoes-buttons">
                  <button type="button" className="btn-secundario" onClick={() => setModo('fila')}>
                    ← Voltar
                  </button>
                  <button type="button" className="btn-alta" onClick={solicitarAlta}>
                    🎉 Solicitar Alta
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

export default InternacaoLayout;
