const API_URL = '/api/dispatcher';

/**
 * Cliente Frontend para chamar o dispatcher central
 * 
 * @param {Object} params
 * @param {number} params.idSessao - ID da sessão do usuário
 * @param {string} params.uuidTransacao - UUID para idempotência
 * @param {string} params.dominio - Domínio (FILA, ASSISTENCIAL, FARMACIA, etc)
 * @param {string} params.acao - Ação (CHAMAR, ENCAMINHAR, etc)
 * @param {number} params.idReferencia - ID da entidade relacionada
 * @param {Object} params.payload - Dados adicionais
 */
export async function callDispatcher({ 
  idSessao, 
  uuidTransacao, 
  dominio, 
  acao, 
  idReferencia, 
  payload 
}) {
  const response = await fetch(API_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      idSessao,
      uuidTransacao,
      dominio,
      acao,
      idReferencia,
      payload
    })
  });

  const data = await response.json();
  if (!response.ok) throw new Error(data.message || "Erro no dispatcher");
  return data;
}

/**
 * Gera UUID para idempotência
 */
export function gerarUuidTransacao() {
  return crypto.randomUUID();
}

export default { callDispatcher, gerarUuidTransacao };
