/**
 * STORE IMUTÁVEL - Padrão Imutável seguindo lógica do BD
 * 
 * Princípios:
 * 1. Nunca mutar estado diretamente
 * 2. Todas operações retornam novo estado
 * 3. Histórico completo de auditoria
 * 4. Consistência com fluxo operacional do BD
 */

// ============================================
// STATE FACTORY - Criadores de Estado Imutável
// ============================================

export const createImmutableState = (initial = {}) => {
  return Object.freeze({ ...initial });
};

export const StateFactory = {
  // ===== FFA (Ficha de Fila Assistencial) =====
  createFFA: (data = {}) => Object.freeze({
    id: data.id || null,
    id_paciente: data.id_paciente || null,
    protocolo: data.protocolo || '',
    status: data.status || 'ABERTO',
    substatus: data.substatus || null,
    prioridade: data.prioridade || 'NORMAL',
    classificacao_manchester: data.classificacao_manchester || null,
    criado_em: data.criado_em || new Date().toISOString(),
    atualizado_em: data.atualizado_em || new Date().toISOString(),
    encerrado_em: data.encerrado_em || null,
    ativo: data.ativo !== false,
  }),

  // ===== FILA OPERACIONAL =====
  createQueueItem: (data = {}) => Object.freeze({
    id: data.id || null,
    id_ffa: data.id_ffa || null,
    tipo_evento: data.tipo_evento || 'PROCESSAMENTO',
    contexto: data.contexto || 'PADRAO',
    status: data.status || 'AGUARDANDO',
    prioridade: data.prioridade || 5,
    id_usuario_chamada: data.id_usuario_chamada || null,
    chamado_em: data.chamado_em || null,
    id_usuario_inicio: data.id_usuario_inicio || null,
    iniciado_em: data.iniciado_em || null,
    id_usuario_fim: data.id_usuario_fim || null,
    finalizado_em: data.finalizado_em || null,
    criado_em: data.criado_em || new Date().toISOString(),
  }),

  // ===== ORDEM ASSISTENCIAL =====
  createOrder: (data = {}) => Object.freeze({
    id: data.id || null,
    id_ffa: data.id_ffa || null,
    tipo_ordem: data.tipo_ordem || 'MEDICACAO',
    status: data.status || 'ATIVA',
    prioridade: data.prioridade || 'NORMAL',
    payload_clinico: data.payload_clinico || {},
    criado_por: data.criado_por || null,
    iniciado_em: data.iniciado_em || null,
    encerrado_em: data.encerrado_em || null,
  }),

  // ===== SESSÃO USUÁRIO =====
  createSession: (data = {}) => Object.freeze({
    id_sessao_usuario: data.id_sessao_usuario || null,
    id_usuario: data.id_usuario || null,
    id_sistema: data.id_sistema || null,
    id_unidade: data.id_unidade || null,
    id_local_operacional: data.id_local_operacional || null,
    id_perfil: data.id_perfil || null,
    ip: data.ip || null,
    user_agent: data.user_agent || null,
    iniciado_em: data.iniciado_em || new Date().toISOString(),
    encerrado_em: data.encerrado_em || null,
    ativo: data.ativo !== false,
  }),

  // ===== EVENTO AUDITORIA =====
  createAuditEvent: (data = {}) => Object.freeze({
    id: data.id || null,
    id_sessao_usuario: data.id_sessao_usuario || null,
    entidade: data.entidade || 'GENERICO',
    id_entidade: data.id_entidade || null,
    acao: data.acao || 'MODIFICACAO',
    detalhe: data.detalhe || '',
    antes: data.antes || null,
    depois: data.depois || null,
    criado_em: data.criado_em || new Date().toISOString(),
  }),
};

// ============================================
// REDUCERS - Modificadores de Estado Imutável
// ============================================

export const StateReducers = {
  // FFA Reducers
  updateFFAStatus: (ffa, newStatus, substatus = null) => ({
    ...ffa,
    status: newStatus,
    substatus: substatus || ffa.substatus,
    atualizado_em: new Date().toISOString(),
  }),

  updateFFAPriority: (ffa, priority) => ({
    ...ffa,
    prioridade: priority,
    atualizado_em: new Date().toISOString(),
  }),

  archiveFFa: (ffa) => ({
    ...ffa,
    ativo: false,
    encerrado_em: new Date().toISOString(),
    atualizado_em: new Date().toISOString(),
  }),

  // Queue Reducers
  callQueueItem: (item, userId) => ({
    ...item,
    status: 'CHAMANDO',
    id_usuario_chamada: userId,
    chamado_em: new Date().toISOString(),
  }),

  startQueueItem: (item, userId) => ({
    ...item,
    status: 'EM_EXECUCAO',
    id_usuario_inicio: userId,
    iniciado_em: new Date().toISOString(),
  }),

  finishQueueItem: (item, userId, details = {}) => ({
    ...item,
    status: details.status || 'FINALIZADO',
    id_usuario_fim: userId,
    finalizado_em: new Date().toISOString(),
  }),

  // Order Reducers
  startOrder: (order) => ({
    ...order,
    status: 'INICIADA',
    iniciado_em: new Date().toISOString(),
  }),

  completeOrder: (order) => ({
    ...order,
    status: 'CONCLUIDA',
    encerrado_em: new Date().toISOString(),
  }),

  suspendOrder: (order) => ({
    ...order,
    status: 'SUSPENSA',
    encerrado_em: new Date().toISOString(),
  }),

  // Session Reducers
  closeSession: (session) => ({
    ...session,
    ativo: false,
    encerrado_em: new Date().toISOString(),
  }),
};

// ============================================
// IMMUTABLE ARRAY OPERATIONS
// ============================================

export const ImmutableArray = {
  add: (arr, item) => [...arr, item],
  remove: (arr, id, idField = 'id') => arr.filter((item) => item[idField] !== id),
  update: (arr, id, updatedItem, idField = 'id') =>
    arr.map((item) => (item[idField] === id ? { ...item, ...updatedItem } : item)),
  replace: (arr, id, newItem, idField = 'id') =>
    arr.map((item) => (item[idField] === id ? newItem : item)),
};

// ============================================
// IMMUTABLE OBJECT OPERATIONS
// ============================================

export const ImmutableObject = {
  set: (obj, path, value) => {
    const keys = path.split('.');
    let current = { ...obj };
    let ref = current;

    for (let i = 0; i < keys.length - 1; i++) {
      ref[keys[i]] = { ...ref[keys[i]] };
      ref = ref[keys[i]];
    }

    ref[keys[keys.length - 1]] = value;
    return Object.freeze(current);
  },

  get: (obj, path, defaultValue = undefined) => {
    return path.split('.').reduce((acc, part) => acc?.[part], obj) ?? defaultValue;
  },

  merge: (obj, updates) => Object.freeze({ ...obj, ...updates }),
};

// ============================================
// OPERATION HISTORY - Rastreamento de Mudanças
// ============================================

export class ImmutableHistory {
  constructor() {
    this.events = [];
    this.snapshots = [];
  }

  recordEvent(event) {
    const timestampedEvent = {
      ...event,
      timestamp: new Date().toISOString(),
      id: `evt_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
    };
    this.events = [...this.events, timestampedEvent];
    return this;
  }

  recordSnapshot(entityId, entityType, state, action) {
    const snapshot = {
      id: `snap_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      entityId,
      entityType,
      state: Object.freeze({ ...state }),
      action,
      timestamp: new Date().toISOString(),
    };
    this.snapshots = [...this.snapshots, snapshot];
    return this;
  }

  getHistory(entityId) {
    return this.snapshots.filter((snap) => snap.entityId === entityId);
  }

  getEvents(filter = {}) {
    return this.events.filter((evt) => {
      return Object.entries(filter).every(([key, value]) => evt[key] === value);
    });
  }

  rollback(entityId, steps = 1) {
    const history = this.getHistory(entityId);
    if (history.length <= steps) return null;
    return history[history.length - steps - 1].state;
  }
}

// ============================================
// VALIDATION HELPERS
// ============================================

export const StateValidator = {
  validateFFATransition: (currentStatus, newStatus) => {
    const validTransitions = {
      ABERTO: ['EM_ATENDIMENTO', 'CANCELADO'],
      EM_ATENDIMENTO: ['EM_OBSERVACAO', 'INTERNADO', 'FINALIZADO'],
      EM_OBSERVACAO: ['INTERNADO', 'FINALIZADO'],
      INTERNADO: ['FINALIZADO', 'ALTA'],
      FINALIZADO: [],
    };
    return validTransitions[currentStatus]?.includes(newStatus) ?? false;
  },

  validateQueueTransition: (currentStatus, newStatus) => {
    const validTransitions = {
      AGUARDANDO: ['CHAMANDO', 'CANCELADO'],
      CHAMANDO: ['EM_EXECUCAO', 'NAO_COMPARECEU'],
      EM_EXECUCAO: ['FINALIZADO', 'EM_OBSERVACAO'],
      EM_OBSERVACAO: ['FINALIZADO'],
      FINALIZADO: [],
    };
    return validTransitions[currentStatus]?.includes(newStatus) ?? false;
  },
};

// ============================================
// DEEP FREEZE - Garantir Imutabilidade Total
// ============================================

export const deepFreeze = (obj) => {
  if (obj === null || typeof obj !== 'object') return obj;

  Object.freeze(obj);

  Object.getOwnPropertyNames(obj).forEach((prop) => {
    if (obj[prop] !== null && (typeof obj[prop] === 'object' || typeof obj[prop] === 'function')) {
      deepFreeze(obj[prop]);
    }
  });

  return obj;
};

export default {
  StateFactory,
  StateReducers,
  ImmutableArray,
  ImmutableObject,
  ImmutableHistory,
  StateValidator,
  createImmutableState,
  deepFreeze,
};
