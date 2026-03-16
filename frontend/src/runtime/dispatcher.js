/**
 * Dispatcher Runtime - Executa ações no backend
 * HIS/PA - Sistema de Prontuário Ambulatorial
 * 
 * O dispatcher valida permissão e executa a SP correspondente
 */

import { apiPost } from "../api/api";

/**
 * Executa uma ação no backend via dispatcher
 * @param {string} acao - Código da ação (ex: 'SENHA_CRIAR', 'PACIENTE_BUSCAR')
 * @param {object} payload - Parâmetros da SP
 * @param {object} sessaoUsuario - Dados da sessão do usuário
 * @returns {Promise<object>} Resultado da execução
 */
export async function runAction(acao, payload = {}, sessaoUsuario) {
  try {
    const resultado = await apiPost("/runtime/dispatch", {
      acao,
      payload,
      idSessao: sessaoUsuario?.id_sessao,
      idUsuario: sessaoUsuario?.id_usuario,
    });

    return resultado;
  } catch (error) {
    console.error(`Erro ao executar ação ${acao}:`, error);
    throw error;
  }
}

/**
 * Executa ação com validação local de permissão
 * @param {string} acao - Código da ação
 * @param {object} payload - Parâmetros da SP
 * @param {object} sessaoUsuario - Dados da sessão
 * @param {Array} permissoes - Lista de permissões do usuário
 * @returns {Promise<object>}
 */
export async function runActionWithPermission(acao, payload, sessaoUsuario, permissoes) {
  // Verifica se o usuário tem permissão
  const temPermissao = permissoes.some(p => p.codigo === acao);
  
  if (!temPermissao) {
    throw new Error("Você não tem permissão para executar esta ação");
  }

  return runAction(acao, payload, sessaoUsuario);
}

/**
 * Busca lista de ações disponíveis para o perfil
 * @param {number} idPerfil - ID do perfil do usuário
 * @returns {Promise<Array>} Lista de permissões
 */
export async function getPermissoesPorPerfil(idPerfil) {
  try {
    const resultado = await apiPost("/auth/permissoes", { idPerfil });
    return resultado;
  } catch (error) {
    console.error("Erro ao buscar permissões:", error);
    throw error;
  }
}

export default {
  runAction,
  runActionWithPermission,
  getPermissoesPorPerfil,
};
