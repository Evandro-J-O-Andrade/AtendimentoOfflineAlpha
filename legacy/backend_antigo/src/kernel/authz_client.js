/**
 * ================================================================
 * AuthZ Client - Authorization Client
 * ================================================================
 * 
 * Cliente para validação de autorização no kernel.
 * Used by dispatcher to validate permissions before execution.
 * 
 * @version 1.0.0
 * @author Kernel Team
 * ================================================================
 */

const pool = require("../config/database");

/**
 * AuthZ Client - Authorization Service
 */
class AuthZClient {
    constructor() {
        this.cache = new Map();
        this.cacheTTL = 30000; // 30 segundos
    }

    /**
     * Valida autorização para uma ação
     * @param {Object} params - Parâmetros de autorização
     * @returns {Promise<Object>} Resultado da autorização
     */
    async authorize(params) {
        const {
            id_usuario,
            id_perfil,
            id_tenant = 1,
            contexto,
            recurso,
            estado_origem,
            estado_destino,
            id_dispositivo
        } = params;

        // Admin sempre autorizado
        if (id_perfil === 1) {
            return { authorized: true, admin: true };
        }

        // Verificar cache
        const cacheKey = `${id_perfil}:${contexto}:${recurso}:${estado_destino}`;
        const cached = this.cache.get(cacheKey);
        if (cached && (Date.now() - cached.timestamp) < this.cacheTTL) {
            return cached.result;
        }

        const connection = await pool.getConnection();

        try {
            // Chamar procedure de autorização
            await connection.query(
                `CALL sp_kernel_gateway_assert(?, ?, ?, ?, ?, ?, ?, ?)`,
                [id_tenant, id_usuario, id_perfil, contexto, recurso, estado_origem, estado_destino, id_dispositivo]
            );

            // Se chegou aqui, está autorizado
            const result = { authorized: true };

            // Armazenar em cache
            this.cache.set(cacheKey, {
                result,
                timestamp: Date.now()
            });

            return result;

        } catch (error) {
            // Verificar tipo de erro
            if (error.message.includes('PERMISSAO_NEGADA')) {
                return {
                    authorized: false,
                    error: 'PERMISSAO_NEGADA',
                    message: error.message
                };
            }

            if (error.message.includes('TABELA_PERMISSOES_NAO_EXISTE')) {
                // Em modo desenvolvimento, permitir
                console.warn("[authz_client] Tabela de permissões não existe, permitindo acesso");
                return { authorized: true, dev_mode: true };
            }

            // Outro erro
            console.error("[authz_client] Erro na autorização:", error.message);
            return {
                authorized: false,
                error: 'ERRO_AUTORIZACAO',
                message: error.message
            };

        } finally {
            connection.release();
        }
    }

    /**
     * Limpa o cache de autorizações
     */
    clearCache() {
        this.cache.clear();
        console.log("[authz_client] Cache limpo");
    }

    /**
     * Atualiza TTL do cache
     */
    setCacheTTL(ttl) {
        this.cacheTTL = ttl;
    }
}

// Instância singleton
const authzClient = new AuthZClient();

/**
 * Factory function para criar middleware de autorização
 */
function createAuthzMiddleware(options = {}) {
    return async (req, res, next) => {
        const { acao, contexto = 'DEFAULT' } = req.body;
        
        if (!acao) {
            return res.status(400).json({
                success: false,
                error: 'ACAO_OBRIGATORIA'
            });
        }

        const result = await authzClient.authorize({
            id_usuario: req.user.id_usuario,
            id_perfil: req.user.id_perfil,
            contexto,
            recurso: acao,
            estado_origem: req.body.estado_origem || null,
            estado_destino: req.body.estado_destino || 'DEFAULT'
        });

        if (!result.authorized) {
            return res.status(403).json({
                success: false,
                error: result.error || 'PERMISSAO_NEGADA',
                message: result.message
            });
        }

        next();
    };
}

module.exports = {
    AuthZClient,
    authzClient,
    createAuthzMiddleware
};
