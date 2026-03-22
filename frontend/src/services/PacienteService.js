/**
 * PacienteService - Serviço para operações com pacientes
 *HIS/PA - Sistema de Prontuário Ambulatorial
 */

import { executarOrquestradora } from '../api/spApi';

/**
 * Busca paciente por nome ou CPF
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {object} filtros - Filtros de busca { nome, cpf }
 * @returns {Promise<object>}
 */
export async function buscarPaciente(id_sessao, filtros = {}) {
  return executarOrquestradora({
    id_sessao,
    modulo: 'PACIENTE',
    acao: 'request',
    payload: filtros
  });
}

/**
 * Busca timeline completa do paciente
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {number} id_ffa - ID do FFA (ficha de atendimento)
 * @returns {Promise<object>}
 */
export async function getTimelinePaciente(id_sessao, id_ffa) {
  return executarOrquestradora({
    id_sessao,
    modulo: 'PACIENTE_TIMELINE',
    acao: 'getUser',
    payload: { id_ffa }
  });
}

/**
 * Salvar dados do paciente
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {object} dadosPaciente - Dados do paciente
 * @returns {Promise<object>}
 */
export async function salvarPaciente(id_sessao, dadosPaciente) {
  return executarOrquestradora({
    id_sessao,
    modulo: 'PACIENTE',
    acao: 'post',
    payload: dadosPaciente
  });
}

/**
 * Atualizar paciente
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {object} dadosPaciente - Dados do paciente com id
 * @returns {Promise<object>}
 */
export async function atualizarPaciente(id_sessao, dadosPaciente) {
  return executarOrquestradora({
    id_sessao,
    modulo: 'PACIENTE',
    acao: 'push',
    payload: dadosPaciente
  });
}

/**
 * Registra evasão de atendimento sem passar pelo dispatcher antigo.
 * Chama rota dedicada no backend que executa a procedure direta.
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {number} id_ffa - ID da ficha/FFA
 * @param {string} observacao - Observação da evasão
 * @returns {Promise<object>}
 */
export async function registrarEvasao(id_sessao, id_ffa, observacao = '') {
  const { apiPost } = await import('../api/api');

  return apiPost('/sp/evasao', {
    id_sessao,
    id_ffa,
    observacao
  });
}

export default {
  buscarPaciente,
  getTimelinePaciente,
  salvarPaciente,
  atualizarPaciente,
  registrarEvasao
};
