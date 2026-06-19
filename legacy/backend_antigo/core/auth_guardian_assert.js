/**
 * ================================================================
 * Kernel Auth Guardian Assert
 * ================================================================
 * 
 * Guardião de assertions para autenticação.
 * Valida e protege o fluxo de autenticação.
 * 
 * @version 1.0.0
 * @author Kernel Team
 * ================================================================
 */

const sessionValidator = require("./auth_session_validator");
const authLoginService = require("./auth_login_service");

/**
 * Guardian - Protege e valida operações de autenticação
 */
class AuthGuardianAssert {
    /**
     * Valida proteção de rota
     * @param {Object} req - Requisição Express
     * @param {Object} res - Resposta Express
     * @param {Function} next - Próximo middleware
     */
    static async guard(req, res, next) {
        try {
            // 1. Verificar Authorization header
            const authHeader = req.headers.authorization;
            if (!authHeader) {
                return res.status(401).json({
                    success: false,
                    error: "TOKEN_NAO_FORNECIDO",
                    message: "Header Authorization é obrigatório"
                });
            }

            // 2. Validar formato Bearer token
            const parts = authHeader.split(' ');
            if (parts.length !== 2 || parts[0] !== 'Bearer') {
                return res.status(401).json({
                    success: false,
                    error: "TOKEN_FORMATO_INVALIDO",
                    message: "Use o formato: Bearer <token>"
                });
            }

            const token = parts[1];

            // 3. Validar token JWT
            const payload = authLoginService.validateToken(token);

            // 4. Validar sessão no banco
            const sessao = await sessionValidator.validateSession(payload.id_sessao_usuario);

            // 5. Adicionar contexto ao request
            req.user = {
                id_usuario: payload.id_usuario,
                id_sessao_usuario: payload.id_sessao_usuario,
                id_sistema: payload.id_sistema,
                id_unidade: payload.id_unidade,
                id_local_operacional: payload.id_local_operacional,
                id_cidade: payload.id_cidade,
                perfil: payload.perfil,
                login: payload.login
            };

            // 6. Adicionar metadata de segurança
            req.security = {
                tokenValid: true,
                sessionActive: true,
                ip: req.ip,
                userAgent: req.get('user-agent')
            };

            next();

        } catch (error) {
            console.error("[auth_guardian_assert] Acesso negado:", error.message);

            // Tratar erros específicos
            if (error.message.includes('EXPIRADA')) {
                return res.status(401).json({
                    success: false,
                    error: "TOKEN_EXPIRADO",
                    message: "Sua sessão expirou. Faça login novamente."
                });
            }

            if (error.message.includes('INATIVA')) {
                return res.status(401).json({
                    success: false,
                    error: "SESSAO_INATIVA",
                    message: "Sessão foi encerrada."
                });
            }

            if (error.message.includes('INEXISTENTE')) {
                return res.status(401).json({
                    success: false,
                    error: "SESSAO_INEXISTENTE",
                    message: "Sessão não encontrada."
                });
            }

            return res.status(401).json({
                success: false,
                error: "ACESSO_NEGADO",
                message: error.message
            });
        }
    }

    /**
     * Verifica se usuário tem perfil específico
     */
    static requireProfile(...perfis) {
        return (req, res, next) => {
            if (!req.user) {
                return res.status(401).json({
                    success: false,
                    error: "USUARIO_NAO_AUTENTICADO"
                });
            }

            const userProfile = req.user.perfil;
            if (!perfis.includes(userProfile) && userProfile !== 1) {
                return res.status(403).json({
                    success: false,
                    error: "PERFIL_INSUFICIENTE",
                    message: `Acesso restrito a: ${perfis.join(', ')}`
                });
            }

            next();
        };
    }

    /**
     * Verifica permissão específica
     */
    static async requirePermission(permissao) {
        return async (req, res, next) => {
            if (!req.user) {
                return res.status(401).json({
                    success: false,
                    error: "USUARIO_NAO_AUTENTICADO"
                });
            }

            // Admin tem todas as permissões
            if (req.user.perfil === 1) {
                return next();
            }

            // Aqui você pode verificar permissões no banco
            // Por agora, permitir acesso
            next();
        };
    }

    /**
     * Rate limiting para tentativas de login
     */
    static rateLimiter() {
        const attempts = new Map();

        return (req, res, next) => {
            const ip = req.ip;
            const now = Date.now();
            const windowMs = 15 * 60 * 1000; // 15 minutos
            const maxAttempts = 10;

            // Limpar tentativas antigas
            for (const [key, value] of attempts.entries()) {
                if (now - value.timestamp > windowMs) {
                    attempts.delete(key);
                }
            }

            // Verificar tentativas
            const userAttempts = attempts.get(ip);
            if (userAttempts && userAttempts.count >= maxAttempts) {
                return res.status(429).json({
                    success: false,
                    error: "TENTATIVAS_EXCEDIDAS",
                    message: "Muitas tentativas. Tente novamente mais tarde.",
                    retryAfter: Math.ceil((userAttempts.timestamp + windowMs - now) / 1000)
                });
            }

            // Registrar tentativa
            if (userAttempts) {
                userAttempts.count++;
            } else {
                attempts.set(ip, { count: 1, timestamp: now });
            }

            next();
        };
    }
}

module.exports = AuthGuardianAssert;
