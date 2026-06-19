/**
 * ================================================================
 * Ledger Client - Immutable Audit Trail
 * ================================================================
 * 
 * Cliente para registro de transações no ledger.
 * Todas as operações são registradas de forma imutável.
 * 
 * @version 1.0.0
 * @author Kernel Team
 * ================================================================
 */

const pool = require("../config/database");
const { v4: uuidv4 } = require("uuid");

/**
 * Ledger Client - Audit Trail Service
 */
class LedgerClient {
    constructor() {
        this.batchBuffer = [];
        this.batchSize = 50;
        this.flushInterval = 5000; // 5 segundos
    }

    /**
     * Registra uma transação no ledger
     * @param {Object} params - Parâmetros da transação
     * @returns {Promise<string>} ID da transação
     */
    async log(params) {
        const {
            id_sessao,
            id_usuario,
            id_perfil,
            acao,
            contexto,
            payload = {},
            status = 'SUCESSO',
            duracao_ms = null,
            mensagem = null,
            id_tenant = 1
        } = params;

        const connection = await pool.getConnection();

        try {
            const id_transacao = uuidv4();

            await connection.execute(
                `INSERT INTO kernel_ledger 
                 (id_transacao, id_sessao, id_usuario, id_perfil, acao, contexto, payload, status, duracao_ms, mensagem, id_tenant, registrado_em)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())`,
                [id_transacao, id_sessao, id_usuario, id_perfil, acao, contexto, JSON.stringify(payload), status, duracao_ms, mensagem, id_tenant]
            );

            return id_transacao;

        } finally {
            connection.release();
        }
    }

    /**
     * Registra transação no buffer para batch
     */
    async logBuffer(params) {
        this.batchBuffer.push({
            ...params,
            id_transacao: uuidv4(),
            registrado_em: new Date()
        });

        if (this.batchBuffer.length >= this.batchSize) {
            await this.flush();
        }
    }

    /**
     * Escreve todas as transações bufferizadas
     */
    async flush() {
        if (this.batchBuffer.length === 0) return;

        const connection = await pool.getConnection();
        const batch = [...this.batchBuffer];
        this.batchBuffer = [];

        try {
            await connection.beginTransaction();

            for (const entry of batch) {
                await connection.execute(
                    `INSERT INTO kernel_ledger 
                     (id_transacao, id_sessao, id_usuario, id_perfil, acao, contexto, payload, status, duracao_ms, mensagem, id_tenant, registrado_em)
                     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                    [entry.id_transacao, entry.id_sessao, entry.id_usuario, entry.id_perfil, entry.acao, entry.contexto, 
                     JSON.stringify(entry.payload), entry.status, entry.duracao_ms, entry.mensagem, entry.id_tenant || 1, entry.registrado_em]
                );
            }

            await connection.commit();
            console.log(`[ledger_client] Flush concluído: ${batch.length} entradas`);

        } catch (error) {
            await connection.rollback();
            console.error("[ledger_client] Erro no flush:", error.message);
            // Recolocar no buffer para retry
            this.batchBuffer = [...batch, ...this.batchBuffer];
        } finally {
            connection.release();
        }
    }

    /**
     * Busca transações por filtros
     * @param {Object} filters - Filtros de busca
     * @returns {Promise<Array>}
     */
    async query(filters = {}) {
        const {
            id_usuario = null,
            acao = null,
            contexto = null,
            status = null,
            data_inicio = null,
            data_fim = null,
            limit = 100
        } = filters;

        let query = 'SELECT * FROM kernel_ledger WHERE 1=1';
        const params = [];

        if (id_usuario) {
            query += ' AND id_usuario = ?';
            params.push(id_usuario);
        }

        if (acao) {
            query += ' AND acao = ?';
            params.push(acao);
        }

        if (contexto) {
            query += ' AND contexto = ?';
            params.push(contexto);
        }

        if (status) {
            query += ' AND status = ?';
            params.push(status);
        }

        if (data_inicio) {
            query += ' AND registrado_em >= ?';
            params.push(data_inicio);
        }

        if (data_fim) {
            query += ' AND registrado_em <= ?';
            params.push(data_fim);
        }

        query += ' ORDER BY registrado_em DESC LIMIT ?';
        params.push(limit);

        const connection = await pool.getConnection();

        try {
            const [rows] = await connection.execute(query, params);
            return rows;
        } finally {
            connection.release();
        }
    }

    /**
     * Obtém estatísticas do ledger
     */
    async getStats() {
        const connection = await pool.getConnection();

        try {
            const [[total]] = await connection.execute(
                'SELECT COUNT(*) as total FROM kernel_ledger'
            );

            const [[porStatus]] = await connection.execute(
                `SELECT status, COUNT(*) as total FROM kernel_ledger GROUP BY status`
            );

            const [[ultimo]] = await connection.execute(
                'SELECT * FROM kernel_ledger ORDER BY registrado_em DESC LIMIT 1'
            );

            return {
                total: total.total,
                porStatus,
                ultimo,
                bufferSize: this.batchBuffer.length
            };

        } finally {
            connection.release();
        }
    }
}

// Instância singleton
const ledgerClient = new LedgerClient();

/**
 * Factory function para criar middleware de logging
 */
function createLedgerMiddleware(options = {}) {
    return async (req, res, next) => {
        // Capturar tempo de início
        const startTime = Date.now();

        // Sobrescrever res.json para capturar resposta
        const originalJson = res.json.bind(res);
        
        res.json = function(data) {
            const duration = Date.now() - startTime;
            
            // Logar no ledger
            ledgerClient.log({
                id_sessao: req.user?.id_sessao_usuario,
                id_usuario: req.user?.id_usuario,
                id_perfil: req.user?.id_perfil,
                acao: req.body?.acao || 'HTTP_REQUEST',
                contexto: req.body?.contexto || 'API',
                payload: {
                    method: req.method,
                    path: req.path,
                    body: req.body
                },
                status: res.statusCode >= 400 ? 'ERRO' : 'SUCESSO',
                duracao_ms: duration,
                mensagem: res.statusCode >= 400 ? data?.error || data?.message : null
            }).catch(console.error);

            return originalJson(data);
        };

        next();
    };
}

module.exports = {
    LedgerClient,
    ledgerClient,
    createLedgerMiddleware
};
