/**
 * AtendimentoContextoV2 — Contexto Unificado para Todos os Locais
 * 
 * Locais de atendimento: RECEPCAO, TRIAGEM, CONSULTORIO, EXAME, MEDICACAO, INTERNACAO, SAMU, FARMACIA, TI, GLPI, MANUTENCAO
 * 
 * Estados:
 * - FFAs ativas (pacientes em fluxo)
 * - Evoluções de enfermagem (histórico)
 * - Contexto do usuário (local, perfil)
 * - Fila por local
 * - Alertas e prioridades (Manchester, TIME)
 * 
 * Imutabilidade: todos os estados são imutáveis; ações usam Immer
 */

import React, { useReducer, useCallback } from 'react';
import { produce } from 'immer';

const AtendimentoContextoV2 = React.createContext(null);

// Estados iniciais por domínio
const ESTADO_INICIAL = {
  // Usuário e contexto
  usuario: {
    id_usuario: null,
    nome: '',
    login: '',
    perfis: [],
    local_atual: 'RECEPCAO',
    sessao_ativa: false,
  },
  
  // FFAs (Ficha de Fluxo de Atendimento)
  ffas: {
    ativas: [],          // FFAs em fluxo
    por_local: {},       // FFAs agrupadas por local (RECEPCAO, TRIAGEM, etc)
    por_prioridade: [],  // Ordenadas por prioridade (Manchester)
    selecionada: null,   // FFA atual para visualização/edição
  },

  // Evoluções de Enfermagem
  evolucoes: {
    por_internacao: {},  // Histórico por internação
    por_ffa: {},         // Histórico por FFA
  },

  // Fila por local
  filas: {
    recepcao: [],
    triagem: [],
    consultorio: [],
    exame: [],
    medicacao: [],
    internacao: [],
    samu: [],
    farmacia: [],
    ti: [],
    glpi: [],
    manutencao: [],
  },

  // Alertas e notificações
  alertas: {
    criticos: [],        // RED (VERMELHO)
    altos: [],           // ORANGE (LARANJA)
    medios: [],          // YELLOW (AMARELO)
    normais: [],         // GREEN (VERDE)
    baixos: [],          // BLUE (AZUL)
  },

  // UI
  ui: {
    loading: false,
    erro: null,
    modal_ativo: null,
    notificacoes: [],
  },
};

// Ações
const ACOES = {
  // Usuário
  SET_USUARIO: 'SET_USUARIO',
  SET_LOCAL_USUARIO: 'SET_LOCAL_USUARIO',
  LOGOUT: 'LOGOUT',
  
  // FFAs
  CARREGAR_FFAS: 'CARREGAR_FFAS',
  ADICIONAR_FFA: 'ADICIONAR_FFA',
  ATUALIZAR_FFA: 'ATUALIZAR_FFA',
  SELECIONAR_FFA: 'SELECIONAR_FFA',
  MOVER_FFA_PARA_LOCAL: 'MOVER_FFA_PARA_LOCAL',
  FINALIZAR_FFA: 'FINALIZAR_FFA',
  MUDAR_PRIORIDADE_FFA: 'MUDAR_PRIORIDADE_FFA',

  // Evoluções
  CARREGAR_EVOLUCOES: 'CARREGAR_EVOLUCOES',
  ADICIONAR_EVOLUCAO: 'ADICIONAR_EVOLUCAO',
  
  // Filas
  CARREGAR_FILAS: 'CARREGAR_FILAS',
  ATUALIZAR_FILA_LOCAL: 'ATUALIZAR_FILA_LOCAL',
  
  // Alertas
  ADICIONAR_ALERTA: 'ADICIONAR_ALERTA',
  REMOVER_ALERTA: 'REMOVER_ALERTA',
  
  // UI
  SET_LOADING: 'SET_LOADING',
  SET_ERRO: 'SET_ERRO',
  SET_MODAL: 'SET_MODAL',
  ADICIONAR_NOTIFICACAO: 'ADICIONAR_NOTIFICACAO',
};

// Reducer com Immer
function atendimentoReducer(estado, acao) {
  return produce(estado, draft => {
    switch (acao.type) {
      // === Usuário ===
      case ACOES.SET_USUARIO:
        draft.usuario = {
          ...draft.usuario,
          ...acao.payload,
          sessao_ativa: true,
        };
        break;

      case ACOES.SET_LOCAL_USUARIO:
        draft.usuario.local_atual = acao.payload;
        break;

      case ACOES.LOGOUT:
        draft.usuario = ESTADO_INICIAL.usuario;
        draft.ffas.ativas = [];
        draft.filas = ESTADO_INICIAL.filas;
        break;

      // === FFAs ===
      case ACOES.CARREGAR_FFAS:
        draft.ffas.ativas = acao.payload;
        draft.ffas.por_local = agruparFFAsPorLocal(acao.payload);
        draft.ffas.por_prioridade = ordenarFFAsPorPrioridade(acao.payload);
        break;

      case ACOES.ADICIONAR_FFA:
        draft.ffas.ativas.push(acao.payload);
        draft.ffas.por_local = agruparFFAsPorLocal(draft.ffas.ativas);
        break;

      case ACOES.ATUALIZAR_FFA:
        const indexFFA = draft.ffas.ativas.findIndex(f => f.id === acao.payload.id);
        if (indexFFA >= 0) {
          draft.ffas.ativas[indexFFA] = { ...draft.ffas.ativas[indexFFA], ...acao.payload };
          draft.ffas.por_local = agruparFFAsPorLocal(draft.ffas.ativas);
          draft.ffas.por_prioridade = ordenarFFAsPorPrioridade(draft.ffas.ativas);
        }
        break;

      case ACOES.SELECIONAR_FFA:
        draft.ffas.selecionada = acao.payload;
        break;

      case ACOES.MOVER_FFA_PARA_LOCAL:
        const ffa = draft.ffas.ativas.find(f => f.id === acao.payload.id_ffa);
        if (ffa) {
          ffa.status = acao.payload.novo_status;
          ffa.layout = acao.payload.novo_local;
          ffa.atualizado_em = new Date().toISOString();
          draft.ffas.por_local = agruparFFAsPorLocal(draft.ffas.ativas);
        }
        break;

      case ACOES.FINALIZAR_FFA:
        draft.ffas.ativas = draft.ffas.ativas.filter(f => f.id !== acao.payload);
        draft.ffas.por_local = agruparFFAsPorLocal(draft.ffas.ativas);
        break;

      case ACOES.MUDAR_PRIORIDADE_FFA:
        const ffaPrio = draft.ffas.ativas.find(f => f.id === acao.payload.id_ffa);
        if (ffaPrio) {
          ffaPrio.classificacao_cor = acao.payload.nova_cor;
          ffaPrio.tempo_limite = acao.payload.tempo_limite;
          draft.ffas.por_prioridade = ordenarFFAsPorPrioridade(draft.ffas.ativas);
        }
        break;

      // === Evoluções ===
      case ACOES.CARREGAR_EVOLUCOES:
        draft.evolucoes.por_internacao = agruparEvolucoesParInternacao(acao.payload);
        break;

      case ACOES.ADICIONAR_EVOLUCAO:
        const { id_internacao, id_ffa } = acao.payload;
        if (id_internacao) {
          if (!draft.evolucoes.por_internacao[id_internacao]) {
            draft.evolucoes.por_internacao[id_internacao] = [];
          }
          draft.evolucoes.por_internacao[id_internacao].push(acao.payload);
        }
        if (id_ffa) {
          if (!draft.evolucoes.por_ffa[id_ffa]) {
            draft.evolucoes.por_ffa[id_ffa] = [];
          }
          draft.evolucoes.por_ffa[id_ffa].push(acao.payload);
        }
        break;

      // === Filas ===
      case ACOES.CARREGAR_FILAS:
        draft.filas = acao.payload;
        break;

      case ACOES.ATUALIZAR_FILA_LOCAL:
        const { local, pacientes } = acao.payload;
        draft.filas[local] = pacientes;
        break;

      // === Alertas ===
      case ACOES.ADICIONAR_ALERTA:
        const { nivel, ffa_id, mensagem } = acao.payload;
        const alerta = { id: Date.now(), ffa_id, mensagem, criado_em: new Date() };
        draft.alertas[nivel].push(alerta);
        break;

      case ACOES.REMOVER_ALERTA:
        const nivel_remocao = Object.keys(draft.alertas).find(k =>
          draft.alertas[k].some(a => a.id === acao.payload)
        );
        if (nivel_remocao) {
          draft.alertas[nivel_remocao] = draft.alertas[nivel_remocao].filter(
            a => a.id !== acao.payload
          );
        }
        break;

      // === UI ===
      case ACOES.SET_LOADING:
        draft.ui.loading = acao.payload;
        break;

      case ACOES.SET_ERRO:
        draft.ui.erro = acao.payload;
        break;

      case ACOES.SET_MODAL:
        draft.ui.modal_ativo = acao.payload;
        break;

      case ACOES.ADICIONAR_NOTIFICACAO:
        draft.ui.notificacoes.push({
          id: Date.now(),
          ...acao.payload,
        });
        break;

      default:
        break;
    }
  });
}

// Funções helpers
function agruparFFAsPorLocal(ffas) {
  return ffas.reduce((acc, ffa) => {
    const local = ffa.layout || 'RECEPCAO';
    if (!acc[local]) acc[local] = [];
    acc[local].push(ffa);
    return acc;
  }, {});
}

function ordenarFFAsPorPrioridade(ffas) {
  const ordem = { VERMELHO: 1, LARANJA: 2, AMARELO: 3, VERDE: 4, AZUL: 5 };
  return [...ffas].sort((a, b) => {
    const prioA = ordem[a.classificacao_cor] || 6;
    const prioB = ordem[b.classificacao_cor] || 6;
    return prioA - prioB;
  });
}

function agruparEvolucoesParInternacao(evolucoes) {
  return evolucoes.reduce((acc, evo) => {
    if (!acc[evo.id_internacao]) acc[evo.id_internacao] = [];
    acc[evo.id_internacao].push(evo);
    return acc;
  }, {});
}

// Provider
export function AtendimentoProviderV2({ children }) {
  const [estado, dispatch] = useReducer(atendimentoReducer, ESTADO_INICIAL);

  // Ações memoizadas
  const acoesDisponibles = {
    // Usuário
    setUsuario: useCallback((dados) => dispatch({ type: ACOES.SET_USUARIO, payload: dados }), []),
    setLocalUsuario: useCallback((local) => dispatch({ type: ACOES.SET_LOCAL_USUARIO, payload: local }), []),
    logout: useCallback(() => dispatch({ type: ACOES.LOGOUT }), []),

    // FFAs
    carregarFFAs: useCallback((ffas) => dispatch({ type: ACOES.CARREGAR_FFAS, payload: ffas }), []),
    adicionarFFA: useCallback((ffa) => dispatch({ type: ACOES.ADICIONAR_FFA, payload: ffa }), []),
    atualizarFFA: useCallback((ffa) => dispatch({ type: ACOES.ATUALIZAR_FFA, payload: ffa }), []),
    selecionarFFA: useCallback((ffa) => dispatch({ type: ACOES.SELECIONAR_FFA, payload: ffa }), []),
    moverFFAParaLocal: useCallback((dados) => dispatch({ type: ACOES.MOVER_FFA_PARA_LOCAL, payload: dados }), []),
    finalizarFFA: useCallback((id) => dispatch({ type: ACOES.FINALIZAR_FFA, payload: id }), []),
    mudarPrioridadeFFA: useCallback((dados) => dispatch({ type: ACOES.MUDAR_PRIORIDADE_FFA, payload: dados }), []),

    // Evoluções
    carregarEvolucoes: useCallback((evolucoes) => dispatch({ type: ACOES.CARREGAR_EVOLUCOES, payload: evolucoes }), []),
    adicionarEvolucao: useCallback((evo) => dispatch({ type: ACOES.ADICIONAR_EVOLUCAO, payload: evo }), []),

    // Filas
    carregarFilas: useCallback((filas) => dispatch({ type: ACOES.CARREGAR_FILAS, payload: filas }), []),
    atualizarFilaLocal: useCallback((dados) => dispatch({ type: ACOES.ATUALIZAR_FILA_LOCAL, payload: dados }), []),

    // Alertas
    adicionarAlerta: useCallback((dados) => dispatch({ type: ACOES.ADICIONAR_ALERTA, payload: dados }), []),
    removerAlerta: useCallback((id) => dispatch({ type: ACOES.REMOVER_ALERTA, payload: id }), []),

    // UI
    setLoading: useCallback((loading) => dispatch({ type: ACOES.SET_LOADING, payload: loading }), []),
    setErro: useCallback((erro) => dispatch({ type: ACOES.SET_ERRO, payload: erro }), []),
    setModal: useCallback((modal) => dispatch({ type: ACOES.SET_MODAL, payload: modal }), []),
    adicionarNotificacao: useCallback((dados) => dispatch({ type: ACOES.ADICIONAR_NOTIFICACAO, payload: dados }), []),
  };

  const valor = { estado, ...acoesDisponibles };

  return (
    <AtendimentoContextoV2.Provider value={valor}>
      {children}
    </AtendimentoContextoV2.Provider>
  );
}

export default AtendimentoContextoV2;
