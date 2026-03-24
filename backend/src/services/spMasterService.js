const pool = require("../config/database");
const { v4: uuidv4 } = require('uuid');

/**
 * Executa a SP master_dispatcher para fluxos operacionais.
 * 
 * Assinatura:
 * IN p_id_sessao BIGINT,
 * IN p_uuid_transacao CHAR(36),
 * IN p_dominio VARCHAR(50),
 * IN p_acao VARCHAR(100),
 * IN p_id_referencia BIGINT,
 * IN p_payload JSON
 * 
 * O retorno vem via SELECT no final da procedure.
 */
async function executeSPMaster(dominio, acao, idSessao, payload = {}, idReferencia = null) {
  const payloadStr = JSON.stringify(payload);
  const uuidTransacao = payload.uuid_transacao || uuidv4();

  try {
    const sql = `CALL sp_master_dispatcher(?, ?, ?, ?, ?, ?)`;
    const [rows] = await pool.query(sql, [
      idSessao, 
      uuidTransacao, 
      dominio.toUpperCase(), 
      acao.toUpperCase(), 
      idReferencia, 
      payloadStr
    ]);
    
    // O dispatcher retorna um SELECT com o objeto JSON
    const result = rows[0][0];

    return {
      sucesso: result?.status === 'SUCCESS',
      resultado: result || {},
      mensagem: result?.status === 'SUCCESS' ? 'OK' : (result?.mensagem || 'ERRO_DISPATCHER')
    };
  } catch (err) {
    console.error(`[DISPATCHER][ERRO] ${dominio}.${acao}:`, err.message);
    return { sucesso: false, resultado: {}, mensagem: err.message };
  }
}

/**
 * Executa rotas de Autenticação e Contexto via sp_master_routes (Orquestradora).
 */
async function executeSPRoute(metodo, rota, idSessao, payload = {}) {
    const payloadStr = JSON.stringify(payload);
    try {
      const sql = `CALL sp_master_routes(?, ?, ?, ?, @p_resultado, @p_sucesso, @p_mensagem);
                   SELECT @p_resultado as resultado, @p_sucesso as sucesso, @p_mensagem as mensagem;`;
  
      const [rows] = await pool.query(sql, [metodo, rota, idSessao, payloadStr]);
      const output = rows[1][0];
  
      return {
        sucesso: !!output.sucesso,
        resultado: output.resultado ? JSON.parse(output.resultado) : {},
        mensagem: output.mensagem
      };
    } catch (err) {
      console.error(`[ROUTE][ERRO] ${rota}:`, err.message);
      return { sucesso: false, resultado: {}, mensagem: err.message };
    }
}

module.exports = {
  executeSPMaster,
  executeSPRoute
};
