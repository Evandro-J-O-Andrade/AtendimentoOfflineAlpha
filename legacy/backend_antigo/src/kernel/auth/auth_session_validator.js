/**
 * ================================================================
 * Kernel Auth Session Validator
 * ================================================================
 * 
 * Valida sessões runtime no kernel.
 * Verifica se sessão existe, está ativa e não expirou.
 * 
 * @version 1.0.0
 * @author Kernel Team
 * ================================================================
 */

const pool = require("../../config/database");

/**
 * Valida sessão
 * @param {string} idSessao - ID da sessão
 * @returns {Promise<Object>} Dados da sessão
 */
async function validateSession(idSessao) {
    if (!idSessao) {
        throw new Error("ID_SESSAO_OBRIGATORIO");
    }

    const connection = await pool.getConnection();

    try {
        // Buscar sessão
        const [sessoes] = await connection.execute(
            `SELECT 
                s.id_sessao_usuario,
                s.id_usuario,
                s.id_sistema,
                s.id_unidade,
                s.id_local_operacional,
                s.token_runtime,
                s.expira_em,
                s.ativo,
                s.criado_em,
                s.ultimo_acesso,
                u.login,
                u.id_perfil
             FROM sessao_usuario s
             JOIN usuario u ON u.id_usuario = s.id_usuario
             WHERE s.id_sessao_usuario = ?`,
            [idSessao]
        );

        if (sessoes.length === 0) {
            throw new Error("SESSAO_INEXISTENTE");
        }

        const sessao = sessoes[0];

        // Verificar se está ativa
        if (!sessao.ativo) {
            throw new Error("SESSAO_INATIVA");
        }

        // Verificar se não expirou
        if (new Date(sessao.expira_em) < new Date()) {
            throw new Error("SESSAO_EXPIRADA");
        }

        // Atualizar último acesso
        await connection.execute(
            `UPDATE sessao_usuario SET ultimo_acesso = NOW() WHERE id_sessao_usuario = ?`,
            [idSessao]
        );

        return {
            valida: true,
            id_sessao_usuario: sessao.id_sessao_usuario,
            id_usuario: sessao.id_usuario,
            id_sistema: sessao.id_sistema,
            id_unidade: sessao.id_unidade,
            id_local_operacional: sessao.id_local_operacional,
            id_perfil: sessao.id_perfil,
            login: sessao.login,
            expira_em: sessao.expira_em
        };

    } finally {
        connection.release();
    }
}

/**
 * Valida sessão e retorna throw em caso de erro
 * @param {string} idSessao - ID da sessão
 * @returns {Promise<void>}
 */
async function assertSession(idSessao) {
    await validateSession(idSessao);
}

/**
 * Busca contexto da sessão
 * @param {string} idSessao - ID da sessão
 * @returns {Promise<Object>} Contexto operacional
 */
async function getSessionContext(idSessao) {
    const sessao = await validateSession(idSessao);
    
    return {
        id_sessao_usuario: sessao.id_sessao_usuario,
        id_usuario: sessao.id_usuario,
        id_sistema: sessao.id_sistema,
        id_unidade: sessao.id_unidade,
        id_local_operacional: sessao.id_local_operacional,
        id_perfil: sessao.id_perfil,
        login: sessao.login
    };
}

/**
 * Encerra sessão
 * @param {string} idSessao - ID da sessão
 * @returns {Promise<void>}
 */
async function terminateSession(idSessao) {
    const connection = await pool.getConnection();

    try {
        await connection.execute(
            `UPDATE sessao_usuario SET ativo = 0 WHERE id_sessao_usuario = ?`,
            [idSessao]
        );
    } finally {
        connection.release();
    }
}

/**
 * Encerra todas as sessões de um usuário
 * @param {number} idUsuario - ID do usuário
 * @returns {Promise<number>} Quantidade de sessões encerradas
 */
async function terminateAllUserSessions(idUsuario) {
    const connection = await pool.getConnection();

    try {
        const [result] = await connection.execute(
            `UPDATE sessao_usuario SET ativo = 0 WHERE id_usuario = ?`,
            [idUsuario]
        );
        return result.affectedRows;
    } finally {
        connection.release();
    }
}

/**
 * Lista sessões ativas de um usuário
 * @param {number} idUsuario - ID do usuário
 * @returns {Promise<Array>}
 */
async function listUserSessions(idUsuario) {
    const connection = await pool.getConnection();

    try {
        const [sessoes] = await connection.execute(
            `SELECT 
                id_sessao_usuario,
                id_sistema,
                id_unidade,
                id_local_operacional,
                ip_origem,
                agente_usuario,
                expira_em,
                criado_em,
                ultimo_acesso
             FROM sessao_usuario 
             WHERE id_usuario = ? AND ativo = 1 AND expira_em > NOW()
             ORDER BY ultimo_acesso DESC`,
            [idUsuario]
        );
        return sessoes;
    } finally {
        connection.release();
    }
}

module.exports = {
    validateSession,
    assertSession,
    getSessionContext,
    terminateSession,
    terminateAllUserSessions,
    listUserSessions
};
