/**
 * FilaService - Serviço para operações com filas e triagem
 *HIS/PA - Sistema de Prontuário Ambulatorial
 */

import spApi from '../api/spApi';

function normalizarLista(resultado) {
  if (Array.isArray(resultado)) return resultado;
  if (!resultado) return [];
  return [resultado];
}

/**
 * Busca fila de triagem (pacientes aguardando triagem)
 * @param {number} id_sessao - ID da sessão do usuário
 * @returns {Promise<object>}
 */
export async function getFilaTriagem(id_sessao) {
  const resposta = await spApi.call('sp_fila_triagem', {
    p_id_sessao: id_sessao
  });

  return {
    ok: true,
    data: normalizarLista(resposta).map((item) => ({
      ...item,
      id: item.id ?? item.id_ffa,
      nome_paciente: item.nome_paciente ?? item.paciente,
      status: item.status ?? 'AGUARDANDO_TRIAGEM',
      prioridade: item.prioridade ?? item.classificacao_risco ?? null,
      senha: item.senha ?? `FFA-${item.id_ffa}`
    }))
  };
}

/**
 * Busca fila de espera (pacientes aguardando médico)
 * @param {number} id_sessao - ID da sessão do usuário
 * @returns {Promise<object>}
 */
export async function getFilaEspera(id_sessao) {
  const resposta = await spApi.call('sp_fila_espera', {
    p_id_sessao: id_sessao
  });

  return {
    ok: true,
    data: normalizarLista(resposta).map((item) => ({
      ...item,
      id: item.id ?? item.id_ffa,
      nome_paciente: item.nome_paciente ?? item.paciente,
      prioridade: item.prioridade ?? item.classificacao_risco ?? null,
      senha: item.senha ?? `FFA-${item.id_ffa}`
    }))
  };
}

/**
 * Chamar próximo paciente da fila
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {number} id_fila - ID da fila
 * @returns {Promise<object>}
 */
export async function chamarProximo(id_sessao, id_fila) {
  return spApi.call('sp_chamar_proximo', {
    p_id_sessao: id_sessao,
    p_id_fila: id_fila
  });
}

/**
 * Atualizar status do paciente na fila
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {object} dados - { id_ffa, status }
 * @returns {Promise<object>}
 */
export async function atualizarStatusFila(id_sessao, dados) {
  return spApi.call('sp_atualizar_status_fila', {
    p_id_sessao: id_sessao,
    p_id_ffa: dados.id_ffa,
    p_status: dados.status
  });
}

/**
 * Reordenar fila
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {object} dados - { id_fila, nova_ordem: [{id_ffa, posicao}] }
 * @returns {Promise<object>}
 */
export async function reordenarFila(id_sessao, dados) {
  return spApi.call('sp_reordenar_fila', {
    p_id_sessao: id_sessao,
    p_id_fila: dados.id_fila,
    p_nova_ordem: dados.nova_ordem
  });
}

export async function registrarEvasao(id_sessao, id_ffa, observacao = '') {
  return spApi.call('sp_registrar_evasao', {
    p_id_sessao: id_sessao,
    p_id_ffa: id_ffa,
    p_observacao: observacao
  });
}

export default {
  getFilaTriagem,
  getFilaEspera,
  chamarProximo,
  atualizarStatusFila,
  reordenarFila,
  registrarEvasao
};
