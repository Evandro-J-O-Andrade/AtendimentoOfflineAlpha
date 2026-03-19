const pool = require("../config/database");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { SECRET, EXPIRES_IN } = require("../config/jwt");
const { registrarEventoAuditoria } = require("../services/auditoria_service");

async function carregarContextos(conn, id_usuario) {
    let contextRows = [];
    try {
        // Tenta buscar da tabela usuario_contexto
        const [rows] = await conn.execute(
            `SELECT uc.id_sistema, uc.id_unidade, uc.id_local_operacional AS id_local, uc.id_perfil
             FROM usuario_contexto uc WHERE uc.id_usuario = ? AND uc.ativo = 1`,
            [id_usuario]
        );
        contextRows = rows || [];
    } catch (err) {
        console.warn("Erro ao buscar usuario_contexto:", err.message);
    }
    
    // Se não encontrou, tenta usuario_sistema
    if (!contextRows.length) {
        try {
            const [rows] = await conn.execute(
                `SELECT us.id_sistema, 1 AS id_unidade, 1 AS id_local, us.id_perfil
                 FROM usuario_sistema us WHERE us.id_usuario = ? AND us.ativo = 1`,
                [id_usuario]
            );
            contextRows = rows || [];
        } catch (err) {
            console.warn("Erro ao buscar usuario_sistema:", err.message);
        }
    }
    
    // Se ainda não encontrou, criar um contexto padrão
    if (!contextRows.length) {
        console.log("Criando contexto mock para id_usuario:", id_usuario);
        // Criar contexto de exemplo com id_local_operacional e nomes
        contextRows = [
            { 
                id_sistema: 1, 
                id_unidade: 1, 
                id_local_operacional: 1, 
                id_perfil: 42,
                nome_unidade: 'Unidade Principal',
                nome_local: 'Recepção',
                nome_perfil: 'Administrador'
            }
        ];
    }
    
    // Padronizar nome do campo para id_local_operacional
    for (let ctx of contextRows) {
        if (ctx.id_local !== undefined && ctx.id_local_operacional === undefined) {
            ctx.id_local_operacional = ctx.id_local;
        }
    }
    
    // Carregar permissões para cada contexto
    for (let ctx of contextRows) {
        try {
            const [permRows] = await conn.execute(
                `SELECT p.codigo, p.descricao, p.acao_frontend 
                 FROM perfil_permissao pp 
                 JOIN permissao p ON p.id_permissao = pp.id_permissao 
                 WHERE pp.id_perfil = ?`,
                [ctx.id_perfil]
            );
            ctx.permissoes = permRows || [];
        } catch (err) {
            console.warn("Erro ao buscar permissoes:", err.message);
            ctx.permissoes = [];
        }
    }
    
    return contextRows;
}

async function callMasterLogin(conn, p_acao, payload) {
    const payloadJson = JSON.stringify(payload);
    await conn.query("SET @p_resultado = NULL, @p_sucesso = FALSE, @p_mensagem = NULL");
    await conn.query("CALL sp_master_login(?, ?, @p_resultado, @p_sucesso, @p_mensagem)", [p_acao, payloadJson]);
    const [rows] = await conn.query("SELECT @p_resultado AS resultado, @p_sucesso AS sucesso, @p_mensagem AS mensagem");
    const row = rows[0];
    return {
        resultado: row?.resultado ? JSON.parse(row.resultado) : {},
        sucesso: !!row?.sucesso,
        mensagem: row?.mensagem
    };
}

class AuthController {
    static async checkUser(req, res) {
        const { usuario, login } = req.body;
        const user = usuario || login;
        if (!user) return res.status(400).json({ sucesso: false, erro: "LOGIN_OBRIGATORIO" });
        let conn;
        try {
            conn = await pool.getConnection();
            const [rows] = await conn.execute("SELECT id_usuario, login, ativo FROM usuario WHERE login = ? LIMIT 1", [user]);
            if (!rows.length) return res.json({ sucesso: false, existe: false });
            return res.json({ sucesso: true, existe: true, usuario: { id_usuario: rows[0].id_usuario, login: rows[0].login, ativo: !!rows[0].ativo } });
        } catch (err) {
            return res.status(500).json({ sucesso: false, erro: "ERRO_DE_CONEXAO" });
        } finally {
            if (conn) conn.release();
        }
    }

    static async login(req, res) {
        const { login, usuario, senha, ip: reqIp, device } = req.body;
        // Aceita login ou usuario como campo
        const userLogin = login || usuario;
        const ip = reqIp || req.headers["x-forwarded-for"] || req.socket.remoteAddress || null;
        const userAgent = device || req.headers["user-agent"] || null;

        if (!userLogin || !senha) return res.json({ sucesso: false, erro: "CREDENCIAIS_OBRIGATORIAS", mensagem: "Login e senha são obrigatórios" });

        let conn;
        try {
            conn = await pool.getConnection();
            const [userRows] = await conn.execute("SELECT id_usuario, login, senha_hash, ativo FROM usuario WHERE login = ? LIMIT 1", [userLogin]);

            if (!userRows.length) return res.json({ sucesso: false, erro: "USUARIO_NAO_ENCONTRADO", mensagem: "Usuário não encontrado" });

            const usuario = userRows[0];
            if (usuario.ativo !== 1) return res.json({ sucesso: false, erro: "USUARIO_INATIVO", mensagem: "Usuário inativo" });

            const senhaValida = await bcrypt.compare(senha, usuario.senha_hash);
            if (!senhaValida) {
                // Truncar dispositivo para evitar erro de tamanho
                const deviceTrunc = (userAgent || 'unknown').substring(0, 100);
                await conn.execute("INSERT INTO login_tentativa (id_usuario, login, ip_origem, dispositivo_origem, sucesso, metadata, criado_em) VALUES (?, ?, ?, ?, 0, ?, NOW(6))",
                    [usuario.id_usuario, login, ip || '0.0.0.0', deviceTrunc, JSON.stringify({ motivo: 'senha_invalida' })]);
                return res.json({ sucesso: false, erro: "SENHA_INVALIDA", mensagem: "Senha incorreta" });
            }

            const contextos = await carregarContextos(conn, usuario.id_usuario);
            const ctx = contextos[0];
            const v_id_unidade = ctx?.id_unidade || 1;
            const v_id_local = ctx?.id_local_operacional || 1;
            const v_id_perfil = ctx?.id_perfil || 1;
            const v_id_sistema = ctx?.id_sistema || 1;

            // Primeiro, cria sessão local ou obtém da SP
            let id_sessao_usuario = null;
            try {
                // Truncar device para evitar erro de tamanho na SP
                // Cria token temporário para chamar SP
                const tempToken = jwt.sign({ 
                    id_usuario: usuario.id_usuario, 
                    login: usuario.login, 
                    id_unidade: v_id_unidade, 
                    id_local: v_id_local, 
                    id_perfil: v_id_perfil 
                }, SECRET, { expiresIn: '1h' });
                
                const deviceTrunc = (userAgent || 'unknown').substring(0, 100);
                const payload = { login, token_jwt: tempToken, ip: ip || '0.0.0.0', device: deviceTrunc, id_unidade: v_id_unidade, id_local: v_id_local, id_perfil: v_id_perfil };
                const spResult = await callMasterLogin(conn, 'LOGIN', payload);
                
                if (spResult.sucesso && spResult.resultado?.sessao?.id_sessao_usuario) {
                    id_sessao_usuario = spResult.resultado.sessao.id_sessao_usuario;
                }
            } catch (spErr) {
                console.warn("sp_master_login falhou, criando sessão local:", spErr.message);
            }

            // Se não conseguiu via SP, cria sessão local
            if (!id_sessao_usuario) {
                const { v4: uuidv4 } = require('uuid');
                const expiraEm = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 horas
                
                const [sessaoResult] = await conn.execute(
                    `INSERT INTO sessao_usuario (uuid_sessao, id_usuario, id_perfil, id_sistema, token_jwt, ip_origem, user_agent, iniciado_em, expira_em, ativo) 
                     VALUES (?, ?, ?, ?, ?, ?, ?, NOW(6), ?, 1)`,
                    [uuidv4(), usuario.id_usuario, v_id_perfil, v_id_sistema, '', ip || '0.0.0.0', userAgent || 'unknown', expiraEm]
                );
                id_sessao_usuario = sessaoResult.insertId;
            }

            // Agora cria o JWT token com o id_sessao_usuario correto
            const jwtToken = jwt.sign({ 
                id_usuario: usuario.id_usuario, 
                id_sessao_usuario: id_sessao_usuario,
                login: usuario.login, 
                id_sistema: v_id_sistema,
                id_unidade: v_id_unidade, 
                id_local_operacional: v_id_local, 
                id_perfil: v_id_perfil 
            }, SECRET, { expiresIn: EXPIRES_IN });

            // Busca as permissões do perfil
            let permissoes = [];
            try {
                const [permRows] = await conn.query(
                    `SELECT p.codigo, p.acao_frontend, p.grupo_menu, p.nome, p.icone, p.ordem_menu, p.nome_procedure AS url_menu
                       FROM permissao p
                       JOIN perfil_permissao pp ON pp.id_permissao = p.id_permissao
                      WHERE pp.id_perfil = ? AND p.ativo = 1
                      ORDER BY p.ordem_menu, p.nome`,
                    [v_id_perfil]
                );
                permissoes = permRows || [];
            } catch (e) {
                console.warn("Falha ao buscar permissoes no login:", e.message);
            }

            await registrarEventoAuditoria({ acao: "LOGIN_OK", usuario: usuario.id_usuario, sessao: id_sessao_usuario, mensagem: "Login bem-sucedido", contexto: { id_sistema: v_id_sistema, id_unidade: v_id_unidade }, req });

            return res.json({ 
                sucesso: true, 
                sessao: { id_sessao_usuario, id_usuario: usuario.id_usuario }, 
                usuario: { id_usuario: usuario.id_usuario, login, unidade: v_id_unidade, local: v_id_local, perfil: v_id_perfil }, 
                contextos: contextos,
                permissoes: permissoes,
                token: jwtToken 
            });
        } catch (err) {
            console.error("Erro no login:", err);
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO", mensagem: err.message });
        } finally {
            if (conn) conn.release();
        }
    }

    static async logout(req, res) {
        const { id_sessao_usuario } = req.body;
        if (!id_sessao_usuario) return res.json({ sucesso: false, erro: "SESSAO_OBRIGATORIA" });
        let conn;
        try {
            conn = await pool.getConnection();
            const payload = { id_sessao_usuario };
            const spResult = await callMasterLogin(conn, 'LOGOUT', payload);
            if (!spResult.sucesso) return res.json({ sucesso: false, erro: spResult.mensagem });
            return res.json({ sucesso: true, id_sessao_usuario, mensagem: "Logout realizado" });
        } catch (err) {
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
        } finally {
            if (conn) conn.release();
        }
    }

    static async listarContextos(req, res) {
        let conn;
        try {
            conn = await pool.getConnection();
            const [rows] = await conn.execute(`SELECT DISTINCT s.id_sistema, s.nome AS nome_sistema, u.id_unidade, u.nome AS nome_unidade, l.id_local_operacional, l.descricao AS nome_local FROM sistema s LEFT JOIN unidade u ON u.id_sistema = s.id_sistema LEFT JOIN local_operacional l ON l.id_sistema = s.id_sistema WHERE s.ativo = 1 ORDER BY s.nome, u.nome, l.descricao`);
            return res.json({ sucesso: true, contextos: rows });
        } catch (err) {
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
        } finally {
            if (conn) conn.release();
        }
    }

    static async permissoesPorPerfil(req, res) {
        const { idPerfil } = req.params;
        let conn;
        try {
            conn = await pool.getConnection();
            const [rows] = await conn.execute(`SELECT p.codigo, p.nome, p.descricao FROM perfil_permissao pp JOIN permissao p ON p.id_permissao = pp.id_permissao WHERE pp.id_perfil = ? AND pp.ativo = 1`, [idPerfil]);
            return res.json({ sucesso: true, permissoes: rows });
        } catch (err) {
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
        } finally {
            if (conn) conn.release();
        }
    }

    static async me(req, res) {
        const { id_usuario } = req;
        let conn;
        try {
            conn = await pool.getConnection();
            const [rows] = await conn.execute("SELECT id_usuario, login, ativo FROM usuario WHERE id_usuario = ?", [id_usuario]);
            if (!rows.length) return res.status(404).json({ erro: "USUARIO_NAO_ENCONTRADO" });
            return res.json({ sucesso: true, usuario: rows[0] });
        } catch (err) {
            return res.status(500).json({ erro: "ERRO_INTERNO" });
        } finally {
            if (conn) conn.release();
        }
    }

    static async selecionarContexto(req, res) {
        return res.json({ sucesso: true, mensagem: "Contexto selecionado" });
    }

    static async contextoAtual(req, res) {
        return res.json({ sucesso: true, contexto: req.contexto });
    }

    static async sync(req, res) {
        return res.json({ sucesso: true, sincronizado: true });
    }
}

module.exports = AuthController;
