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
            // Primeiro verifica se a sessão existe na tabela
            const [sessaoRows] = await pool.execute(
                "SELECT id_sessao_usuario, ativo, expira_em FROM sessao_usuario WHERE id_sessao_usuario = ?",
                [decoded.id_sessao_usuario]
            );
            
            if (!sessaoRows.length) {
                return res.status(401).json({
                    error: "SESSAO_INEXISTENTE",
                    message: "Sessão não encontrada no banco"
                });
            }
            
            const sessao = sessaoRows[0];
            
            // Verifica se está ativa
            if (sessao.ativo !== 1) {
                return res.status(401).json({
                    error: "SESSAO_INATIVA",
                    message: "Sessão foi encerrada"
                });
            }
            
            // Verifica se expirou
            if (new Date(sessao.expira_em) < new Date()) {
                return res.status(401).json({
                    error: "SESSAO_EXPIRADA",
                    message: "Sessão expirou. Faça login novamente."
                });
            }
            
            // A procedure sp_sessao_assert faz validação extra (opcional em modo dev)
            try {
                await pool.query(
                    "SET @p_resultado = NULL, @p_sucesso = FALSE, @p_mensagem = NULL; CALL sp_sessao_assert(?, NULL, @p_resultado, @p_sucesso, @p_mensagem); SELECT @p_sucesso AS sucesso, @p_mensagem AS mensagem",
                    [decoded.id_sessao_usuario]
                );
            } catch (spError) {
                // Se a SP falhar em modo dev, continua apenas com validação básica
                if (process.env.NODE_ENV === 'production') {
                    console.error("Erro na sp_sessao_assert:", spError.message);
                    return res.status(401).json({
                        error: "SESSAO_INVALIDA",
                        message: "Falha na validação de sessão"
                    });
                }
                console.warn("Aviso: sp_sessao_assert falhou, usando validação básica:", spError.message);
            }
            
        } catch (sessionError) {
            console.error("Erro na validação de sessão:", sessionError.message);
            
            // Se for erro de tabela não existente, permite continuar em modo desenvolvimento
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
            id_perfil: decoded.id_perfil,
            perfil: decoded.perfil
        };

        // 5️⃣ Atualizar heartbeat da sessão (opcional - não bloqueia requisição)
        try {
            // sp_sessao_heartbeat pode não existir, então usa query simples
            await pool.execute(
                "UPDATE sessao_usuario SET ultimo_acesso = NOW(6) WHERE id_sessao_usuario = ?",
                [decoded.id_sessao_usuario]
            );
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
