/**
 * ================================================================
 * Runtime Context Middleware
 * ================================================================
 * 
 * Middleware que carrega o contexto operacional completo
 * para cada requisição.
 * 
 * Fluxo:
 * Request → JWT Middleware → Carrega Sessão → Carrega Contexto → Runtime Pronto
 * 
 * O objeto req.runtime contém:
 * - usuario: dados do usuário
 * - sessao: dados da sessão
 * - unidade: dados da unidade
 * - local: dados do local operacional
 * - dispositivo: dados do dispositivo
 * - perfil: perfil do usuário
 * 
 * @version 1.0.0
 * ================================================================
 */

const jwt = require("jsonwebtoken");
const pool = require("../config/database");
const { SECRET } = require("../config/jwt");

function extractBearerToken(req) {
    const authHeader = req.headers.authorization || "";
    if (!authHeader.startsWith("Bearer ")) return null;
    return authHeader.slice(7).trim();
}

/**
 * Guard leve de sessão runtime por token de sessão.
 * Compatível com schemas `auth_sessao` e `sessao_usuario`.
 */
const authGuardRuntime = async (req, res, next) => {
    try {
        const token = extractBearerToken(req);
        if (!token) {
            return res.status(401).json({ error: "TOKEN_NAO_INFORMADO" });
        }

        let rows = [];

        // Schema federado/hospitalar
        try {
            const [sessaoAuth] = await pool.query(
                `SELECT *
                 FROM auth_sessao
                 WHERE token_sessao = ?
                   AND ativo = 1
                   AND expira_em > NOW()
                 LIMIT 1`,
                [token]
            );
            rows = sessaoAuth || [];
        } catch {}

        // Schema atual (sessao_usuario)
        if (!rows.length) {
            const [sessaoRuntime] = await pool.query(
                `SELECT *
                 FROM sessao_usuario
                 WHERE ativo = 1
                   AND (
                        token_runtime = ?
                     OR token = ?
                     OR token_jwt = ?
                   )
                   AND COALESCE(expiracao_em, expira_em, DATE_ADD(NOW(), INTERVAL 1 MINUTE)) > NOW()
                 LIMIT 1`,
                [token, token, token]
            );
            rows = sessaoRuntime || [];
        }

        if (!rows.length) {
            return res.status(401).json({ error: "SESSAO_INVALIDA" });
        }

        req.session = rows[0];
        return next();
    } catch (err) {
        console.error("authGuardRuntime error:", err.message);
        return res.status(500).json({ error: "AUTH_RUNTIME_ERROR" });
    }
};

/**
 * Middleware de contexto de runtime
 * Deve ser usado APÓS o middleware de autenticação JWT
 */
const runtimeContextMiddleware = async (req, res, next) => {
    // Skip se não há token (rota pública)
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return next();
    }

    const token = authHeader.substring(7);

    try {
        // Decodificar token
        const decoded = jwt.verify(token, SECRET);

        // Carregar contexto completo
        const runtime = await carregarRuntimeContext(decoded);

        if (!runtime) {
            return res.status(401).json({ 
                erro: "CONTEXTO_INVALIDO",
                mensagem: "Contexto operacional não encontrado" 
            });
        }

        // Adicionar runtime ao request
        req.runtime = runtime;

        // Adicionar conveniências
        req.id_usuario = decoded.id_usuario;
        req.id_sessao_usuario = decoded.id_sessao_usuario;
        req.id_unidade = decoded.id_unidade;
        req.id_local_operacional = decoded.id_local_operacional;
        req.id_perfil = decoded.id_perfil;
        req.perfil = decoded.perfil;

        next();

    } catch (err) {
        console.error("RuntimeContextMiddleware error:", err.message);
        
        if (err.name === 'TokenExpiredError') {
            return res.status(401).json({ 
                erro: "TOKEN_EXPIRADO",
                mensagem: "Sessão expirada, faça login novamente" 
            });
        }

        return res.status(401).json({ 
            erro: "TOKEN_INVALIDO",
            mensagem: "Token de autenticação inválido" 
        });
    }
};

/**
 * Carrega o contexto completo de runtime
 */
async function carregarRuntimeContext(decoded) {
    const conn = await pool.getConnection();

    try {
        // ==============================
        // 1. Validar sessão
        // ==============================
        const [sessoes] = await conn.execute(
            `SELECT 
                su.id_sessao_usuario,
                su.token_runtime,
                su.id_unidade,
                su.id_local_operacional,
                su.id_dispositivo,
                su.tipo_dispositivo,
                su.ip_origem,
                su.user_agent,
                su.expiracao_em,
                su.ativo
             FROM sessao_usuario su
             WHERE su.id_sessao_usuario = ? AND su.ativo = 1`,
            [decoded.id_sessao_usuario]
        );

        if (sessoes.length === 0) {
            return null;
        }

        const sessao = sessoes[0];

        // Verificar expiração
        if (new Date(sessao.expiracao_em) < new Date()) {
            return null;
        }

        // ==============================
        // 2. Carregar dados do usuário
        // ==============================
        const [usuarios] = await conn.execute(
            `SELECT 
                u.id_usuario,
                u.login,
                u.email
             FROM usuario u
             WHERE u.id_usuario = ?`,
            [decoded.id_usuario]
        );

        if (usuarios.length === 0) {
            return null;
        }

        // ==============================
        // 3. Carregar dados da unidade
        // ==============================
        let unidade = null;
        if (decoded.id_unidade) {
            const [unidades] = await conn.execute(
                `SELECT 
                    id_unidade,
                    nome,
                    tipo,
                    id_entidade
                 FROM unidade
                 WHERE id_unidade = ?`,
                [decoded.id_unidade]
            );
            unidade = unidades[0] || null;
        }

        // ==============================
        // 4. Carregar dados do local operacional
        // ==============================
        let local = null;
        if (decoded.id_local_operacional) {
            const [locais] = await conn.execute(
                `SELECT 
                    id_local_operacional,
                    nome,
                    tipo
                 FROM local_operacional
                 WHERE id_local_operacional = ?`,
                [decoded.id_local_operacional]
            );
            local = locais[0] || null;
        }

        // ==============================
        // 5. Carregar dados do dispositivo
        // ==============================
        let dispositivo = null;
        if (sessao.id_dispositivo) {
            const [dispositivos] = await conn.execute(
                `SELECT 
                    id_dispositivo,
                    nome,
                    tipo,
                    mac_address,
                    ip_address,
                    id_unidade,
                    id_local_operacional
                 FROM dispositivo
                 WHERE id_dispositivo = ? AND ativo = 1`,
                [sessao.id_dispositivo]
            );
            dispositivo = dispositivos[0] || null;
        }

        // ==============================
        // 6. Carregar perfil
        // ==============================
        let perfil = null;
        if (decoded.id_perfil) {
            const [perfis] = await conn.execute(
                `SELECT 
                    id_perfil,
                    nome
                 FROM perfil
                 WHERE id_perfil = ?`,
                [decoded.id_perfil]
            );
            perfil = perfis[0] || null;
        }

        // ==============================
        // 7. Compilar runtime
        // ==============================
        return {
            usuario: usuarios[0],
            sessao: {
                id_sessao_usuario: sessao.id_sessao_usuario,
                token_runtime: sessao.token_runtime,
                expiracao_em: sessao.expiracao_em,
                ip_origem: sessao.ip_origem,
                user_agent: sessao.user_agent
            },
            contexto: {
                unidade,
                local,
                dispositivo
            },
            perfil,
            permissoes: decoded.permissoes || []
        };

    } catch (err) {
        console.error("Erro ao carregar runtime context:", err);
        throw err;
    } finally {
        conn.release();
    }
}

/**
 * Middleware para verificar permissão específica
 */
const requirePermission = (permissao) => {
    return (req, res, next) => {
        if (!req.runtime) {
            return res.status(401).json({ erro: "SEM_AUTENTICACAO" });
        }

        const permissoes = req.runtime.permissoes || [];
        
        if (!permissoes.includes(permissao)) {
            return res.status(403).json({ 
                erro: "ACESSO_NEGADO",
                mensagem: `Permissão '${permissao}' necessária` 
            });
        }

        next();
    };
};

/**
 * Middleware para verificar perfil específico
 */
const requirePerfil = (...perfisPermitidos) => {
    return (req, res, next) => {
        if (!req.runtime) {
            return res.status(401).json({ erro: "SEM_AUTENTICACAO" });
        }

        const perfilAtual = req.runtime.perfil?.nome;
        
        if (!perfisPermitidos.includes(perfilAtual)) {
            return res.status(403).json({ 
                erro: "PERFIL_INSUFICIENTE",
                mensagem: `Perfil '${perfilAtual}' não tem acesso a este recurso` 
            });
        }

        next();
    };
};

/**
 * Middleware para verificar dispositivo específico
 */
const requireDeviceType = (...tiposPermitidos) => {
    return (req, res, next) => {
        if (!req.runtime) {
            return res.status(401).json({ erro: "SEM_AUTENTICACAO" });
        }

        const dispositivo = req.runtime.contexto?.dispositivo;
        
        if (dispositivo && !tiposPermitidos.includes(dispositivo.tipo)) {
            return res.status(403).json({ 
                erro: "DISPOSITIVO_NAO_PERMITIDO",
                mensagem: `Este recurso não está disponível para dispositivo do tipo '${dispositivo.tipo}'` 
            });
        }

        next();
    };
};

module.exports = {
    authGuardRuntime,
    runtimeContextMiddleware,
    requirePermission,
    requirePerfil,
    requireDeviceType,
    carregarRuntimeContext
};
