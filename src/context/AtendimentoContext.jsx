import React, { createContext, useCallback, useReducer } from 'react';
import {
  EntidadeFactory,
  Operacoes,
  Colecoes,
  Validacoes,
  Historico,
  congelarProfundamente,
} from '../store/store.js';

/**
 * Context: AtendimentoContext
 * Gerencia o estado completo do atendimento
 */
export const AtendimentoContext = createContext();

const estadoInicial = {
  // Entidades principais
  ffa: null,
  filaOperacional: [],
  ordensAssistenciais: [],
  sessao: null,

  // Rastreamento
  historico: new Historico(),
  eventos: [],

  // Controle
  carregando: false,
  erro: null,
};

// ============================================
// REDUCER
// ============================================

const atendimentoReducer = (estado, acao) => {
  const novoEstado = { ...estado };

  try {
    switch (acao.tipo) {
      // ===== FFA =====
      case 'DEFINIR_FFA':
        novoEstado.ffa = EntidadeFactory.ffa(acao.dados);
        novoEstado.historico.registrarSnapshot(acao.dados.id, 'FFA', novoEstado.ffa, 'CRIACAO');
        break;

      case 'ALTERAR_STATUS_FFA':
        if (novoEstado.ffa) {
          const valido = Validacoes.transicaoFFAValida(novoEstado.ffa.status, acao.novoStatus);
          if (!valido) {
            throw new Error(`Transição inválida: ${novoEstado.ffa.status} → ${acao.novoStatus}`);
          }
          novoEstado.ffa = Operacoes.alterarStatusFFA(
            novoEstado.ffa,
            acao.novoStatus,
            acao.substatus
          );
          novoEstado.historico.registrarSnapshot(
            novoEstado.ffa.id,
            'FFA',
            novoEstado.ffa,
            'ALTERAR_STATUS'
          );
        }
        break;

      case 'ALTERAR_PRIORIDADE_FFA':
        if (novoEstado.ffa) {
          novoEstado.ffa = Operacoes.alterarPrioridadeFFA(novoEstado.ffa, acao.prioridade);
          novoEstado.historico.registrarSnapshot(
            novoEstado.ffa.id,
            'FFA',
            novoEstado.ffa,
            'ALTERAR_PRIORIDADE'
          );
        }
        break;

      case 'FINALIZAR_FFA':
        if (novoEstado.ffa) {
          novoEstado.ffa = Operacoes.finalizarFFA(novoEstado.ffa);
          novoEstado.historico.registrarSnapshot(
            novoEstado.ffa.id,
            'FFA',
            novoEstado.ffa,
            'FINALIZACAO'
          );
        }
        break;

      // ===== FILA =====
      case 'ADICIONAR_FILA':
        const novoItemFila = EntidadeFactory.fila(acao.dados);
        novoEstado.filaOperacional = Colecoes.adicionar(novoEstado.filaOperacional, novoItemFila);
        novoEstado.historico.registrarEvento({
          tipo: 'FILA_ADICIONADA',
          idFila: novoItemFila.id,
          idFFA: novoItemFila.id_ffa,
        });
        break;

      case 'CHAMAR_FILA':
        novoEstado.filaOperacional = Colecoes.atualizar(
          novoEstado.filaOperacional,
          acao.idFila,
          Operacoes.chamarFilaItem(
            novoEstado.filaOperacional.find((f) => f.id === acao.idFila),
            acao.idUsuario
          ),
          'id'
        );
        novoEstado.historico.registrarEvento({
          tipo: 'FILA_CHAMADA',
          idFila: acao.idFila,
          idUsuario: acao.idUsuario,
        });
        break;

      case 'INICIAR_FILA':
        novoEstado.filaOperacional = Colecoes.atualizar(
          novoEstado.filaOperacional,
          acao.idFila,
          Operacoes.iniciarFilaItem(
            novoEstado.filaOperacional.find((f) => f.id === acao.idFila),
            acao.idUsuario
          ),
          'id'
        );
        novoEstado.historico.registrarEvento({
          tipo: 'FILA_INICIADA',
          idFila: acao.idFila,
          idUsuario: acao.idUsuario,
        });
        break;

      case 'FINALIZAR_FILA':
        novoEstado.filaOperacional = Colecoes.atualizar(
          novoEstado.filaOperacional,
          acao.idFila,
          Operacoes.finalizarFilaItem(
            novoEstado.filaOperacional.find((f) => f.id === acao.idFila),
            acao.idUsuario
          ),
          'id'
        );
        novoEstado.historico.registrarEvento({
          tipo: 'FILA_FINALIZADA',
          idFila: acao.idFila,
          idUsuario: acao.idUsuario,
        });
        break;

      case 'REMOVER_FILA':
        novoEstado.filaOperacional = Colecoes.remover(
          novoEstado.filaOperacional,
          acao.idFila,
          'id'
        );
        break;

      // ===== ORDENS =====
      case 'ADICIONAR_ORDEM':
        const novaOrdem = EntidadeFactory.ordem(acao.dados);
        novoEstado.ordensAssistenciais = Colecoes.adicionar(
          novoEstado.ordensAssistenciais,
          novaOrdem
        );
        break;

      case 'ATUALIZAR_ORDEM':
        novoEstado.ordensAssistenciais = Colecoes.atualizar(
          novoEstado.ordensAssistenciais,
          acao.id,
          {
            ...acao.dados,
            atualizado_em: new Date().toISOString(),
          },
          'id'
        );
        break;

      case 'CONCLUIR_ORDEM':
        const ordem = novoEstado.ordensAssistenciais.find((o) => o.id === acao.id);
        if (ordem) {
          novoEstado.ordensAssistenciais = Colecoes.substituir(
            novoEstado.ordensAssistenciais,
            acao.id,
            Operacoes.concluirOrdem(ordem),
            'id'
          );
        }
        break;

      // ===== SESSÃO =====
      case 'DEFINIR_SESSAO':
        novoEstado.sessao = EntidadeFactory.sessao(acao.dados);
        break;

      case 'ENCERRAR_SESSAO':
        if (novoEstado.sessao) {
          novoEstado.sessao = Operacoes.encerrarSessao(novoEstado.sessao);
        }
        break;

      // ===== CONTROLE =====
      case 'DEFINIR_CARREGANDO':
        novoEstado.carregando = acao.valor;
        break;

      case 'DEFINIR_ERRO':
        novoEstado.erro = acao.erro;
        break;

      case 'LIMPAR_ERRO':
        novoEstado.erro = null;
        break;

      case 'REGISTRAR_EVENTO':
        novoEstado.eventos = Colecoes.adicionar(novoEstado.eventos, {
          ...acao.evento,
          id: `evt_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
          timestamp: new Date().toISOString(),
        });
        novoEstado.historico.registrarEvento(acao.evento);
        break;

      default:
        return estado;
    }

    return congelarProfundamente(novoEstado);
  } catch (err) {
    console.error('Erro no reducer:', err);
    novoEstado.erro = err.message;
    return congelarProfundamente(novoEstado);
  }
};

// ============================================
// PROVIDER
// ============================================

export const AtendimentoProvider = ({ children }) => {
  const [estado, dispatch] = useReducer(atendimentoReducer, estadoInicial);

  // ===== AÇÕES FFA =====
  const definirFFA = useCallback((dados) => {
    dispatch({ tipo: 'DEFINIR_FFA', dados });
  }, []);

  const alterarStatusFFA = useCallback((novoStatus, substatus = null) => {
    dispatch({ tipo: 'ALTERAR_STATUS_FFA', novoStatus, substatus });
  }, []);

  const alterarPrioridadeFFA = useCallback((prioridade) => {
    dispatch({ tipo: 'ALTERAR_PRIORIDADE_FFA', prioridade });
  }, []);

  const finalizarFFA = useCallback(() => {
    dispatch({ tipo: 'FINALIZAR_FFA' });
  }, []);

  // ===== AÇÕES FILA =====
  const adicionarFila = useCallback((dados) => {
    dispatch({ tipo: 'ADICIONAR_FILA', dados });
  }, []);

  const chamarFila = useCallback((idFila, idUsuario) => {
    dispatch({ tipo: 'CHAMAR_FILA', idFila, idUsuario });
  }, []);

  const iniciarFila = useCallback((idFila, idUsuario) => {
    dispatch({ tipo: 'INICIAR_FILA', idFila, idUsuario });
  }, []);

  const finalizarFila = useCallback((idFila, idUsuario) => {
    dispatch({ tipo: 'FINALIZAR_FILA', idFila, idUsuario });
  }, []);

  const removerFila = useCallback((idFila) => {
    dispatch({ tipo: 'REMOVER_FILA', idFila });
  }, []);

  // ===== AÇÕES ORDENS =====
  const adicionarOrdem = useCallback((dados) => {
    dispatch({ tipo: 'ADICIONAR_ORDEM', dados });
  }, []);

  const atualizarOrdem = useCallback((id, dados) => {
    dispatch({ tipo: 'ATUALIZAR_ORDEM', id, dados });
  }, []);

  const concluirOrdem = useCallback((id) => {
    dispatch({ tipo: 'CONCLUIR_ORDEM', id });
  }, []);

  // ===== AÇÕES SESSÃO =====
  const definirSessao = useCallback((dados) => {
    dispatch({ tipo: 'DEFINIR_SESSAO', dados });
  }, []);

  const encerrarSessao = useCallback(() => {
    dispatch({ tipo: 'ENCERRAR_SESSAO' });
  }, []);

  // ===== AÇÕES CONTROLE =====
  const definirCarregando = useCallback((valor) => {
    dispatch({ tipo: 'DEFINIR_CARREGANDO', valor });
  }, []);

  const definirErro = useCallback((erro) => {
    dispatch({ tipo: 'DEFINIR_ERRO', erro });
  }, []);

  const limparErro = useCallback(() => {
    dispatch({ tipo: 'LIMPAR_ERRO' });
  }, []);

  const registrarEvento = useCallback((evento) => {
    dispatch({ tipo: 'REGISTRAR_EVENTO', evento });
  }, []);

  // ===== HELPERS =====
  const obterHistoricoFFA = useCallback((idFFA) => {
    return estado.historico.obterHistorico(idFFA);
  }, [estado.historico]);

  const obterEventos = useCallback((filtro = {}) => {
    return estado.historico.obterEventos(filtro);
  }, [estado.historico]);

  const valor = {
    // Estado
    estado,
    ffa: estado.ffa,
    filaOperacional: estado.filaOperacional,
    ordensAssistenciais: estado.ordensAssistenciais,
    sessao: estado.sessao,
    carregando: estado.carregando,
    erro: estado.erro,
    eventos: estado.eventos,

    // Ações FFA
    definirFFA,
    alterarStatusFFA,
    alterarPrioridadeFFA,
    finalizarFFA,

    // Ações Fila
    adicionarFila,
    chamarFila,
    iniciarFila,
    finalizarFila,
    removerFila,

    // Ações Ordens
    adicionarOrdem,
    atualizarOrdem,
    concluirOrdem,

    // Ações Sessão
    definirSessao,
    encerrarSessao,

    // Ações Controle
    definirCarregando,
    definirErro,
    limparErro,
    registrarEvento,

    // Helpers
    obterHistoricoFFA,
    obterEventos,
  };

  return (
    <AtendimentoContext.Provider value={valor}>
      {children}
    </AtendimentoContext.Provider>
  );
};

export default AtendimentoContext;
