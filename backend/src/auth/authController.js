const pool = require("../config/database");
const bcrypt = require("bcryptjs");
const crypto = require("crypto");
const jwt = require("jsonwebtoken");
const { SECRET, EXPIRES_IN } = require("../config/jwt");
const { registrarEventoAuditoria } = require("../services/auditoria_service");

/**
 * Busca contextos ativos do usuário (usuario_contexto ou usuario_sistema).
 */
async function carregarContextos(conn, id_usuario) {
    let contextRows = [];

    try {
        const [rows] = await conn.execute(
            `SELECT 
                uc.id_sistema,
                uc.id_unidade,
                uc.id_local_operacional,
                uc.id_perfil
             FROM usuario_contexto uc
             WHERE uc.id_usuario = ? AND uc.ativo = 1`,
            [id_usuario]
        );
        contextRows = rows || [];
    } catch (err) {
        console.warn("Erro ao buscar usuario_contexto:", err.message);
    }

    // fallback legado
    if (!contextRows.length) {
        try {
            const [rows] = await conn.execute(
                `SELECT 
                    us.id_sistema,
                    1 AS id_unidade,
                    1 AS id_local_operacional,
                    us.id_perfil
                 FROM usuario_sistema us
                 WHERE us.id_usuario = ? AND us.ativo = 1`,
                [id_usuario]
            );
            contextRows = rows || [];
        } catch (err) {
            console.warn("Erro ao buscar usuario_sistema:", err.message);
        }
    }

    if (!contextRows.length) {
        contextRows = [{
            id_sistema: 1,
            id_unidade: 1,
            id_local_operacional: 1,
            id_perfil: 1
        }];
    }

    return contextRows;
}

/**
 * Valida senha com suporte a bcrypt, SHA256 (dump) e texto plano legado.
 */
async function validarSenha(senhaDigitada, hashBanco) {
    if (!hashBanco) return false;

    // bcrypt
    if (hashBanco.startsWith("$2")) {
        const ok = await bcrypt.compare(senhaDigitada, hashBanco);
        if (ok) return true;
    }

    // sha256
    const shaCalc = crypto.createHash("sha256").update(String(senhaDigitada)).digest("hex").toLowerCase();
    if (hashBanco.toLowerCase() === shaCalc) return true;

    // texto plano legado
    return hashBanco === senhaDigitada;
}

class AuthController {

    static async checkUser(req, res) {
        const { usuario: rawUsuario, login: rawLogin } = req.body;
        const usuario = rawUsuario || rawLogin;

        if (!usuario) {
            return res.status(400).json({ sucesso: false, erro: "LOGIN_OBRIGATORIO" });
        }

        let conn;
        try {
            conn = await pool.getConnection();
            const [rows] = await conn.execute(
                "SELECT id_usuario, login, ativo FROM usuario WHERE login = ? LIMIT 1",
                [usuario]
            );

            if (!rows.length) {
                await registrarEventoAuditoria({
                    acao: "LOGIN_FAIL",
                    mensagem: `Tentativa com usuário inexistente: ${usuario}`,
                    contexto: { usuario },
                    req,
                });
                return res.json({ sucesso: false, erro: "USUARIO_NAO_ENCONTRADO" });
            }

            const user = rows[0];
            return res.json({
                sucesso: true,
                usuario: {
                    id_usuario: user.id_usuario,
                    login: user.login,
                    ativo: !!user.ativo,
                },
            });
        } catch (err) {
            console.error("Erro /checkUser:", err.message);
            return res.status(500).json({ sucesso: false, erro: "ERRO_DE_CONEXAO" });
        } finally {
            if (conn) conn.release();
        }
    }

    static async login(req, res) {
        const { usuario: rawUsuario, login: rawLogin, senha } = req.body;
        let {
            id_sistema,
            id_unidade,
            id_local_operacional,
            id_dispositivo = null,
        } = req.body;

        const usuario = rawUsuario || rawLogin;
        const ip = req.headers["x-forwarded-for"] || req.socket.remoteAddress || null;
        const userAgent = req.headers["user-agent"] || null;

        if (!usuario || !senha) {
            return res.json({ sucesso: false, erro: "LOGIN_E_SENHA_OBRIGATORIOS" });
        }

        let conn;
        try {
            conn = await pool.getConnection();

            // 1) Verifica bloqueio por tentativas (procedure do dump)
            // try {
            //     await conn.query("CALL sp_auth_verificar_bloqueio(?)", [usuario]);
            // } catch (err) {
            //     await registrarEventoAuditoria({
            //         acao: "LOGIN_FAIL",
            //         mensagem: "Usuário temporariamente bloqueado",
            //         contexto: { usuario },
            //         req,
            //     });
            //     return res.status(403).json({ sucesso: false, erro: "USUARIO_BLOQUEADO" });
            // }

            // Verificação de bloqueio simples no código
            const [bloqueio] = await conn.execute(
                "SELECT bloqueado_ate FROM usuario WHERE login = ? AND bloqueado_ate IS NOT NULL AND bloqueado_ate > NOW()",
                [usuario]
            );
            if (bloqueio.length > 0) {
                return res.status(403).json({ sucesso: false, erro: "USUARIO_BLOQUEADO" });
            }

            // 2) Busca usuário
            const [rows] = await conn.execute(
                "SELECT id_usuario, login, senha_hash, ativo FROM usuario WHERE login = ? LIMIT 1",
                [usuario]
            );

            if (!rows.length) {
                try { await conn.query("CALL sp_auth_registrar_tentativa(?, ?, 0)", [usuario, ip]); } catch {}
                await registrarEventoAuditoria({
                    acao: "LOGIN_FAIL",
                    mensagem: `Usuário inexistente: ${usuario}`,
                    contexto: { usuario },
                    req,
                });
                return res.json({ sucesso: false, erro: "USUARIO_NAO_ENCONTRADO" });
            }

            const user = rows[0];

            if (!user.ativo) {
                await registrarEventoAuditoria({
                    acao: "LOGIN_FAIL",
                    usuario: user.id_usuario,
                    mensagem: "Usuário inativo",
                    contexto: { usuario },
                    req,
                });
                return res.json({ sucesso: false, erro: "USUARIO_INATIVO" });
            }

            // 3) Validação de senha (bcrypt > sha > texto plano)
            const senhaOk = await validarSenha(senha, user.senha_hash || "");
            if (!senhaOk) {
                try { await conn.query("CALL sp_auth_registrar_tentativa(?, ?, 0)", [usuario, ip]); } catch {}
                await registrarEventoAuditoria({
                    acao: "LOGIN_FAIL",
                    usuario: user.id_usuario,
                    mensagem: "Senha incorreta",
                    contexto: { usuario },
                    req,
                });
                return res.json({ sucesso: false, erro: "SENHA_INCORRETA" });
            }

            try { await conn.query("CALL sp_auth_registrar_tentativa(?, ?, 1)", [usuario, ip]); } catch {}

            // 4) Resolve contexto
            const contextos = await carregarContextos(conn, user.id_usuario);
            const temContextoEscolhido = id_sistema && id_unidade && id_local_operacional;

            if (!temContextoEscolhido && contextos.length > 1) {
                return res.json({
                    sucesso: false,
                    erro: "SELECIONE_CONTEXTO",
                    contextos,
                });
            }

            const ctx = temContextoEscolhido
                ? contextos.find(
                      (c) =>
                          String(c.id_sistema) === String(id_sistema) &&
                          String(c.id_unidade) === String(id_unidade) &&
                          String(c.id_local_operacional) === String(id_local_operacional)
                  ) || contextos[0]
                : contextos[0];

            id_sistema = ctx.id_sistema;
            id_unidade = ctx.id_unidade;
            id_local_operacional = ctx.id_local_operacional;
            const id_perfil = ctx.id_perfil || 1;

            // 5) Cria sessão (procedure oficial) com token runtime aleatório
            const tokenRuntime = crypto.randomBytes(32).toString("hex");
            let sessao = null;

            try {
                const [spResult] = await conn.query(
                    "CALL sp_auth_criar_sessao(?, ?, ?, ?, ?, ?)",
                    [
                        user.id_usuario,
                        id_sistema,
                        id_unidade,
                        id_local_operacional,
                        id_perfil,
                        tokenRuntime,
                    ]
                );
                sessao = spResult?.[0]?.[0] || spResult?.[0] || null;
            } catch (err) {
                console.warn("sp_auth_criar_sessao falhou, fallback manual:", err.message);
                const expira = new Date(Date.now() + 8 * 60 * 60 * 1000);
                const uuidSessao = crypto.randomUUID();
                // garante perfil válido no FK
                let perfilSessao = id_perfil || 1;
                try {
                    const [chkPerfil] = await conn.execute("SELECT COUNT(*) AS qtd FROM perfil WHERE id_perfil = ?", [perfilSessao]);
                    if (!chkPerfil?.[0]?.qtd) perfilSessao = 1;
                } catch { perfilSessao = 1; }
                await conn.query(
                    `INSERT INTO sessao_usuario 
                        (uuid_sessao, id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, id_dispositivo, token_jwt, ip_origem, user_agent, iniciado_em, expira_em, ativo, revogado, criado_em)
                     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(6), ?, 1, 0, NOW(6))`,
                    [
                        uuidSessao,
                        user.id_usuario,
                        id_sistema,
                        id_unidade,
                        id_local_operacional,
                        perfilSessao,
                        id_dispositivo,
                        tokenRuntime,
                        ip,
                        userAgent,
                        expira,
                    ]
                );

                const [sessaoRows] = await conn.execute(
                    `SELECT id_sessao_usuario, token_jwt AS token_jwt, expira_em AS expiracao_em
                     FROM sessao_usuario
                     WHERE id_usuario = ?
                     ORDER BY id_sessao_usuario DESC
                     LIMIT 1`,
                    [user.id_usuario]
                );
                sessao = sessaoRows?.[0] || null;
            }

            const id_sessao_usuario = sessao?.id_sessao_usuario;
            const token_db = sessao?.token_jwt || sessao?.token_runtime || tokenRuntime;
            const expiracao = sessao?.expiracao_em || null;

            // 6) Permissões via procedure
            let permissoes = [];
            try {
                const [permResult] = await conn.query(
                    `SELECT codigo_permissao FROM vw_usuario_permissoes WHERE id_usuario = ? AND id_sistema = ?`,
                    [user.id_usuario, id_sistema]
                );
                permissoes = (permResult || []).map((p) => p.codigo_permissao);
            } catch (err) {
                console.warn("permissoes falhou:", err.message);
            }

            // 7) Token JWT para frontend
            const token = jwt.sign(
                {
                    id_usuario: user.id_usuario,
                    id_sessao_usuario,
                    id_sistema,
                    id_unidade,
                    id_local_operacional,
                    id_perfil,
                    permissoes,
                },
                SECRET,
                { expiresIn: EXPIRES_IN }
            );

            await registrarEventoAuditoria({
                acao: "LOGIN_SUCCESS",
                usuario: user.id_usuario,
                sessao: id_sessao_usuario,
                mensagem: "Login bem-sucedido",
                contexto: { id_sistema, id_unidade, id_local_operacional },
                req,
            });

            return res.json({
                sucesso: true,
                usuario: {
                    id_usuario: user.id_usuario,
                    login: user.login,
                },
                contexto: {
                    id_sessao_usuario,
                    id_sistema,
                    id_unidade,
                    id_local_operacional,
                    id_perfil,
                    expiracao,
                },
                permissoes,
                token,
                token_runtime: token_db,
            });
        } catch (err) {
            console.error("Erro /login:", err);
            await registrarEventoAuditoria({
                acao: "LOGIN_ERROR",
                mensagem: err.message,
                contexto: { usuario },
                req,
            });
            return res.status(500).json({ sucesso: false, erro: "ERRO_DE_CONEXAO" });
        } finally {
            if (conn) conn.release();
        }
    }

    /**
     * Retorna as permissões de um perfil específico
     * Usado para montar o menu dinâmico
     */
    static async permissoesPorPerfil(req, res) {
        const { idPerfil } = req.params;
        let conn;

        if (!idPerfil) {
            return res.status(400).json({ sucesso: false, erro: "ID_PERFIL_OBRIGATORIO" });
        }

        try {
            conn = await pool.getConnection();

            const [rows] = await conn.execute(
                `SELECT 
                    p.codigo,
                    p.nome,
                    p.descricao,
                    p.grupo_menu,
                    p.icone,
                    p.ordem_menu,
                    p.acao_frontend,
                    p.visivel_menu
                FROM permissao p
                JOIN perfil_permissao pp ON pp.id_permissao = p.id_permissao
                WHERE pp.id_perfil = ? 
                    AND p.ativo = 1
                    AND pp.ativo = 1
                ORDER BY p.ordem_menu, p.nome`,
                [idPerfil]
            );

            return res.json({
                sucesso: true,
                permissoes: rows
            });

        } catch (err) {
            console.error("Erro permissoesPorPerfil:", err.message);
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
        } finally {
            if (conn) conn.release();
        }
    }

    static async me(req, res) {
        return res.json({
            user: req.user
        });
    }

    /**
     * Retorna os nomes dos contextos para exibir na tela de seleção
     */
    static async listarContextos(req, res) {
        let conn;
        try {
            conn = await pool.getConnection();

            // Buscar sistemas
            const [sistemas] = await conn.query(
                "SELECT id_sistema, nome FROM sistema WHERE ativo = 1"
            );
            const sistemasMap = {};
            sistemas.forEach(s => {
                sistemasMap[s.id_sistema] = s.nome;
            });

            // Buscar unidades
            const [unidades] = await conn.query(
                "SELECT id_unidade, nome FROM unidade WHERE ativo = 1"
            );
            const unidadesMap = {};
            unidades.forEach(u => {
                unidadesMap[u.id_unidade] = u.nome;
            });

            // Buscar locais operacionais
            const [locais] = await conn.query(
                "SELECT id_local_operacional, nome, tipo FROM local_operacional WHERE ativo = 1"
            );
            const locaisMap = {};
            locais.forEach(l => {
                locaisMap[l.id_local_operacional] = l.nome;
            });

            // Buscar perfis
            const [perfis] = await conn.query(
                "SELECT id_perfil, nome FROM perfil WHERE ativo = 1"
            );
            const perfisMap = {};
            perfis.forEach(p => {
                perfisMap[p.id_perfil] = p.nome;
            });

            return res.json({
                sistemas: sistemasMap,
                unidades: unidadesMap,
                locais: locaisMap,
                perfis: perfisMap
            });

        } catch (err) {
            console.error("Erro ao listar contextos:", err);
            return res.status(500).json({
                error: "ERRO_AO_LISTAR_CONTEXTOS"
            });
        } finally {
            if (conn) conn.release();
        }
    }

    /**
     * Lista os contextos disponíveis para o usuário logado
     */
    static async meusContextos(req, res) {
        let conn;
        try {
            conn = await pool.getConnection();
            const id_usuario = req.user.id_usuario;

            const [contextos] = await conn.query(
                `SELECT 
                    uc.id_unidade,
                    uc.id_sistema,
                    uc.id_local_operacional,
                    uc.id_perfil,
                    s.nome as sistema_nome,
                    NULL as sistema_sigla,
                    u.nome as unidade_nome,
                    lo.nome as local_nome,
                    lo.tipo as local_tipo,
                    p.nome as perfil_nome
                FROM usuario_contexto uc
                LEFT JOIN sistema s ON s.id_sistema = uc.id_sistema
                LEFT JOIN unidade u ON u.id_unidade = uc.id_unidade
                LEFT JOIN local_operacional lo ON lo.id_local_operacional = uc.id_local_operacional
                LEFT JOIN perfil p ON p.id_perfil = uc.id_perfil
                WHERE uc.id_usuario = ? AND uc.ativo = 1`,
                [id_usuario]
            );

            return res.json({ contextos });

        } catch (err) {
            console.error("Erro ao buscar contextos:", err);
            return res.status(500).json({
                error: "ERRO_AO_BUSCAR_CONTEXTOS"
            });
        } finally {
            if (conn) conn.release();
        }
    }

    /**
     * Seleciona um contexto específico (quando há múltiplas escolhas)
     */
    static async selecionarContexto(req, res) {
        try {
            const {
                id_unidade,
                id_local_operacional,
                id_perfil
            } = req.body;

            if (!id_unidade || !id_local_operacional || !id_perfil) {
                return res.status(400).json({
                    error: "CONTEXTO_INCOMPLETO"
                });
            }

            // ===============================================================
            // VERIFICAÇÃO DE PERFIL: Impede admin de acessar módulos operacionais
            // ===============================================================
            const perfilUsuario = req.user.perfil?.toUpperCase() || '';
            const idPerfilNumerico = parseInt(id_perfil);
            
            // Buscar o nome do perfil que está sendo selecionado
            const conn = await require("../config/database").getConnection();
            try {
                const [perfis] = await conn.query(
                    "SELECT nome FROM perfil WHERE id_perfil = ?",
                    [idPerfilNumerico]
                );
                
                if (perfis.length > 0) {
                    const perfilSelecionado = perfis[0].nome?.toUpperCase() || '';
                    
                    // Se o usuário é ADMIN, só pode selecionar perfis de ADMIN
                    if (perfilUsuario.includes('ADMIN') || perfilUsuario.includes('SUPORTE') || perfilUsuario.includes('TI')) {
                        if (!perfilSelecionado.includes('ADMIN') && !perfilSelecionado.includes('SUPORTE') && !perfilSelecionado.includes('TI')) {
                            return res.status(403).json({
                                error: "PERFIL_INVALIDO",
                                mensagem: "Administradores só podem acessar módulos administrativos."
                            });
                        }
                    }
                    
                    // Se o usuário é médico, só pode selecionar perfis de médico
                    if (perfilUsuario.includes('MEDICO') || perfilUsuario.includes('CLÍNICO')) {
                        if (!perfilSelecionado.includes('MEDICO') && !perfilSelecionado.includes('CLÍNICO')) {
                            return res.status(403).json({
                                error: "PERFIL_INVALIDO",
                                mensagem: "Médicos só podem acessar módulos médicos."
                            });
                        }
                    }
                    
                    // Se o usuário é enfermeiro, só pode selecionar perfis de enfermagem
                    if (perfilUsuario.includes('ENFERMAGEM') || perfilUsuario.includes('ENFERMEIRO')) {
                        if (!perfilSelecionado.includes('ENFERMAGEM') && !perfilSelecionado.includes('ENFERMEIRO') && !perfilSelecionado.includes('TRIAGEM')) {
                            return res.status(403).json({
                                error: "PERFIL_INVALIDO",
                                mensagem: "Profissionais de enfermagem só podem acessar módulos de enfermagem ou triagem."
                            });
                        }
                    }
                }
            } catch (err) {
                console.error("Erro ao validar perfil:", err);
                return res.status(500).json({
                    error: "ERRO_AO_VALIDAR_PERFIL",
                    mensagem: "Erro ao validar perfil do usuário."
                });
            } finally {
                conn.release();
            }

            const payload = {
                id_usuario: req.user.id_usuario,
                id_sessao_usuario: req.user.id_sessao_usuario,
                id_unidade,
                id_local_operacional,
                id_perfil
            };

            const result = await LoginContextService.selecionarContexto(payload);

            if (result.error) {
                return res.status(400).json({ error: result.error });
            }

            return res.json(result);

        } catch (err) {
            console.error("Erro ao selecionar contexto:", err);
            return res.status(500).json({
                error: "ERRO_AO_SELECIONAR_CONTEXTO"
            });
        }
    }

    /**
     * Logout - encerra a sessão atual
     */
    static async logout(req, res) {
        try {
            const id_sessao_usuario = req.user.id_sessao_usuario;
            
            const result = await LoginContextService.logout(id_sessao_usuario);
            
            return res.json(result);

        } catch (err) {
            console.error("Erro ao fazer logout:", err);
            return res.status(500).json({
                error: "ERRO_AO_FAZER_LOGOUT"
            });
        }
    }

    /**
     * Retorna o contexto atual do usuário
     */
    static async contextoAtual(req, res) {
        try {
            // O middleware já carregou o contexto em req.runtime
            if (!req.runtime) {
                return res.status(401).json({ error: "SEM_AUTENTICACAO" });
            }

            return res.json({
                usuario: req.runtime.usuario,
                sessao: req.runtime.sessao,
                contexto: {
                    unidade: req.runtime.contexto.unidade,
                    local: req.runtime.contexto.local,
                    dispositivo: req.runtime.contexto.dispositivo
                },
                perfil: req.runtime.perfil
            });

        } catch (err) {
            console.error("Erro ao buscar contexto atual:", err);
            return res.status(500).json({
                error: "ERRO_AO_BUSCAR_CONTEXTO"
            });
        }
    }

    /**
     * Sync - sincronização automática de runtime para offline/online
     */
    static async sync(req, res) {
        try {
            // O middleware já carregou o contexto em req.runtime
            if (!req.runtime) {
                return res.status(401).json({ error: "SEM_AUTENTICACAO" });
            }

            // Retorna runtime completo para sincronização
            return res.json({
                sucesso: true,
                usuario: req.runtime.usuario,
                sessao: req.runtime.sessao,
                contexto: {
                    unidade: req.runtime.contexto.unidade,
                    local: req.runtime.contexto.local,
                    dispositivo: req.runtime.contexto.dispositivo
                },
                contextos: req.runtime.contextos || [],
                permissoes: req.runtime.permissoes || [],
                perfil: req.runtime.perfil,
                runtime: req.runtime.perfis // Array de perfis com contextos, filas
            });

        } catch (err) {
            console.error("Erro na sincronização:", err);
            return res.status(500).json({
                error: "ERRO_SINCRONIZACAO"
            });
        }
    }

}

module.exports = AuthController;


