const pool = require("../config/database");

/**
 * Executa a SP master de forma genérica.
 * @param {string} metodo - GET / POST / SET / REQUEST
 * @param {string} rota - Rota da SP (ex: AUTH.CONTEXTO_GET)
 * @param {number} idSessao - ID da sessão do usuário
 * @param {object} payload - JSON payload (opcional)
 * @returns {Promise<object>} - { sucesso, resultado, mensagem }
 */
async function executeSPMaster(metodo, rota, idSessao, payload = {}) {
  const payloadStr = JSON.stringify(payload);

  try {
    console.log(`[AUDITORIA][START] ${metodo} ${rota} | sessao: ${idSessao} | payload: ${payloadStr}`);

    const sql = `CALL sp_master_routes(?, ?, ?, ?, @p_resultado, @p_sucesso, @p_mensagem);
                 SELECT @p_resultado as resultado, @p_sucesso as sucesso, @p_mensagem as mensagem;`;

    const [rows] = await pool.query(sql, [metodo, rota, idSessao, payloadStr]);
    const output = rows[1][0];

    console.log(`[AUDITORIA][END] ${metodo} ${rota} | sessao: ${idSessao} | sucesso: ${output.sucesso}`);

    return {
      sucesso: !!output.sucesso,
      resultado: JSON.parse(output.resultado || "{}"),
      mensagem: output.mensagem
    };
  } catch (err) {
    console.error(`[AUDITORIA][ERRO] ${metodo} ${rota} | sessao: ${idSessao} | erro:`, err);
    throw err;
  }
}

module.exports = {
  executeSPMaster
};
