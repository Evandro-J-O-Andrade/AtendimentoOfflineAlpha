const jwt = require("jsonwebtoken");
const pool = require("../config/database");
const { SECRET } = require("../config/jwt");

/**
 * ================================================================
 * AuthMiddleware - Validação Contextual de Sessão
 * ================================================================
 * 
 * Este middleware é diferente do runtimeGuard:
 * - authMiddleware: valida autenticação básica (JWT válido)
 * - runtimeGuard: valida sessão operacional completa (JWT + DB)
 * 
 * O sistema usa ambos em camadas:
 * 1. authMiddleware: proteção básica de rotas autenticadas
 * 2. runtimeGuard: proteção de operações assistenciais (FFA)
 * ================================================================
 */

async function authMiddleware(req, res, next) {
    const authHeader = req.headers.authorization;

    if (!authHeader) {
        return res.status(401).json({
            error: "TOKEN_NAO_FORNECIDO",
            message: "Header Authorization não encontrado"
        });
    }

    const parts = authHeader.split(" ");
    
    if (parts.length !== 2 || parts[0] !== "Bearer") {
        return res.status(401).json({
            error: "TOKEN_FORMATO_INVALIDO",
            message: "Formato deve ser: Bearer <token>"
        });
    }

    const token = parts[1];

    try {
        // 1️⃣ Decodificar JWT
        const decoded = jwt.verify(token, SECRET);

        // 2️⃣ Validar estrutura mínima do token (contexto operacional)
        if (!decoded.id_usuario || !decoded.id_sessao_usuario) {
            return res.status(401).json({
                error: "TOKEN_SEM_CONTEXTO",
                message: "Token não contém contexto operacional"
            });
        }

        // 3️⃣ Validar sessão no banco (server-side)
        // Isso garante que a sessão existe, está ativa e não expirou
        try {
            await pool.execute(
                "SELECT id_sessao_usuario, ativo, expira_em FROM sessao_usuario WHERE id_sessao_usuario = ?",
                [decoded.id_sessao_usuario]
            );
            
            // A procedure sp_sessao_assert já faz toda validação
            // Se não existir, vai抛出 erro
            await pool.query("CALL sp_sessao_assert(?)", [decoded.id_sessao_usuario]);
            
        } catch (sessionError) {
            console.error("Erro na validação de sessão:", sessionError.message);
            
            // Erros comuns da procedure
            if (sessionError.message.includes('inexistente') || 
                sessionError.message.includes('não encontrada')) {
                return res.status(401).json({
                    error: "SESSAO_INEXISTENTE",
                    message: "Sessão não encontrada"
                });
            }
            
            if (sessionError.message.includes('inativa') || sessionError.message.includes('inativo')) {
                return res.status(401).json({
                    error: "SESSAO_INATIVA",
                    message: "Sessão foi encerrada"
                });
            }
            
            if (sessionError.message.includes('expirada')) {
                return res.status(401).json({
                    error: "SESSAO_EXPIRADA",
                    message: "Sessão expirou. Faça login novamente."
                });
            }
            
            if (sessionError.message.includes('bloqueada')) {
                return res.status(403).json({
                    error: "SESSAO_BLOQUEADA",
                    message: "Sessão temporariamente bloqueada"
                });
            }
            
            // Se for outro erro, permite continuar em modo desenvolvimento
            // (para evitar quebra se procedure não existir)
            if (process.env.NODE_ENV === 'production') {
                return res.status(401).json({
                    error: "SESSAO_INVALIDA",
                    message: "Falha na validação de sessão"
                });
            }
            console.warn("Aviso: Validação de sessão falhou, continuando em modo desenvolvimento:", sessionError.message);
        }

        // 4️⃣ Definir contexto do usuário na requisição
        req.user = {
            id_usuario: decoded.id_usuario,
            id_sessao_usuario: decoded.id_sessao_usuario,
            id_sistema: decoded.id_sistema,
            id_unidade: decoded.id_unidade,
            id_local_operacional: decoded.id_local_operacional,
            id_cidade: decoded.id_cidade,
            perfil: decoded.perfil
        };

        // 5️⃣ Atualizar heartbeat da sessão
        try {
            await pool.query("CALL sp_sessao_heartbeat(?)", [decoded.id_sessao_usuario]);
        } catch (e) {
            // Ignora erro de heartbeat - não bloqueia requisição
        }

        next();

    } catch (err) {
        // Erros de JWT
        if (err.name === 'TokenExpiredError') {
            return res.status(401).json({
                error: "TOKEN_EXPIRADO",
                message: "Token expirou. Faça login novamente."
            });
        }
        
        if (err.name === 'JsonWebTokenError') {
            return res.status(401).json({
                error: "TOKEN_INVALIDO",
                message: "Token malformado ou inválido"
            });
        }

        console.error("Erro no authMiddleware:", err);
        
        return res.status(401).json({
            error: "AUTENTICACAO_FALHOU",
            message: "Falha na autenticação"
        });
    }
}

module.exports = authMiddleware;
