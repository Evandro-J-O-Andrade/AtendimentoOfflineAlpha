/**
 * UserService - Serviço para informações do usuário logado
 *HIS/PA - Sistema de Prontuário Ambulatorial
 */

import spApi from '../api/spApi';

/**
 * Busca dados do usuário logado
 * @param {number} id_sessao - ID da sessão do usuário
 * @returns {Promise<object>}
 */
export async function getUser(id_sessao) {
  return spApi.call('sp_buscar_usuario', {
    p_id_sessao: id_sessao
  });
}

/**
 * Busca informações completas do usuário com permissões
 * @param {number} id_sessao - ID da sessão do usuário
 * @returns {Promise<object>}
 */
export async function getUserCompleto(id_sessao) {
  // Busca dados do usuário
  const usuarioData = await spApi.call('sp_buscar_usuario', {
    p_id_sessao: id_sessao
  });

  if (!usuarioData || !usuarioData.id_usuario) {
    return usuarioData;
  }

  // Busca permissões do usuário
  const permissoesResult = await spApi.call('sp_buscar_permissoes_usuario', {
    p_id_sessao: id_sessao,
    p_id_usuario_alvo: usuarioData.id_usuario
  });

  return {
    data: usuarioData,
    permissoes: permissoesResult
  };
}

export default {
  getUser,
  getUserCompleto
};
