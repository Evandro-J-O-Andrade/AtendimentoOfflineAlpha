/**
 * ================================================================
 * Kernel Auth Runtime Dispatcher
 * ================================================================
 * 
 * Dispatcher de autenticação para o kernel.
 * Direciona requisições para os serviços apropriados.
 * 
 * @version 1.0.0
 * @author Kernel Team
 * ================================================================
 */

const authLoginService = require("./auth_login_service");
const sessionValidator = require("./auth_session_validator");

/**
 * Factory de comandos de autenticação
 */
class AuthRuntimeDispatcher {
    /**
     * Executa comando de autenticação
     * @param {string} command - Comando a executar
     * @param {Object} params - Parâmetros
     * @returns {Promise<Object>}
     */
    async execute(command, params) {
        switch (command) {
            case 'LOGIN':
                return await authLoginService.authenticate(params);
            
            case 'LOGOUT':
                return await authLoginService.logout(params.id_sessao);
            
            case 'VALIDATE_SESSION':
                return await sessionValidator.validateSession(params.id_sessao);
            
            case 'REFRESH_TOKEN':
                return await authLoginService.refreshToken(params.token);
            
            case 'TERMINATE_SESSION':
                return await sessionValidator.terminateSession(params.id_sessao);
            
            case 'TERMINATE_ALL_USER':
                return await sessionValidator.terminateAllUserSessions(params.id_usuario);
            
            case 'LIST_USER_SESSIONS':
                return await sessionValidator.listUserSessions(params.id_usuario);
            
            case 'GET_CONTEXT':
                return await sessionValidator.getSessionContext(params.id_sessao);
            
            default:
                throw new Error(`COMANDO_DESCONHECIDO: ${command}`);
        }
    }

    /**
     * Middleware para proteger rotas
     */
    static guard() {
        return async (req, res, next) => {
            try {
                const authHeader = req.headers.authorization;
                
                if (!authHeader) {
                    return res.status(401).json({
                        success: false,
                        error: "TOKEN_NAO_FORNECIDO"
                    });
                }

                const parts = authHeader.split(' ');
                if (parts.length !== 2 || parts[0] !== 'Bearer') {
                    return res.status(401).json({
                        success: false,
                        error: "TOKEN_FORMATO_INVALIDO"
                    });
                }

                const token = parts[1];
                const payload = authLoginService.validateToken(token);

                // Validar sessão no banco
                const sessao = await sessionValidator.validateSession(payload.id_sessao_usuario);

                // Adicionar ao request
                req.user = {
                    id_usuario: payload.id_usuario,
                    id_sessao_usuario: payload.id_sessao_usuario,
                    id_sistema: payload.id_sistema,
                    id_unidade: payload.id_unidade,
                    id_local_operacional: payload.id_local_operacional,
                    id_perfil: payload.perfil,
                    login: payload.login
                };

                next();
            } catch (error) {
                console.error("[auth_runtime_dispatcher] Erro:", error.message);
                
                if (error.message.includes('EXPIRADA') || error.message.includes('INATIVA')) {
                    return res.status(401).json({
                        success: false,
                        error: "SESSAO_INVALIDA",
                        message: error.message
                    });
                }

                return res.status(401).json({
                    success: false,
                    error: "AUTENTICACAO_FALHOU",
                    message: error.message
                });
            }
        };
    }
}

module.exports = AuthRuntimeDispatcher;
