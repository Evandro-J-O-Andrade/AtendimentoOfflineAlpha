import { useContext, useCallback, useMemo } from 'react';
import ImmutableAtendimentoContext from '../../context/ImmutableAtendimentoContext.jsx';
import { api } from './api.js';

/**
 * Hook: useImmutableAtendimento
 * Acesso ao contexto imutável com validações
 */
export const useImmutableAtendimento = () => {
  const context = useContext(ImmutableAtendimentoContext);

  if (!context) {
    throw new Error('useImmutableAtendimento deve ser usado dentro de ImmutableAtendimentoProvider');
  }

  return context;
};

/**
 * Hook: useFFAFlow
 * Gerencia o fluxo completo de uma FFA (desde criação até arquivamento)
 */
export const useFFAFlow = () => {
  const {
    ffa,
    setFFA,
    updateFFAStatus,
    updateFFAPriority,
    archiveCurrentFFA,
    addAuditEvent,
    setLoading,
    setError,
  } = useImmutableAtendimento();

  // Iniciar novo atendimento
  const iniciarAtendimento = useCallback(
    async (pacienteId, especialidadeId) => {
      setLoading(true);
      try {
        const response = await api.post('/atendimento/abrir', {
          id_pessoa: pacienteId,
          id_especialidade: especialidadeId,
        });

        setFFA(response.data);

        addAuditEvent({
          entidade: 'FFA',
          id_entidade: response.data.id,
          acao: 'CRIACAO',
          detalhe: `Novo atendimento aberto para paciente ${pacienteId}`,
        });

        return response.data;
      } catch (err) {
        setError(err.message);
        throw err;
      } finally {
        setLoading(false);
      }
    },
    [setFFA, addAuditEvent, setLoading, setError]
  );

  // Mudar status
  const mudarStatus = useCallback(
    async (novoStatus, substatus = null) => {
      try {
        if (!ffa) throw new Error('Nenhuma FFA selecionada');

        const response = await api.post('/atendimento/status', {
          id_ffa: ffa.id,
          status: novoStatus,
          substatus,
        });

        updateFFAStatus(novoStatus, substatus);

        addAuditEvent({
          entidade: 'FFA',
          id_entidade: ffa.id,
          acao: 'MUDANCA_STATUS',
          antes: ffa.status,
          depois: novoStatus,
          detalhe: `Status alterado para ${novoStatus}. Substatus: ${substatus || 'N/A'}`,
        });

        return response.data;
      } catch (err) {
        setError(err.message);
        throw err;
      }
    },
    [ffa, updateFFAStatus, addAuditEvent, setError]
  );

  // Alterar prioridade
  const alterarPrioridade = useCallback(
    async (novaPrioridade) => {
      try {
        if (!ffa) throw new Error('Nenhuma FFA selecionada');

        const response = await api.post('/atendimento/prioridade', {
          id_ffa: ffa.id,
          prioridade: novaPrioridade,
        });

        updateFFAPriority(novaPrioridade);

        addAuditEvent({
          entidade: 'FFA',
          id_entidade: ffa.id,
          acao: 'MUDANCA_PRIORIDADE',
          antes: ffa.prioridade,
          depois: novaPrioridade,
        });

        return response.data;
      } catch (err) {
        setError(err.message);
        throw err;
      }
    },
    [ffa, updateFFAPriority, addAuditEvent, setError]
  );

  // Finalizar atendimento
  const finalizarAtendimento = useCallback(
    async (detalhe = '') => {
      try {
        if (!ffa) throw new Error('Nenhuma FFA selecionada');

        const response = await api.post('/atendimento/finalizar', {
          id_ffa: ffa.id,
          detalhe,
        });

        updateFFAStatus('FINALIZADO');
        archiveCurrentFFA();

        addAuditEvent({
          entidade: 'FFA',
          id_entidade: ffa.id,
          acao: 'FINALIZACAO',
          detalhe: detalhe || 'Atendimento finalizado',
        });

        return response.data;
      } catch (err) {
        setError(err.message);
        throw err;
      }
    },
    [ffa, updateFFAStatus, archiveCurrentFFA, addAuditEvent, setError]
  );

  return {
    ffa,
    iniciarAtendimento,
    mudarStatus,
    alterarPrioridade,
    finalizarAtendimento,
  };
};

/**
 * Hook: useQueueManagement
 * Gerencia filas operacionais
 */
export const useQueueManagement = () => {
  const {
    filaOperacional,
    addQueueItem,
    callQueueItem,
    startQueueItem,
    finishQueueItem,
    removeQueueItem,
    addAuditEvent,
    setLoading,
    setError,
  } = useImmutableAtendimento();

  // Chamar senha
  const chamarSenha = useCallback(
    async (filaSenhaId, userId) => {
      setLoading(true);
      try {
        const response = await api.post('/fila/chamar', {
          id_fila_senha: filaSenhaId,
          id_usuario: userId,
        });

        callQueueItem(filaSenhaId, userId);

        addAuditEvent({
          entidade: 'FILA_OPERACIONAL',
          id_entidade: filaSenhaId,
          acao: 'CHAMADA',
          detalhe: `Senha chamada pelo usuário ${userId}`,
        });

        return response.data;
      } catch (err) {
        setError(err.message);
        throw err;
      } finally {
        setLoading(false);
      }
    },
    [callQueueItem, addAuditEvent, setLoading, setError]
  );

  // Iniciar atendimento na fila
  const iniciarFila = useCallback(
    async (filaId, userId) => {
      try {
        const response = await api.post('/fila/iniciar', {
          id_fila_operacional: filaId,
          id_usuario: userId,
        });

        startQueueItem(filaId, userId);

        addAuditEvent({
          entidade: 'FILA_OPERACIONAL',
          id_entidade: filaId,
          acao: 'INICIO_ATENDIMENTO',
          detalhe: `Atendimento iniciado pelo usuário ${userId}`,
        });

        return response.data;
      } catch (err) {
        setError(err.message);
        throw err;
      }
    },
    [startQueueItem, addAuditEvent, setError]
  );

  // Finalizar fila
  const finalizarFila = useCallback(
    async (filaId, userId, detalhe = '') => {
      try {
        const response = await api.post('/fila/finalizar', {
          id_fila_operacional: filaId,
          id_usuario: userId,
          detalhe,
        });

        finishQueueItem(filaId, userId, { status: 'FINALIZADO' });

        addAuditEvent({
          entidade: 'FILA_OPERACIONAL',
          id_entidade: filaId,
          acao: 'FINALIZACAO',
          detalhe: detalhe || 'Fila finalizada',
        });

        return response.data;
      } catch (err) {
        setError(err.message);
        throw err;
      }
    },
    [finishQueueItem, addAuditEvent, setError]
  );

  // Marcar como não compareceu
  const naoCompareceu = useCallback(
    async (filaId, userId, motivo = '') => {
      try {
        const response = await api.post('/fila/nao-compareceu', {
          id_fila_operacional: filaId,
          id_usuario: userId,
          motivo,
        });

        finishQueueItem(filaId, userId, { status: 'NAO_COMPARECEU' });

        addAuditEvent({
          entidade: 'FILA_OPERACIONAL',
          id_entidade: filaId,
          acao: 'NAO_COMPARECIMENTO',
          detalhe: motivo || 'Paciente não compareceu',
        });

        return response.data;
      } catch (err) {
        setError(err.message);
        throw err;
      }
    },
    [finishQueueItem, addAuditEvent, setError]
  );

  return {
    filaOperacional: useMemo(() => filaOperacional, [filaOperacional]),
    chamarSenha,
    iniciarFila,
    finalizarFila,
    naoCompareceu,
  };
};

/**
 * Hook: useOrderManagement
 * Gerencia ordens assistenciais
 */
export const useOrderManagement = () => {
  const {
    ordensAssistenciais,
    addOrder,
    updateOrder,
    completeOrder,
    addAuditEvent,
    setLoading,
    setError,
  } = useImmutableAtendimento();

  // Criar ordem
  const criarOrdem = useCallback(
    async (ffaId, tipoOrdem, payloadClinico, prioridade = 'NORMAL') => {
      setLoading(true);
      try {
        const response = await api.post('/ordem/criar', {
          id_ffa: ffaId,
          tipo_ordem: tipoOrdem,
          payload_clinico: payloadClinico,
          prioridade,
        });

        addOrder({
          id: response.data.id,
          id_ffa: ffaId,
          tipo_ordem: tipoOrdem,
          payload_clinico: payloadClinico,
          prioridade,
          status: 'ATIVA',
        });

        addAuditEvent({
          entidade: 'ORDEM_ASSISTENCIAL',
          id_entidade: response.data.id,
          acao: 'CRIACAO',
          detalhe: `Ordem ${tipoOrdem} criada para FFA ${ffaId}`,
        });

        return response.data;
      } catch (err) {
        setError(err.message);
        throw err;
      } finally {
        setLoading(false);
      }
    },
    [addOrder, addAuditEvent, setLoading, setError]
  );

  // Atualizar ordem
  const atualizarOrdem = useCallback(
    async (orderId, updates) => {
      try {
        const response = await api.put(`/ordem/${orderId}`, updates);

        updateOrder(orderId, updates);

        addAuditEvent({
          entidade: 'ORDEM_ASSISTENCIAL',
          id_entidade: orderId,
          acao: 'ATUALIZACAO',
          detalhe: JSON.stringify(updates),
        });

        return response.data;
      } catch (err) {
        setError(err.message);
        throw err;
      }
    },
    [updateOrder, addAuditEvent, setError]
  );

  // Concluir ordem
  const concluirOrdem = useCallback(
    async (orderId) => {
      try {
        const response = await api.post(`/ordem/${orderId}/concluir`);

        completeOrder(orderId);

        addAuditEvent({
          entidade: 'ORDEM_ASSISTENCIAL',
          id_entidade: orderId,
          acao: 'CONCLUSAO',
          detalhe: 'Ordem finalizada',
        });

        return response.data;
      } catch (err) {
        setError(err.message);
        throw err;
      }
    },
    [completeOrder, addAuditEvent, setError]
  );

  return {
    ordensAssistenciais: useMemo(() => ordensAssistenciais, [ordensAssistenciais]),
    criarOrdem,
    atualizarOrdem,
    concluirOrdem,
  };
};

/**
 * Hook: useAuditTrail
 * Acesso ao histórico e auditoria
 */
export const useAuditTrail = () => {
  const { getFFAHistory, getAuditEvents, eventos } = useImmutableAtendimento();

  return {
    eventos: useMemo(() => eventos, [eventos]),
    getFFAHistory,
    getAuditEvents,
  };
};

export default {
  useImmutableAtendimento,
  useFFAFlow,
  useQueueManagement,
  useOrderManagement,
  useAuditTrail,
};
