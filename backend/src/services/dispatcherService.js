const db = require('../config/database');
const { v4: uuidv4 } = require('uuid');
const crypto = require('crypto');

/**
 * Chama a SP master_dispatcher
 * @param {Object} params
 * @param {number} params.id_sessao
 * @param {string} params.uuid_transacao
 * @param {string} params.dominio
 * @param {string} params.acao
 * @param {number} params.id_referencia
 * @param {Object} params.payload
 */
async function executeMasterDispatcher({ 
    id_sessao, 
    dominio, 
    acao, 
    id_referencia, 
    payload, 
    uuid_transacao 
}) {
    // Se o front não mandou UUID, geramos um aqui (Idempotência)
    const transactionUuid = uuid_transacao || uuidv4();

    // Calcula hash do payload para integridade
    const payloadHash = crypto.createHash('sha256')
        .update(JSON.stringify(payload || {}))
        .digest('hex');
    
    console.log(`Dispatcher Payload Hash: ${payloadHash}`);

    const sql = `CALL sp_master_dispatcher(?, ?, ?, ?, ?, ?)`;
    const params = [
        id_sessao, 
        transactionUuid, 
        dominio.toUpperCase(), 
        acao.toUpperCase(), 
        id_referencia || 0, 
        JSON.stringify(payload || {})
    ];

    const [rows] = await db.execute(sql, params);
    return {
        success: true,
        uuid: transactionUuid,
        data: rows[0]
    };
}

module.exports = {
    executeMasterDispatcher
};
