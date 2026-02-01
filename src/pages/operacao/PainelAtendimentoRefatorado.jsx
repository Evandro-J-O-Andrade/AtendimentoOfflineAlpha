import React, { useEffect, useState } from 'react';
import { useFFAFlow, useQueueManagement, useAuditTrail } from '../shared/hooks/useImmutable';
import atendimentoService from '../services/atendimento.immutable.service';

/**
 * Componente: Painel de Atendimento Refatorado
 * Exemplo de como usar a arquitetura imutável
 * 
 * Funcionalidades:
 * - Gerenciar FFA (Ficha de Fila Assistencial)
 * - Controlar fila operacional
 * - Manter auditoria completa
 */
export const PainelAtendimentoRefatorado = ({ pacienteId, localId }) => {
  const {
    ffa,
    iniciarAtendimento,
    mudarStatus,
    alterarPrioridade,
    finalizarAtendimento,
  } = useFFAFlow();

  const {
    filaOperacional,
    chamarSenha,
    iniciarFila,
    finalizarFila,
    naoCompareceu,
  } = useQueueManagement();

  const { eventos, getFFAHistory, getAuditEvents } = useAuditTrail();

  const [atendimentoAtivo, setAtendimentoAtivo] = useState(null);
  const [historialAtual, setHistorialAtual] = useState([]);
  const [carregando, setCarregando] = useState(false);
  const [erro, setErro] = useState(null);

  // Efeito: Atualizar histórico quando FFA muda
  useEffect(() => {
    if (ffa?.id) {
      const historico = getFFAHistory(ffa.id);
      setHistorialAtual(historico);
    }
  }, [ffa, getFFAHistory]);

  // Handler: Iniciar novo atendimento
  const handleIniciarAtendimento = async () => {
    setCarregando(true);
    setErro(null);
    try {
      const novaFFA = await iniciarAtendimento(pacienteId, 1); // especialidade 1
      setAtendimentoAtivo(novaFFA);
    } catch (err) {
      setErro(err.message);
    } finally {
      setCarregando(false);
    }
  };

  // Handler: Chamar próximo paciente
  const handleChamarProximo = async (filaSenhaId) => {
    setCarregando(true);
    try {
      await chamarSenha(filaSenhaId, 1); // userId 1
    } catch (err) {
      setErro(err.message);
    } finally {
      setCarregando(false);
    }
  };

  // Handler: Iniciar atendimento do paciente
  const handleIniciarFila = async (filaId) => {
    setCarregando(true);
    try {
      await iniciarFila(filaId, 1); // userId 1
    } catch (err) {
      setErro(err.message);
    } finally {
      setCarregando(false);
    }
  };

  // Handler: Finalizar atendimento
  const handleFinalizarAtendimento = async (motivo = 'ALTA') => {
    setCarregando(true);
    try {
      await finalizarAtendimento(motivo);
      setAtendimentoAtivo(null);
    } catch (err) {
      setErro(err.message);
    } finally {
      setCarregando(false);
    }
  };

  // Handler: Alterar prioridade
  const handleAlterarPrioridade = async (novaPrioridade) => {
    setCarregando(true);
    try {
      await alterarPrioridade(novaPrioridade);
    } catch (err) {
      setErro(err.message);
    } finally {
      setCarregando(false);
    }
  };

  // Handler: Mudar status
  const handleMudarStatus = async (novoStatus, substatus) => {
    setCarregando(true);
    try {
      await mudarStatus(novoStatus, substatus);
    } catch (err) {
      setErro(err.message);
    } finally {
      setCarregando(false);
    }
  };

  return (
    <div className="painel-atendimento-refatorado">
      <h1>Painel de Atendimento - Arquitetura Imutável</h1>

      {/* SEÇÃO: Erro */}
      {erro && (
        <div className="alerta-erro">
          <strong>Erro:</strong> {erro}
          <button onClick={() => setErro(null)}>Fechar</button>
        </div>
      )}

      {/* SEÇÃO: FFA Atual */}
      <section className="secao-ffa">
        <h2>Ficha de Fila Assistencial Atual</h2>

        {ffa ? (
          <div className="ffa-info">
            <div className="info-grid">
              <div>
                <label>Protocolo:</label>
                <span>{ffa.protocolo}</span>
              </div>
              <div>
                <label>Status:</label>
                <span className={`status-${ffa.status}`}>{ffa.status}</span>
              </div>
              <div>
                <label>Substatus:</label>
                <span>{ffa.substatus || 'N/A'}</span>
              </div>
              <div>
                <label>Prioridade:</label>
                <span className={`prioridade-${ffa.prioridade}`}>{ffa.prioridade}</span>
              </div>
            </div>

            {/* Controles de Status */}
            <div className="controles-status">
              <button
                onClick={() => handleMudarStatus('EM_ATENDIMENTO')}
                disabled={carregando}
              >
                Em Atendimento
              </button>
              <button
                onClick={() => handleMudarStatus('EM_OBSERVACAO')}
                disabled={carregando}
              >
                Em Observação
              </button>
              <button
                onClick={() => handleMudarStatus('INTERNADO')}
                disabled={carregando}
              >
                Internar
              </button>
              <button
                onClick={() => handleFinalizarAtendimento('ALTA')}
                disabled={carregando}
              >
                Finalizar (Alta)
              </button>
            </div>

            {/* Controles de Prioridade */}
            <div className="controles-prioridade">
              <label>Alterar Prioridade:</label>
              <select
                onChange={(e) => handleAlterarPrioridade(e.target.value)}
                defaultValue={ffa.prioridade}
                disabled={carregando}
              >
                <option value="BAIXA">Baixa</option>
                <option value="NORMAL">Normal</option>
                <option value="ALTA">Alta</option>
                <option value="CRITICA">Crítica</option>
              </select>
            </div>
          </div>
        ) : (
          <div className="sem-ffa">
            <p>Nenhuma FFA selecionada</p>
            <button onClick={handleIniciarAtendimento} disabled={carregando}>
              {carregando ? 'Abrindo...' : 'Iniciar Novo Atendimento'}
            </button>
          </div>
        )}
      </section>

      {/* SEÇÃO: Fila Operacional */}
      <section className="secao-fila">
        <h2>Fila Operacional</h2>
        {filaOperacional && filaOperacional.length > 0 ? (
          <div className="fila-lista">
            {filaOperacional.map((item) => (
              <div key={item.id} className={`fila-item status-${item.status}`}>
                <div className="fila-info">
                  <span className="paciente">{item.paciente || 'Paciente'}</span>
                  <span className="status">{item.status}</span>
                  <span className="prioridade">{item.prioridade}</span>
                </div>
                <div className="fila-acoes">
                  {item.status === 'AGUARDANDO' && (
                    <button onClick={() => handleChamarProximo(item.id)} disabled={carregando}>
                      Chamar
                    </button>
                  )}
                  {item.status === 'CHAMANDO' && (
                    <button onClick={() => handleIniciarFila(item.id)} disabled={carregando}>
                      Iniciar
                    </button>
                  )}
                  {item.status === 'EM_EXECUCAO' && (
                    <button onClick={() => finalizarFila(item.id, 1)} disabled={carregando}>
                      Finalizar
                    </button>
                  )}
                  {item.status !== 'FINALIZADO' && (
                    <button
                      onClick={() => naoCompareceu(item.id, 1, 'Não compareceu')}
                      disabled={carregando}
                      className="btn-secundario"
                    >
                      Não Compareceu
                    </button>
                  )}
                </div>
              </div>
            ))}
          </div>
        ) : (
          <p>Nenhum item na fila</p>
        )}
      </section>

      {/* SEÇÃO: Histórico de Auditoria */}
      <section className="secao-auditoria">
        <h2>Histórico de Auditoria</h2>
        {historialAtual && historialAtual.length > 0 ? (
          <div className="auditoria-lista">
            {historialAtual.map((evento, idx) => (
              <div key={idx} className="auditoria-item">
                <div className="auditoria-header">
                  <span className="acao">{evento.action}</span>
                  <span className="timestamp">{evento.timestamp}</span>
                </div>
                <div className="auditoria-detalhe">
                  <pre>{JSON.stringify(evento.state, null, 2).substring(0, 200)}</pre>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <p>Nenhum evento de auditoria</p>
        )}
      </section>

      {/* SEÇÃO: Eventos em Tempo Real */}
      <section className="secao-eventos">
        <h2>Eventos em Tempo Real</h2>
        {eventos && eventos.length > 0 ? (
          <div className="eventos-lista">
            {eventos.slice(-10).map((evt, idx) => (
              <div key={idx} className="evento-item">
                <span className="tipo">{evt.entidade}</span>
                <span className="acao">{evt.acao}</span>
                <span className="timestamp">{evt.criado_em}</span>
              </div>
            ))}
          </div>
        ) : (
          <p>Nenhum evento registrado</p>
        )}
      </section>

      {/* Estilo Inline */}
      <style jsx>{`
        .painel-atendimento-refatorado {
          padding: 20px;
          font-family: Arial, sans-serif;
        }

        .alerta-erro {
          background-color: #fee;
          border: 1px solid #f88;
          padding: 10px;
          margin-bottom: 20px;
          border-radius: 4px;
        }

        section {
          margin: 20px 0;
          padding: 15px;
          border: 1px solid #ddd;
          border-radius: 4px;
          background: #f9f9f9;
        }

        .info-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
          gap: 10px;
          margin: 10px 0;
        }

        .info-grid > div {
          padding: 10px;
          background: white;
          border-radius: 4px;
        }

        label {
          font-weight: bold;
          display: block;
          margin-bottom: 5px;
        }

        button {
          padding: 8px 12px;
          margin: 5px;
          background: #007bff;
          color: white;
          border: none;
          border-radius: 4px;
          cursor: pointer;
        }

        button:disabled {
          background: #ccc;
          cursor: not-allowed;
        }

        button.btn-secundario {
          background: #6c757d;
        }

        .fila-lista {
          display: flex;
          flex-direction: column;
          gap: 10px;
        }

        .fila-item {
          display: flex;
          justify-content: space-between;
          align-items: center;
          padding: 10px;
          background: white;
          border-left: 4px solid #007bff;
          border-radius: 4px;
        }

        .fila-item.status-CHAMANDO {
          border-left-color: #ffc107;
        }

        .fila-item.status-EM_EXECUCAO {
          border-left-color: #28a745;
        }

        .fila-acoes {
          display: flex;
          gap: 5px;
        }

        .auditoria-lista,
        .eventos-lista {
          display: flex;
          flex-direction: column;
          gap: 10px;
          max-height: 400px;
          overflow-y: auto;
        }

        .auditoria-item,
        .evento-item {
          padding: 10px;
          background: white;
          border-left: 3px solid #6c757d;
          border-radius: 4px;
          font-size: 12px;
        }

        .auditoria-header {
          display: flex;
          justify-content: space-between;
          margin-bottom: 5px;
        }

        .acao {
          font-weight: bold;
        }

        .timestamp {
          color: #999;
          font-size: 11px;
        }

        pre {
          margin: 0;
          background: #f0f0f0;
          padding: 5px;
          border-radius: 3px;
          overflow: hidden;
          text-overflow: ellipsis;
        }
      `}</style>
    </div>
  );
};

export default PainelAtendimentoRefatorado;
