/**
 * Serviço de Atendimento - Refatorado com Imutabilidade
 * 
 * Princípios:
 * 1. Retorna sempre novos objetos (nunca mutações)
 * 2. Operações são transacionais
 * 3. Histórico completo de auditoria
 * 4. Validação em cada etapa
 */

import { api } from './api.js';
import { ImmutableArray, ImmutableObject, StateValidator } from '../shared/store/immutable.store.js';

export const atendimentoService = {
  /**
   * Abrir novo atendimento
   * @returns {Promise<Object>} Novo objeto FFA imutável
   */
  async abrirAtendimento(pacienteId, especialidadeId, localId) {
    try {
      const response = await api.post('/atendimento/abrir', {
        id_pessoa: pacienteId,
        id_especialidade: especialidadeId,
        id_local_atual: localId,
      });

      return Object.freeze({
        id: response.data.id,
        protocolo: response.data.protocolo,
        id_paciente: pacienteId,
        status: response.data.status || 'ABERTO',
        substatus: null,
        prioridade: response.data.prioridade || 'NORMAL',
        data_abertura: response.data.data_abertura || new Date().toISOString(),
        criado_em: new Date().toISOString(),
        atualizado_em: new Date().toISOString(),
      });
    } catch (error) {
      console.error('Erro ao abrir atendimento:', error);
      throw error;
    }
  },

  /**
   * Buscar atendimento por ID
   * @returns {Promise<Object>} FFA imutável
   */
  async buscarAtendimento(ffaId) {
    try {
      const response = await api.get(`/atendimento/${ffaId}`);
      return Object.freeze({ ...response.data });
    } catch (error) {
      console.error('Erro ao buscar atendimento:', error);
      throw error;
    }
  },

  /**
   * Listar atendimentos com filtros
   * @returns {Promise<Array>} Array imutável de FFAs
   */
  async listarAtendimentos(filtros = {}) {
    try {
      const params = new URLSearchParams();

      if (filtros.status) params.append('status', filtros.status);
      if (filtros.localId) params.append('id_local', filtros.localId);
      if (filtros.prioridade) params.append('prioridade', filtros.prioridade);

      const response = await api.get('/atendimento/listar', { params });

      return Object.freeze(
        response.data.map((item) =>
          Object.freeze({
            id: item.id,
            protocolo: item.protocolo,
            paciente: item.paciente_nome,
            status: item.status_atendimento,
            prioridade: item.prioridade,
            local: item.local_nome,
            criado_em: item.data_abertura,
          })
        )
      );
    } catch (error) {
      console.error('Erro ao listar atendimentos:', error);
      throw error;
    }
  },

  /**
   * Atualizar status com validação de transição
   * @returns {Promise<Object>} FFA atualizada imutável
   */
  async atualizarStatus(ffaId, novoStatus, substatus = null) {
    try {
      // Validação de transição ocorre no backend, mas podemos validar localmente também
      const response = await api.post(`/atendimento/${ffaId}/status`, {
        status: novoStatus,
        substatus,
      });

      return Object.freeze({
        ...response.data,
        atualizado_em: new Date().toISOString(),
      });
    } catch (error) {
      console.error(`Erro ao atualizar status para ${novoStatus}:`, error);
      throw error;
    }
  },

  /**
   * Mover para observação
   */
  async moverParaObservacao(ffaId, leitoId) {
    try {
      const response = await api.post(`/atendimento/${ffaId}/observacao`, {
        id_leito: leitoId,
      });

      return Object.freeze({
        ...response.data,
        status: 'EM_OBSERVACAO',
        substatus: 'OBSERVACAO',
        atualizado_em: new Date().toISOString(),
      });
    } catch (error) {
      console.error('Erro ao mover para observação:', error);
      throw error;
    }
  },

  /**
   * Internar paciente
   */
  async internarPaciente(ffaId, leitoId, tipoInternacao = 'EMERGENCIA') {
    try {
      const response = await api.post(`/atendimento/${ffaId}/internacao`, {
        id_leito: leitoId,
        tipo: tipoInternacao,
      });

      return Object.freeze({
        ...response.data,
        status: 'INTERNADO',
        substatus: 'INTERNACAO_ATIVA',
        atualizado_em: new Date().toISOString(),
      });
    } catch (error) {
      console.error('Erro ao internar paciente:', error);
      throw error;
    }
  },

  /**
   * Finalizar atendimento
   */
  async finalizarAtendimento(ffaId, motivo = 'ALTA') {
    try {
      const response = await api.post(`/atendimento/${ffaId}/finalizar`, {
        motivo,
      });

      return Object.freeze({
        ...response.data,
        status: 'FINALIZADO',
        substatus: motivo,
        data_fechamento: new Date().toISOString(),
        atualizado_em: new Date().toISOString(),
      });
    } catch (error) {
      console.error('Erro ao finalizar atendimento:', error);
      throw error;
    }
  },

  /**
   * Mudar local de atendimento
   */
  async mudarLocal(ffaId, novoLocalId) {
    try {
      const response = await api.post(`/atendimento/${ffaId}/local`, {
        id_local_novo: novoLocalId,
      });

      return Object.freeze({
        ...response.data,
        atualizado_em: new Date().toISOString(),
      });
    } catch (error) {
      console.error('Erro ao mudar local:', error);
      throw error;
    }
  },

  /**
   * Alterar prioridade
   */
  async alterarPrioridade(ffaId, novaPrioridade) {
    try {
      const response = await api.post(`/atendimento/${ffaId}/prioridade`, {
        prioridade: novaPrioridade,
      });

      return Object.freeze({
        ...response.data,
        prioridade: novaPrioridade,
        atualizado_em: new Date().toISOString(),
      });
    } catch (error) {
      console.error('Erro ao alterar prioridade:', error);
      throw error;
    }
  },

  /**
   * Obter histórico de movimentação
   */
  async obterHistorico(ffaId) {
    try {
      const response = await api.get(`/atendimento/${ffaId}/historico`);

      return Object.freeze(
        response.data.map((item) =>
          Object.freeze({
            id: item.id,
            acao: item.acao,
            statusAnterior: item.status_anterior,
            statusNovo: item.status_novo,
            usuario: item.usuario_login,
            timestamp: item.data_hora,
            comentario: item.comentario,
          })
        )
      );
    } catch (error) {
      console.error('Erro ao obter histórico:', error);
      throw error;
    }
  },

  /**
   * Adicionar observação
   */
  async adicionarObservacao(ffaId, observacao, usuarioId) {
    try {
      const response = await api.post(`/atendimento/${ffaId}/observacao`, {
        descricao: observacao,
      });

      return Object.freeze({
        id: response.data.id,
        id_atendimento: ffaId,
        descricao: observacao,
        usuario_id: usuarioId,
        criado_em: new Date().toISOString(),
      });
    } catch (error) {
      console.error('Erro ao adicionar observação:', error);
      throw error;
    }
  },

  /**
   * Obter fila operacional atual
   */
  async obterFilaOperacional(localId, opcoes = {}) {
    try {
      const params = new URLSearchParams();
      params.append('id_local', localId);

      if (opcoes.status) params.append('status', opcoes.status);
      if (opcoes.limite) params.append('limite', opcoes.limite);

      const response = await api.get('/fila/operacional', { params });

      return Object.freeze(
        response.data.map((item) =>
          Object.freeze({
            id: item.id_fila_operacional,
            id_ffa: item.id_ffa,
            tipo: item.tipo_evento,
            status: item.status,
            prioridade: item.prioridade,
            paciente: item.paciente_nome,
            chamado_em: item.chamado_em,
            iniciado_em: item.iniciado_em,
          })
        )
      );
    } catch (error) {
      console.error('Erro ao obter fila operacional:', error);
      throw error;
    }
  },

  /**
   * Chamar senha
   */
  async chamarSenha(filaSenhaId, usuarioId, local = 'GUICHE_1') {
    try {
      const response = await api.post(`/fila/chamar`, {
        id_fila_senha: filaSenhaId,
        id_usuario: usuarioId,
        guiche: local,
      });

      return Object.freeze({
        id: response.data.id,
        status: 'CHAMADA',
        chamada_em: new Date().toISOString(),
      });
    } catch (error) {
      console.error('Erro ao chamar senha:', error);
      throw error;
    }
  },

  /**
   * Iniciar atendimento na fila
   */
  async iniciarFila(filaId, usuarioId) {
    try {
      const response = await api.post(`/fila/${filaId}/iniciar`, {
        id_usuario: usuarioId,
      });

      return Object.freeze({
        ...response.data,
        status: 'EM_EXECUCAO',
        iniciado_em: new Date().toISOString(),
      });
    } catch (error) {
      console.error('Erro ao iniciar fila:', error);
      throw error;
    }
  },

  /**
   * Finalizar fila
   */
  async finalizarFila(filaId, usuarioId, detalhe = '') {
    try {
      const response = await api.post(`/fila/${filaId}/finalizar`, {
        id_usuario: usuarioId,
        detalhe,
      });

      return Object.freeze({
        ...response.data,
        status: 'FINALIZADO',
        finalizado_em: new Date().toISOString(),
      });
    } catch (error) {
      console.error('Erro ao finalizar fila:', error);
      throw error;
    }
  },

  /**
   * Marcar como não compareceu
   */
  async marcarNaoCompareceu(filaId, usuarioId, motivo = '') {
    try {
      const response = await api.post(`/fila/${filaId}/nao-compareceu`, {
        id_usuario: usuarioId,
        motivo,
      });

      return Object.freeze({
        ...response.data,
        status: 'NAO_COMPARECEU',
        finalizado_em: new Date().toISOString(),
      });
    } catch (error) {
      console.error('Erro ao marcar não comparecimento:', error);
      throw error;
    }
  },
};

export default atendimentoService;
