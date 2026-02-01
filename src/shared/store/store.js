/**
 * STORE - Estado Imutável da Aplicação
 * 
 * Estrutura alinhada com BD:
 * - FFA: Ficha de Fila Assistencial
 * - FilaOperacional: Fila de processamento
 * - OrdemAssistencial: Ordens médicas/enfermagem
 * - Sessão: Contexto de usuário
 * - Auditoria: Rastreamento de mudanças
 */

// ============================================
// ENTIDADES - Factories para criar objetos imutáveis
// ============================================

export const EntidadeFactory = {
  // FFA: Ficha de Fila Assistencial
  ffa: (dados = {}) => Object.freeze({
    id: dados.id || null,
    protocolo: dados.protocolo || '',
    id_paciente: dados.id_paciente || null,
    id_unidade: dados.id_unidade || null,
    id_local: dados.id_local || null,
    status: dados.status || 'ABERTO',
    substatus: dados.substatus || null,
    prioridade: dados.prioridade || 'NORMAL',
    classificacao_manchester: dados.classificacao_manchester || null,
    criado_em: dados.criado_em || new Date().toISOString(),
    atualizado_em: dados.atualizado_em || new Date().toISOString(),
    encerrado_em: dados.encerrado_em || null,
    ativo: dados.ativo !== false,
  }),

  // Fila Operacional
  fila: (dados = {}) => Object.freeze({
    id: dados.id || null,
    id_ffa: dados.id_ffa || null,
    id_local: dados.id_local || null,
    tipo_evento: dados.tipo_evento || 'ATENDIMENTO',
    status: dados.status || 'AGUARDANDO',
    prioridade: dados.prioridade || 5,
    chamado_em: dados.chamado_em || null,
    iniciado_em: dados.iniciado_em || null,
    finalizado_em: dados.finalizado_em || null,
    id_usuario: dados.id_usuario || null,
    criado_em: dados.criado_em || new Date().toISOString(),
  }),

  // Ordem Assistencial (Médica, Enfermagem, etc)
  ordem: (dados = {}) => Object.freeze({
    id: dados.id || null,
    id_ffa: dados.id_ffa || null,
    tipo: dados.tipo || 'MEDICACAO', // MEDICACAO, CUIDADO, DIETA, etc
    status: dados.status || 'ATIVA',
    prioridade: dados.prioridade || 'NORMAL',
    payload: dados.payload || {},
    criado_por: dados.criado_por || null,
    iniciado_em: dados.iniciado_em || null,
    encerrado_em: dados.encerrado_em || null,
    criado_em: dados.criado_em || new Date().toISOString(),
  }),

  // Sessão de Usuário
  sessao: (dados = {}) => Object.freeze({
    id_sessao: dados.id_sessao || null,
    id_usuario: dados.id_usuario || null,
    id_sistema: dados.id_sistema || null,
    id_unidade: dados.id_unidade || null,
    id_local: dados.id_local || null,
    id_perfil: dados.id_perfil || null,
    ip: dados.ip || null,
    user_agent: dados.user_agent || null,
    iniciado_em: dados.iniciado_em || new Date().toISOString(),
    encerrado_em: dados.encerrado_em || null,
    ativo: dados.ativo !== false,
  }),

  // Evento de Auditoria
  evento: (dados = {}) => Object.freeze({
    id: dados.id || null,
    id_sessao: dados.id_sessao || null,
    entidade: dados.entidade || 'FFA',
    id_entidade: dados.id_entidade || null,
    acao: dados.acao || 'MODIFICACAO',
    antes: dados.antes || null,
    depois: dados.depois || null,
    detalhes: dados.detalhes || '',
    criado_em: dados.criado_em || new Date().toISOString(),
  }),
};

// ============================================
// OPERAÇÕES - Funções para modificar estado imutavelmente
// ============================================

export const Operacoes = {
  // FFA
  alterarStatusFFA: (ffa, novoStatus, substatus = null) => ({
    ...ffa,
    status: novoStatus,
    substatus: substatus || ffa.substatus,
    atualizado_em: new Date().toISOString(),
  }),

  alterarPrioridadeFFA: (ffa, prioridade) => ({
    ...ffa,
    prioridade,
    atualizado_em: new Date().toISOString(),
  }),

  finalizarFFA: (ffa) => ({
    ...ffa,
    ativo: false,
    encerrado_em: new Date().toISOString(),
    atualizado_em: new Date().toISOString(),
  }),

  // Fila
  chamarFilaItem: (item, idUsuario) => ({
    ...item,
    status: 'CHAMANDO',
    id_usuario: idUsuario,
    chamado_em: new Date().toISOString(),
  }),

  iniciarFilaItem: (item, idUsuario) => ({
    ...item,
    status: 'EM_EXECUCAO',
    id_usuario: idUsuario,
    iniciado_em: new Date().toISOString(),
  }),

  finalizarFilaItem: (item, idUsuario) => ({
    ...item,
    status: 'FINALIZADO',
    finalizado_em: new Date().toISOString(),
  }),

  // Ordem
  iniciarOrdem: (ordem) => ({
    ...ordem,
    status: 'INICIADA',
    iniciado_em: new Date().toISOString(),
  }),

  concluirOrdem: (ordem) => ({
    ...ordem,
    status: 'CONCLUIDA',
    encerrado_em: new Date().toISOString(),
  }),

  // Sessão
  encerrarSessao: (sessao) => ({
    ...sessao,
    ativo: false,
    encerrado_em: new Date().toISOString(),
  }),
};

// ============================================
// COLEÇÕES - Operações com arrays imutavelmente
// ============================================

export const Colecoes = {
  adicionar: (arr, item) => [...arr, item],

  remover: (arr, id, campo = 'id') => arr.filter((item) => item[campo] !== id),

  atualizar: (arr, id, novosDados, campo = 'id') =>
    arr.map((item) => (item[campo] === id ? { ...item, ...novosDados } : item)),

  substituir: (arr, id, novoItem, campo = 'id') =>
    arr.map((item) => (item[campo] === id ? novoItem : item)),

  filtrar: (arr, predicado) => arr.filter(predicado),

  mapear: (arr, transformacao) => arr.map(transformacao),
};

// ============================================
// VALIDAÇÕES - Regras de transição
// ============================================

export const Validacoes = {
  transicaoFFAValida: (statusAtual, novoStatus) => {
    const transicoes = {
      ABERTO: ['EM_ATENDIMENTO', 'CANCELADO'],
      EM_ATENDIMENTO: ['EM_OBSERVACAO', 'INTERNADO', 'FINALIZADO'],
      EM_OBSERVACAO: ['INTERNADO', 'FINALIZADO'],
      INTERNADO: ['FINALIZADO', 'ALTA'],
      FINALIZADO: [],
    };
    return transicoes[statusAtual]?.includes(novoStatus) ?? false;
  },

  transicaoFilaValida: (statusAtual, novoStatus) => {
    const transicoes = {
      AGUARDANDO: ['CHAMANDO', 'CANCELADO'],
      CHAMANDO: ['EM_EXECUCAO', 'NAO_COMPARECEU'],
      EM_EXECUCAO: ['FINALIZADO', 'EM_OBSERVACAO'],
      EM_OBSERVACAO: ['FINALIZADO'],
      FINALIZADO: [],
    };
    return transicoes[statusAtual]?.includes(novoStatus) ?? false;
  },
};

// ============================================
// HISTÓRICO - Rastreamento de mudanças
// ============================================

export class Historico {
  constructor() {
    this.eventos = [];
    this.snapshots = [];
  }

  registrarEvento(evento) {
    this.eventos = [
      ...this.eventos,
      {
        ...evento,
        id: `evt_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
        timestamp: new Date().toISOString(),
      },
    ];
  }

  registrarSnapshot(idEntidade, tipo, estado, acao) {
    this.snapshots = [
      ...this.snapshots,
      {
        id: `snap_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
        idEntidade,
        tipo,
        estado: Object.freeze({ ...estado }),
        acao,
        timestamp: new Date().toISOString(),
      },
    ];
  }

  obterHistorico(idEntidade) {
    return this.snapshots.filter((snap) => snap.idEntidade === idEntidade);
  }

  obterEventos(filtro = {}) {
    return this.eventos.filter((evt) => {
      return Object.entries(filtro).every(([chave, valor]) => evt[chave] === valor);
    });
  }

  reverter(idEntidade, passos = 1) {
    const historico = this.obterHistorico(idEntidade);
    if (historico.length <= passos) return null;
    return historico[historico.length - passos - 1].estado;
  }
}

// ============================================
// HELPERS
// ============================================

export const congelarProfundamente = (obj) => {
  if (obj === null || typeof obj !== 'object') return obj;

  Object.freeze(obj);

  Object.getOwnPropertyNames(obj).forEach((prop) => {
    if (obj[prop] !== null && (typeof obj[prop] === 'object' || typeof obj[prop] === 'function')) {
      congelarProfundamente(obj[prop]);
    }
  });

  return obj;
};

export default {
  EntidadeFactory,
  Operacoes,
  Colecoes,
  Validacoes,
  Historico,
  congelarProfundamente,
};
