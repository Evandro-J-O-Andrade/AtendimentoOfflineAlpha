/**
 * ROTA UNIVERSAL DE STORED PROCEDURES
 * 
 * Modelo Antigo (legado):
 * {
 *   "procedure": "sp_nome_procedure",
 *   "params": { ... }
 * }
 * 
 * Modelo Novo (canônico - sp_master_dispatcher):
 * {
 *   "metodo": "GET | SET | POST | REQUEST",
 *   "rota": "DOMINIO.ACAO | AUTH.LOGIN | ...",
 *   "id_sessao": 123,
 *   "payload": { ... }
 * }
 * 
 * O modelo novo converte para:
 * CALL sp_master_dispatcher(p_id_sessao, uuid, p_dominio, p_acao, p_id_referencia, p_payload)
 */

const express = require('express');
const router = express.Router();
const db = require('../config/database');

/**
 * Gera UUID v4
 */
function generateUUID() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        const r = Math.random() * 16 | 0;
        const v = c === 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}

/**
 * POST /api/sp
 * Executor universal - suporta ambos os modelos
 */
router.post('/sp', async (req, res) => {
    const connection = await db.getConnection();

    try {
        const body = req.body;
        
        // ==========================================
        // MODELO NOVO (sp_master_dispatcher)
        // ==========================================
        if (body.metodo && body.rota) {
            const { metodo, rota, id_sessao, payload } = body;
            
            // Converte rota para dominio + acao
            // ex: "AUTH.LOGIN" -> dominio="AUTH", acao="LOGIN"
            // ex: "FILA.GERAR_SENHA" -> dominio="FILA", acao="GERAR_SENHA"
            const [dominio, acao] = rota.split('.');
            
            // Gera UUID para transação
            const uuid_transacao = generateUUID();
            
            // Chama sp_master_dispatcher
            await connection.query('SET @p_resultado = NULL');
            await connection.query('SET @p_sucesso = FALSE');
            await connection.query('SET @p_mensagem = NULL');
            
            await connection.query(
                'CALL sp_master_dispatcher(?, ?, ?, ?, ?, ?, @p_resultado, @p_sucesso, @p_mensagem)',
                [
                    id_sessao || null,
                    uuid_transacao,
                    dominio || rota,  // usa rota inteira se não tiver ponto
                    acao || metodo,   // usa metodo se não tiver acao
                    null,             // id_referencia
                    payload ? JSON.stringify(payload) : null
                ]
            );
            
            const [rows] = await connection.query(`
                SELECT 
                    @p_resultado AS resultado,
                    @p_sucesso AS sucesso,
                    @p_mensagem AS mensagem
            `);
            
            let resultado = rows[0].resultado;
            try {
                if (typeof resultado === 'string') {
                    resultado = JSON.parse(resultado);
                }
            } catch (e) { }
            
            return res.json({
                sucesso: rows[0].sucesso === 1 || rows[0].sucesso === true,
                mensagem: rows[0].mensagem,
                resultado
            });
        }
        
        // ==========================================
        // MODELO ANTIGO (procedure + params)
        // ==========================================
        const { procedure, params } = body;

        if (!procedure) {
            return res.status(400).json({
                sucesso: false,
                mensagem: 'PROCEDURE_OBRIGATORIA'
            });
        }

        // Monta parâmetros dinâmicos
        const inputParams = [];
        const inputValues = [];

        if (params) {
            for (const key of Object.keys(params)) {
                inputParams.push(`@${key}`);
                inputValues.push(params[key]);
            }
        }

        // OUT padrão
        inputParams.push('@p_resultado');
        inputParams.push('@p_sucesso');
        inputParams.push('@p_mensagem');

        // Set dos parâmetros
        if (params) {
            let i = 0;
            for (const key of Object.keys(params)) {
                await connection.query(`SET @${key} = ?`, [inputValues[i]]);
                i++;
            }
        }

        // Call dinâmico
        const sqlCall = `CALL ${procedure}(${inputParams.join(', ')})`;

        await connection.query(sqlCall);

        // Captura dos OUT
        const [rows] = await connection.query(`
            SELECT 
                @p_resultado AS resultado,
                @p_sucesso AS sucesso,
                @p_mensagem AS mensagem
        `);

        let resultado = rows[0].resultado;

        // tenta parse JSON
        try {
            if (typeof resultado === 'string') {
                resultado = JSON.parse(resultado);
            }
        } catch (e) { }

        return res.json({
            sucesso: rows[0].sucesso === 1 || rows[0].sucesso === true,
            mensagem: rows[0].mensagem,
            resultado
        });

    } catch (error) {
        console.error('ERRO SP:', error);

        return res.status(500).json({
            sucesso: false,
            mensagem: 'ERRO_EXECUCAO_SP',
            erro: error.message
        });

    } finally {
        connection.release();
    }
});

module.exports = router;
