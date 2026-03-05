/**
 * ================================================================
 * Kernel Auth Login Service
 * ================================================================
 * 
 * Serviço de autenticação do kernel.
 * Fluxo: Login → Backend → sp_kernel_authenticate_runtime
 * 
 * @version 1.0.0
 * @author Kernel Team
 * ================================================================
 */

const pool = require("../../config/database");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { v4: uuidv4 } = require("uuid");
const { SECRET, EXPIRES_IN } = require("../../config/jwt");

/**
 * Autentica usuário e cria sessão runtime
 * @param {Object} credentials - Credenciais do usuário
 * @returns {Promise<Object>} Token JWT e sessão
 */
async function authenticate(credentials) {
    const { login, senha, id_cidade, id_unidade, id_sistema, id_local_operacional, ip_acesso, user_agent } = credentials;

    if (!login || !senha) {
        throw new Error("LOGIN_E_SENHA_OBRIGATORIOS");
    }

    const connection = await pool.getConnection();

    try {
        // 1. Buscar usuário
        const [usuarios] = await connection.execute(
            `SELECT u.*, p.nome as nome_pessoa 
             FROM usuario u 
             JOIN pessoa p ON p.id = u.id_pessoa 
             WHERE u.login = ? AND u.ativo = 1`,
            [login]
        );

        if (usuarios.length === 0) {
            throw new Error("USUARIO_NAO_ENCONTRADO");
        }

        const usuario = usuarios[0];

        // 2. Validar senha
        const senhaValida = await bcrypt.compare(senha, usuario.senha_hash);
        if (!senhaValida) {
            throw new Error("SENHA_INCORRETA");
        }

        // 3. Validar contexto (se fornecido)
        if (id_sistema) {
            const [contextos] = await connection.execute(
                `SELECT * FROM usuario_contexto 
                 WHERE id_usuario = ? AND id_sistema = ? AND ativo = 1`,
                [usuario.id_usuario, id_sistema]
            );

            if (contextos.length === 0 && id_sistema) {
                throw new Error("USUARIO_SEM_ACESSO_AO_SISTEMA");
            }
        }

        // 4. Criar sessão runtime
        const id_sessao = uuidv4();
        const horas = parseInt(EXPIRES_IN, 10) || 1;
        const expira = new Date(Date.now() + horas * 60 * 60 * 1000);

        // Inserir sessão
        await connection.execute(
            `INSERT INTO sessao_usuario 
             (id_sessao_usuario, id_usuario, id_sistema, id_unidade, id_local_operacional, token_runtime, ip_origem, agente_usuario, expira_em, ativo, criado_em)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1, NOW())`,
            [id_sessao, usuario.id_usuario, id_sistema || null, id_unidade || null, id_local_operacional || null, null, ip_acesso || null, user_agent || null, expira]
        );

        // 5. Criar token JWT
        const token = jwt.sign({
            id_usuario: usuario.id_usuario,
            login: usuario.login,
            id_sessao_usuario: id_sessao,
            id_sistema: id_sistema || null,
            id_unidade: id_unidade || null,
            id_local_operacional: id_local_operacional || null,
            id_cidade: id_cidade || null,
            perfil: usuario.id_perfil
        }, SECRET, { expiresIn: EXPIRES_IN });

        // 6. Atualizar token na sessão
        await connection.execute(
            `UPDATE sessao_usuario SET token_runtime = ? WHERE id_sessao_usuario = ?`,
            [token, id_sessao]
        );

        return {
            token,
            id_sessao_usuario: id_sessao,
            usuario: {
                id_usuario: usuario.id_usuario,
                login: usuario.login,
                nome: usuario.nome_pessoa,
                id_perfil: usuario.id_perfil
            }
        };

    } finally {
        connection.release();
    }
}

/**
 * Valida token JWT
 * @param {string} token - Token JWT
 * @returns {Object} Payload decodificado
 */
function validateToken(token) {
    try {
        return jwt.verify(token, SECRET);
    } catch (error) {
        throw new Error("TOKEN_INVALIDO_OU_EXPIRADO");
    }
}

/**
 * Renova token
 * @param {string} token - Token atual
 * @returns {Promise<Object>} Novo token
 */
async function refreshToken(token) {
    const payload = validateToken(token);
    
    const connection = await pool.getConnection();
    
    try {
        // Verificar se sessão ainda existe e está ativa
        const [sessoes] = await connection.execute(
            `SELECT * FROM sessao_usuario 
             WHERE id_sessao_usuario = ? AND ativo = 1 AND expira_em > NOW()`,
            [payload.id_sessao_usuario]
        );

        if (sessoes.length === 0) {
            throw new Error("SESSAO_EXPIRADA_OU_INATIVA");
        }

        // Criar novo token
        const horas = parseInt(EXPIRES_IN, 10) || 1;
        const novoToken = jwt.sign({
            id_usuario: payload.id_usuario,
            login: payload.login,
            id_sessao_usuario: payload.id_sessao_usuario,
            id_sistema: payload.id_sistema,
            id_unidade: payload.id_unidade,
            id_local_operacional: payload.id_local_operacional,
            id_cidade: payload.id_cidade,
            perfil: payload.perfil
        }, SECRET, { expiresIn: EXPIRES_IN });

        // Atualizar na sessão
        await connection.execute(
            `UPDATE sessao_usuario SET token_runtime = ? WHERE id_sessao_usuario = ?`,
            [novoToken, payload.id_sessao_usuario]
        );

        return { token: novoToken };

    } finally {
        connection.release();
    }
}

/**
 * Encerra sessão
 * @param {string} idSessao - ID da sessão
 * @returns {Promise<void>}
 */
async function logout(idSessao) {
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

module.exports = {
    authenticate,
    validateToken,
    refreshToken,
    logout
};
