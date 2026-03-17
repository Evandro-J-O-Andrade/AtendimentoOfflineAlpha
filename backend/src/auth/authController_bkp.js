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
 * Chama sp_master_login - Procedure master de autenticação
 */
async function callMasterLogin(conn, p_acao, payload) {
    // Prepara o payload JSON
    const payloadJson = JSON.stringify(payload);
    
    // Inicializa as variáveis de saída
    await conn.query("SET @p_resultado = NULL, @p_sucesso = FALSE, @p_mensagem = NULL");
    
    // Chama a SP com parâmetros IN e OUT
    await conn.query(
        "CALL sp_master_login(?, ?, @p_resultado, @p_sucesso, @p_mensagem)",
        [p_acao, payloadJson]
    );
    
    // Busca os valores das variáveis de saída
    const [rows] = await conn.query(
        "SELECT @p_resultado AS resultado, @p_sucesso AS sucesso, @p_mensagem AS mensagem"
    );
    
    const row = rows[0];
    return {
        resultado: row?.resultado ? JSON.parse(row.resultado) : {},
        sucesso: !!row?.sucesso,
        mensagem: row?.mensagem
    };
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
                    acao: "CHECK_USER_FAIL",
                    mensagem: `Usuário não encontrado: ${usuario}`,
                    contexto: { usuario },
                    req,
                });
                return res.json({ sucesso: false, existe: false });
            }

            return res.json({
                sucesso: true,
                existe: true,
                usuario: {
                    id_usuario: rows[0].id_usuario,
                    login: rows[0].login,
                    ativo: !!rows[0].ativo,
                },
            });
        } catch (err) {
            console.error("Erro /checkUser:", err.message);
            return res.status(500).json({ sucesso: false, erro: "ERRO_DE_CONEXAO" });
        } finally {
            if (conn) conn.release();
        }
    }

    /**
     * LOGIN via sp_master_login - Procedure master
     * Fluxo: Backend valida senha com bcrypt -> Gera JWT -> Envia token para SP
     */
    static async login(req, res) {
        const { login, senha, ip: reqIp, device, id_unidade, id_local, id_perfil } = req.body;
        
        const ip = reqIp || req.headers["x-forwarded-for"] || req.socket.remoteAddress || null;
        const userAgent = device || req.headers["user-agent"] || null;

        // Valida credenciais obrigatórias
        if (!login || !senha) {
            return res.json({ 
                sucesso: false, 
                erro: "CREDENCIAIS_OBRIGATORIAS",
                mensagem: "Login e senha são obrigatórios" 
            });
        }

        let conn;
        try {
            conn = await pool.getConnection();

            // ============================================================
            // PASSO 1: Buscar usuário e senha hash no banco
            // ============================================================
            const [userRows] = await conn.execute(
                `SELECT id_usuario, login, senha_hash, ativo 
                 FROM usuario 
                 WHERE login = ? LIMIT 1`,
                [login]
            );

            if (!userRows.length) {
                await registrarEventoAuditoria({
                    acao: "LOGIN_FAIL",
                    mensagem: "Usuário não encontrado",
                    contexto: { login },
                    req,
                });
                return res.json({ 
                    sucesso: false, 
                    erro: "USUARIO_NAO_ENCONTRADO",
                    mensagem: "Usuário não encontrado" 
                });
            }

            const usuario = userRows[0];

            // Verifica se usuário está ativo
            if (usuario.ativo !== 1) {
                return res.json({ 
                    sucesso: false, 
                    erro: "USUARIO_INATIVO",
                    mensagem: "Usuário inativo" 
                });
            }

            // ============================================================
            // PASSO 2: Validar senha com bcrypt.compare()
            // ============================================================
            const senhaValida = await bcrypt.compare(senha, usuario.senha_hash);
            
            if (!senhaValida) {
                // Registra tentativa fracasso
                await conn.execute(
                    `INSERT INTO login_tentativa 
                     (id_usuario, login, ip_origem, dispositivo_origem, sucesso, metadata, criado_em) 
                     VALUES (?, ?, ?, ?, 0, ?, NOW(6))`,
                    [usuario.id_usuario, login, ip || '0.0.0.0', userAgent || 'unknown', 
                     JSON.stringify({motivo: 'senha_invalida', unidade: id_unidade, local: id_local})]
                );

                await registrarEventoAuditoria({
                    acao: "LOGIN_FAIL",
                    mensagem: "Senha inválida",
                    contexto: { login },
                    req,
                });
                return res.json({ 
                    sucesso: false, 
                    erro: "SENHA_INVALIDA",
                    mensagem: "Senha incorreta" 
                });
            }

            // ============================================================
            // PASSO 3: Buscar contexto do usuário (unidade, local, perfil)
            // ============================================================
            const contextos = await carregarContextos(conn, usuario.id_usuario);
            const ctx = contextos[0];
            
            // Usa os dados do contexto ou os defaults
            const v_id_unidade = ctx?.id_unidade || 1;
            const v_id_local = ctx?.id_local_operacional || 1;
            const v_id_perfil = ctx?.id_perfil || 1;
            const v_id_sistema = ctx?.id_sistema || 1;

            // ============================================================
            // PASSO 4: Gerar JWT (antes de chamar SP)
            // ============================================================
            const jwtToken = jwt.sign(
                {
                    id_usuario: usuario.id_usuario,
                    login: usuario.login,
                    id_unidade: v_id_unidade,
                    id_local: v_id_local,
                    id_perfil: v_id_perfil,
                },
                SECRET,
                { expiresIn: EXPIRES_IN }
            );

            // ============================================================
            // PASSO 5: Chama a SP master com token_jwt no payload
            // ============================================================
            const payload = {
                login: login,
                token_jwt: jwtToken,  // SP recebe o JWT validado
                ip: ip || '0.0.0.0',
                device: userAgent || 'unknown',
                id_unidade: v_id_unidade,
                id_local: v_id_local,
                id_perfil: v_id_perfil
            };

            // Chama a SP master
            const spResult = await callMasterLogin(conn, 'LOGIN', payload);

            // Se login falhou na SP
            if (!spResult.sucesso) {
                const erroMap = {
                    'CREDENCIAIS_OBRIGATORIAS': 'CREDENCIAIS_OBRIGATORIAS',
                    'USUARIO_NAO_ENCONTRADO': 'USUARIO_NAO_ENCONTRADO',
                    'USUARIO_INATIVO': 'USUARIO_INATIVO',
                    'USUARIO_BLOQUEADO_TEMP': 'USUARIO_BLOQUEADO_TEMP',
                    'SENHA_INVALIDA': 'SENHA_INVALIDA'
                };
                
                await registrarEventoAuditoria({
                    acao: "LOGIN_FAIL",
                    mensagem: spResult.mensagem,
                    contexto: { login },
                    req,
                });

                return res.json({ 
                    sucesso: false, 
                    erro: erroMap[spResult.mensagem] || 'LOGIN_FALHOU',
                    mensagem: spResult.mensagem 
                });
            }

            // Parse do resultado
            const resultado = spResult.resultado || {};
            const sessao = resultado?.sessao || {};
            const usuarioRetorno = resultado?.usuario || {};

            const id_usuario = usuarioRetorno.id_usuario;
            const id_sessao_usuario = sessao.id_sessao_usuario;

            if (!id_usuario) {
                return res.json({ 
                    sucesso: false, 
                    erro: 'ERRO_INTERNO',
                    mensagem: 'SP não retornou id_usuario' 
                });
            }

            // Registra auditoria
            await registrarEventoAuditoria({
                acao: "LOGIN_OK",
                usuario: id_usuario,
                sessao: id_sessao_usuario,
                mensagem: "Login bem-sucedido via sp_master_login (bcrypt+JWT)",
                contexto: { id_sistema: v_id_sistema, id_unidade: v_id_unidade },
                req,
            });

            // Retorna sucesso com JWT gerado
            return res.json({
                sucesso: true,
                sessao: {
                    id_sessao_usuario,
                    id_usuario
                },
                usuario: {
                    id_usuario,
                    login: login,
                    unidade: v_id_unidade,
                    local: v_id_local,
                    perfil: v_id_perfil
                },
                token: jwtToken  // Retorna o mesmo JWT que foi enviado para SP
            });

        } catch (err) {
            console.error("Erro no login:", err);
            await registrarEventoAuditoria({
                acao: "LOGIN_ERRO",
                mensagem: err.message,
                contexto: { login },
                req,
            });
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO", mensagem: err.message });
        } finally {
            if (conn) conn.release();
        }
    }

    /**
     * LOGOUT via sp_master_login
     */
    static async logout(req, res) {
        const { id_sessao_usuario } = req.body;
        
        if (!id_sessao_usuario) {
            return res.json({ sucesso: false, erro: "SESSAO_OBRIGATORIA" });
        }

        let conn;
        try {
            conn = await pool.getConnection();
            
            const payload = { id_sessao_usuario };
            const spResult = await callMasterLogin(conn, 'LOGOUT', payload);

            if (!spResult.sucesso) {
                return res.json({ sucesso: false, erro: spResult.mensagem });
            }

            return res.json({
                sucesso: true,
                id_sessao_usuario,
                mensagem: "Logout realizado"
            });

        } catch (err) {
            console.error("Erro no logout:", err);
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
        } finally {
            if (conn) conn.release();
        }
    }

    /**
     * Lista todos os contextos disponíveis no sistema
     */
    static async listarContextos(req, res) {
        let conn;
        try {
            conn = await pool.getConnection();
            const [rows] = await conn.execute(
                `SELECT DISTINCT s.id_sistema, s.nome AS nome_sistema, 
                        u.id_unidade, u.nome AS nome_unidade,
                        l.id_local_operacional, l.descricao AS nome_local
                 FROM sistema s
                 LEFT JOIN unidade u ON u.id_sistema = s.id_sistema
                 LEFT JOIN local_operacional l ON l.id_sistema = s.id_sistema
                 WHERE s.ativo = 1
                 ORDER BY s.nome, u.nome, l.descricao`
            );
            return res.json({ sucesso: true, contextos: rows });
        } catch (err) {
            console.error("Erro listarContextos:", err.message);
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
        } finally {
            if (conn) conn.release();
        }
    }

    /**
     * Permissões por perfil
     */
    static async permissoesPorPerfil(req, res) {
        const { idPerfil } = req.params;
        let conn;
        try {
            conn = await pool.getConnection();
            const [rows] = await conn.execute(
                `SELECT p.codigo, p.nome, p.descricao 
                 FROM perfil_permissao pp
                 JOIN permissao p ON p.id_permissao = pp.id_permissao
                 WHERE pp.id_perfil = ? AND pp.ativo = 1`,
                [idPerfil]
            );
            return res.json({ sucesso: true, permissoes: rows });
        } catch (err) {
            console.error("Erro permissoesPorPerfil:", err.message);
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
        } finally {
            if (conn) conn.release();
        }
    }
}

module.exports = AuthController;
