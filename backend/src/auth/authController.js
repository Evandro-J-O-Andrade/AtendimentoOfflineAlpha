const pool = require("../config/database");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { SECRET, EXPIRES_IN } = require("../config/jwt");
const { registrarEventoAuditoria } = require("../services/auditoria_service");

async function carregarContextos(conn, id_usuario) {
    let contextRows = [];
    try {
        const [rows] = await conn.execute(
            `SELECT uc.id_sistema, uc.id_unidade, uc.id_local_operacional, uc.id_perfil
             FROM usuario_contexto uc WHERE uc.id_usuario = ? AND uc.ativo = 1`,
            [id_usuario]
        );
        contextRows = rows || [];
    } catch (err) {
        console.warn("Erro ao buscar usuario_contexto:", err.message);
    }
    if (!contextRows.length) {
        try {
            const [rows] = await conn.execute(
                `SELECT us.id_sistema, 1 AS id_unidade, 1 AS id_local_operacional, us.id_perfil
                 FROM usuario_sistema us WHERE us.id_usuario = ? AND us.ativo = 1`,
                [id_usuario]
            );
            contextRows = rows || [];
        } catch (err) {
            console.warn("Erro ao buscar usuario_sistema:", err.message);
        }
    }
    if (!contextRows.length) {
        contextRows = [{ id_sistema: 1, id_unidade: 1, id_local_operacional: 1, id_perfil: 1 }];
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
        const { login, senha, ip: reqIp, device } = req.body;
        const ip = reqIp || req.headers["x-forwarded-for"] || req.socket.remoteAddress || null;
        const userAgent = device || req.headers["user-agent"] || null;

        if (!login || !senha) return res.json({ sucesso: false, erro: "CREDENCIAIS_OBRIGATORIAS", mensagem: "Login e senha são obrigatórios" });

        let conn;
        try {
            conn = await pool.getConnection();
            const [userRows] = await conn.execute("SELECT id_usuario, login, senha_hash, ativo FROM usuario WHERE login = ? LIMIT 1", [login]);

            if (!userRows.length) return res.json({ sucesso: false, erro: "USUARIO_NAO_ENCONTRADO", mensagem: "Usuário não encontrado" });

            const usuario = userRows[0];
            if (usuario.ativo !== 1) return res.json({ sucesso: false, erro: "USUARIO_INATIVO", mensagem: "Usuário inativo" });

            const senhaValida = await bcrypt.compare(senha, usuario.senha_hash);
            if (!senhaValida) {
                await conn.execute("INSERT INTO login_tentativa (id_usuario, login, ip_origem, dispositivo_origem, sucesso, metadata, criado_em) VALUES (?, ?, ?, ?, 0, ?, NOW(6))",
                    [usuario.id_usuario, login, ip || '0.0.0.0', userAgent || 'unknown', JSON.stringify({ motivo: 'senha_invalida' })]);
                return res.json({ sucesso: false, erro: "SENHA_INVALIDA", mensagem: "Senha incorreta" });
            }

            const contextos = await carregarContextos(conn, usuario.id_usuario);
            const ctx = contextos[0];
            const v_id_unidade = ctx?.id_unidade || 1;
            const v_id_local = ctx?.id_local_operacional || 1;
            const v_id_perfil = ctx?.id_perfil || 1;
            const v_id_sistema = ctx?.id_sistema || 1;

            const jwtToken = jwt.sign({ id_usuario: usuario.id_usuario, login: usuario.login, id_unidade: v_id_unidade, id_local: v_id_local, id_perfil: v_id_perfil }, SECRET, { expiresIn: EXPIRES_IN });

            const payload = { login, token_jwt: jwtToken, ip: ip || '0.0.0.0', device: userAgent || 'unknown', id_unidade: v_id_unidade, id_local: v_id_local, id_perfil: v_id_perfil };
            const spResult = await callMasterLogin(conn, 'LOGIN', payload);

            if (!spResult.sucesso) return res.json({ sucesso: false, erro: spResult.mensagem || 'LOGIN_FALHOU', mensagem: spResult.mensagem });

            const resultado = spResult.resultado || {};
            const sessao = resultado?.sessao || {};
            const usuarioRetorno = resultado?.usuario || {};
            const id_usuario = usuarioRetorno.id_usuario;
            const id_sessao_usuario = sessao.id_sessao_usuario;

            if (!id_usuario) return res.json({ sucesso: false, erro: 'ERRO_INTERNO', mensagem: 'SP não retornou id_usuario' });

            await registrarEventoAuditoria({ acao: "LOGIN_OK", usuario: id_usuario, sessao: id_sessao_usuario, mensagem: "Login bem-sucedido", contexto: { id_sistema: v_id_sistema, id_unidade: v_id_unidade }, req });

            return res.json({ sucesso: true, sessao: { id_sessao_usuario, id_usuario }, usuario: { id_usuario, login, unidade: v_id_unidade, local: v_id_local, perfil: v_id_perfil }, token: jwtToken });
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
