/**
 * PermissionService - Serviço para permissões do usuário
 *HIS/PA - Sistema de Prontuário Ambulatorial
 */

import spApi from '../api/spApi';

/**
 * Busca permissões do usuário
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {number} id_usuario_alvo - ID do usuário alvo (opicional, usa o logado se não informado)
 * @returns {Promise<object>}
 */
export async function getPermissoes(id_sessao, id_usuario_alvo = null) {
  return spApi.call('sp_buscar_permissoes', {
    p_id_sessao: id_sessao,
    p_id_usuario_alvo: id_usuario_alvo
  });
}

/**
 * Verifica se usuário tem permissão específica
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {string} codigo_permissao - Código da permissão
 * @returns {Promise<boolean>}
 */
export async function hasPermissao(id_sessao, codigo_permissao) {
  const result = await getPermissoes(id_sessao);
  
  if (result.sucesso && result.resultado) {
    const permissoes = Array.isArray(result.resultado) 
      ? result.resultado 
      : [result.resultado];
    
    return permissoes.some(p => p.codigo === codigo_permissao);
  }
  
  return false;
}

/**
 * Busca lista de todas as permissões disponíveis
 * @param {number} id_sessao - ID da sessão do usuário
 * @returns {Promise<object>}
 */
export async function getTodasPermissoes(id_sessao) {
  return spApi.call('sp_listar_todas_permissoes', {
    p_id_sessao: id_sessao
  });
}

export default {
  getPermissoes,
  hasPermissao,
  getTodasPermissoes
};
