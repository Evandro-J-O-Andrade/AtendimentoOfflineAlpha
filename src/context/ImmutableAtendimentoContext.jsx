import React, { createContext, useCallback, useRef, useReducer, useEffect } from 'react';
import {
  StateFactory,
  StateReducers,
  ImmutableArray,
  ImmutableHistory,
  StateValidator,
  deepFreeze,
} from '../store/immutable.store.js';

/**
 * Context Imutável para Atendimento
 * Segue a estrutura do BD: FFA, Fila Operacional, Ordens Assistenciais
 */
export const ImmutableAtendimentoContext = createContext();

const initialState = {
  // Entidades principais
  ffa: null, // Current FFA
  filaOperacional: [], // Queue items
  ordensAssistenciais: [], // Active orders
  sessaoUsuario: null, // Current session

  // Histórico e Auditoria
  history: new ImmutableHistory(),
  eventos: [], // Audit events

  // Controle
  loading: false,
  erro: null,
  lastAction: null,
};

// ============================================
// REDUCER - Redutor Imutável
// ============================================

const immutableReducer = (state, action) => {
  const newState = { ...state };

  try {
    switch (action.type) {
      // ===== FFA =====
      case 'SET_FFA':
        newState.ffa = StateFactory.createFFA(action.payload);
        newState.history.recordSnapshot(action.payload.id, 'FFA', newState.ffa, 'SET_FFA');
        break;

      case 'UPDATE_FFA_STATUS':
        if (newState.ffa) {
          const isValid = StateValidator.validateFFATransition(
            newState.ffa.status,
            action.payload.newStatus
          );
          if (!isValid) {
            throw new Error(
              `Transição inválida: ${newState.ffa.status} -> ${action.payload.newStatus}`
            );
          }
          newState.ffa = StateReducers.updateFFAStatus(
            newState.ffa,
            action.payload.newStatus,
            action.payload.substatus
          );
          newState.history.recordSnapshot(newState.ffa.id, 'FFA', newState.ffa, 'UPDATE_STATUS');
        }
        break;

      case 'UPDATE_FFA_PRIORITY':
        if (newState.ffa) {
          newState.ffa = StateReducers.updateFFAPriority(newState.ffa, action.payload);
          newState.history.recordSnapshot(newState.ffa.id, 'FFA', newState.ffa, 'UPDATE_PRIORITY');
        }
        break;

      case 'ARCHIVE_FFA':
        if (newState.ffa) {
          newState.ffa = StateReducers.archiveFFa(newState.ffa);
          newState.history.recordSnapshot(newState.ffa.id, 'FFA', newState.ffa, 'ARCHIVE');
        }
        break;

      // ===== FILA OPERACIONAL =====
      case 'ADD_QUEUE_ITEM':
        const newQueueItem = StateFactory.createQueueItem(action.payload);
        newState.filaOperacional = ImmutableArray.add(newState.filaOperacional, newQueueItem);
        newState.history.recordEvent({
          tipo: 'QUEUE_ADDED',
          id_fila: newQueueItem.id,
          id_ffa: newQueueItem.id_ffa,
        });
        break;

      case 'CALL_QUEUE_ITEM':
        newState.filaOperacional = ImmutableArray.update(
          newState.filaOperacional,
          action.payload.id,
          StateReducers.callQueueItem(
            newState.filaOperacional.find((q) => q.id === action.payload.id),
            action.payload.userId
          ),
          'id'
        );
        newState.history.recordEvent({
          tipo: 'QUEUE_CALLED',
          id_fila: action.payload.id,
          id_usuario: action.payload.userId,
        });
        break;

      case 'START_QUEUE_ITEM':
        newState.filaOperacional = ImmutableArray.update(
          newState.filaOperacional,
          action.payload.id,
          StateReducers.startQueueItem(
            newState.filaOperacional.find((q) => q.id === action.payload.id),
            action.payload.userId
          ),
          'id'
        );
        newState.history.recordEvent({
          tipo: 'QUEUE_STARTED',
          id_fila: action.payload.id,
          id_usuario: action.payload.userId,
        });
        break;

      case 'FINISH_QUEUE_ITEM':
        const queueItem = newState.filaOperacional.find((q) => q.id === action.payload.id);
        newState.filaOperacional = ImmutableArray.update(
          newState.filaOperacional,
          action.payload.id,
          StateReducers.finishQueueItem(queueItem, action.payload.userId, action.payload.details),
          'id'
        );
        newState.history.recordEvent({
          tipo: 'QUEUE_FINISHED',
          id_fila: action.payload.id,
          id_usuario: action.payload.userId,
        });
        break;

      case 'REMOVE_QUEUE_ITEM':
        newState.filaOperacional = ImmutableArray.remove(
          newState.filaOperacional,
          action.payload,
          'id'
        );
        newState.history.recordEvent({
          tipo: 'QUEUE_REMOVED',
          id_fila: action.payload,
        });
        break;

      // ===== ORDENS ASSISTENCIAIS =====
      case 'ADD_ORDER':
        const newOrder = StateFactory.createOrder(action.payload);
        newState.ordensAssistenciais = ImmutableArray.add(
          newState.ordensAssistenciais,
          newOrder
        );
        newState.history.recordEvent({
          tipo: 'ORDER_CREATED',
          id_ordem: newOrder.id,
          tipo_ordem: newOrder.tipo_ordem,
        });
        break;

      case 'UPDATE_ORDER':
        newState.ordensAssistenciais = ImmutableArray.update(
          newState.ordensAssistenciais,
          action.payload.id,
          {
            ...action.payload.updates,
            atualizado_em: new Date().toISOString(),
          },
          'id'
        );
        break;

      case 'COMPLETE_ORDER':
        const order = newState.ordensAssistenciais.find((o) => o.id === action.payload);
        if (order) {
          newState.ordensAssistenciais = ImmutableArray.replace(
            newState.ordensAssistenciais,
            action.payload,
            StateReducers.completeOrder(order),
            'id'
          );
        }
        break;

      // ===== SESSÃO =====
      case 'SET_SESSION':
        newState.sessaoUsuario = StateFactory.createSession(action.payload);
        break;

      case 'CLOSE_SESSION':
        if (newState.sessaoUsuario) {
          newState.sessaoUsuario = StateReducers.closeSession(newState.sessaoUsuario);
        }
        break;

      // ===== AUDITORIA =====
      case 'ADD_AUDIT_EVENT':
        newState.eventos = ImmutableArray.add(newState.eventos, {
          ...action.payload,
          id: `evt_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
          timestamp: new Date().toISOString(),
        });
        newState.history.recordEvent(action.payload);
        break;

      // ===== ESTADO GERAL =====
      case 'SET_LOADING':
        newState.loading = action.payload;
        break;

      case 'SET_ERROR':
        newState.erro = action.payload;
        break;

      case 'CLEAR_ERROR':
        newState.erro = null;
        break;

      default:
        return state;
    }

    newState.lastAction = action.type;
    return deepFreeze(newState);
  } catch (err) {
    console.error('Reducer Error:', err);
    newState.erro = err.message;
    return deepFreeze(newState);
  }
};

// ============================================
// PROVIDER COMPONENT
// ============================================

export const ImmutableAtendimentoProvider = ({ children }) => {
  const [state, dispatch] = useReducer(immutableReducer, initialState);

  // ===== ACTIONS: FFA =====
  const setFFA = useCallback((ffaData) => {
    dispatch({ type: 'SET_FFA', payload: ffaData });
  }, []);

  const updateFFAStatus = useCallback((newStatus, substatus = null) => {
    dispatch({
      type: 'UPDATE_FFA_STATUS',
      payload: { newStatus, substatus },
    });
  }, []);

  const updateFFAPriority = useCallback((priority) => {
    dispatch({
      type: 'UPDATE_FFA_PRIORITY',
      payload: priority,
    });
  }, []);

  const archiveCurrentFFA = useCallback(() => {
    dispatch({ type: 'ARCHIVE_FFA' });
  }, []);

  // ===== ACTIONS: FILA =====
  const addQueueItem = useCallback((queueData) => {
    dispatch({
      type: 'ADD_QUEUE_ITEM',
      payload: queueData,
    });
  }, []);

  const callQueueItem = useCallback((queueId, userId) => {
    dispatch({
      type: 'CALL_QUEUE_ITEM',
      payload: { id: queueId, userId },
    });
  }, []);

  const startQueueItem = useCallback((queueId, userId) => {
    dispatch({
      type: 'START_QUEUE_ITEM',
      payload: { id: queueId, userId },
    });
  }, []);

  const finishQueueItem = useCallback((queueId, userId, details = {}) => {
    dispatch({
      type: 'FINISH_QUEUE_ITEM',
      payload: { id: queueId, userId, details },
    });
  }, []);

  const removeQueueItem = useCallback((queueId) => {
    dispatch({
      type: 'REMOVE_QUEUE_ITEM',
      payload: queueId,
    });
  }, []);

  // ===== ACTIONS: ORDENS =====
  const addOrder = useCallback((orderData) => {
    dispatch({
      type: 'ADD_ORDER',
      payload: orderData,
    });
  }, []);

  const updateOrder = useCallback((orderId, updates) => {
    dispatch({
      type: 'UPDATE_ORDER',
      payload: { id: orderId, updates },
    });
  }, []);

  const completeOrder = useCallback((orderId) => {
    dispatch({
      type: 'COMPLETE_ORDER',
      payload: orderId,
    });
  }, []);

  // ===== ACTIONS: SESSION =====
  const setSession = useCallback((sessionData) => {
    dispatch({
      type: 'SET_SESSION',
      payload: sessionData,
    });
  }, []);

  const closeSession = useCallback(() => {
    dispatch({ type: 'CLOSE_SESSION' });
  }, []);

  // ===== ACTIONS: AUDITORIA =====
  const addAuditEvent = useCallback((event) => {
    dispatch({
      type: 'ADD_AUDIT_EVENT',
      payload: event,
    });
  }, []);

  // ===== ACTIONS: ESTADO GERAL =====
  const setLoading = useCallback((loading) => {
    dispatch({
      type: 'SET_LOADING',
      payload: loading,
    });
  }, []);

  const setError = useCallback((error) => {
    dispatch({
      type: 'SET_ERROR',
      payload: error,
    });
  }, []);

  const clearError = useCallback(() => {
    dispatch({ type: 'CLEAR_ERROR' });
  }, []);

  // ===== HELPERS =====
  const getFFAHistory = useCallback((ffaId) => {
    return state.history.getHistory(ffaId);
  }, [state.history]);

  const getAuditEvents = useCallback((filter = {}) => {
    return state.history.getEvents(filter);
  }, [state.history]);

  const value = {
    // State
    state,
    ffa: state.ffa,
    filaOperacional: state.filaOperacional,
    ordensAssistenciais: state.ordensAssistenciais,
    sessaoUsuario: state.sessaoUsuario,
    loading: state.loading,
    erro: state.erro,
    eventos: state.eventos,

    // FFA Actions
    setFFA,
    updateFFAStatus,
    updateFFAPriority,
    archiveCurrentFFA,

    // Queue Actions
    addQueueItem,
    callQueueItem,
    startQueueItem,
    finishQueueItem,
    removeQueueItem,

    // Order Actions
    addOrder,
    updateOrder,
    completeOrder,

    // Session Actions
    setSession,
    closeSession,

    // Audit Actions
    addAuditEvent,

    // General Actions
    setLoading,
    setError,
    clearError,

    // Helpers
    getFFAHistory,
    getAuditEvents,
  };

  return (
    <ImmutableAtendimentoContext.Provider value={value}>
      {children}
    </ImmutableAtendimentoContext.Provider>
  );
};

export default ImmutableAtendimentoContext;
