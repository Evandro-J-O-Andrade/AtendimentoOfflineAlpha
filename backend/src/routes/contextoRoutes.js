const express = require("express");
const authMiddleware = require("../auth/authMiddleware");
const { executeSPMaster } = require("../services/spMasterService.js");
const db = require("../config/database");

const router = express.Router();

/**
 * Função auxiliar para registrar auditoria de contexto
 */
async function logAuditoriaContexto(id_sessao_usuario, id_usuario, acao, detalhes) {
    let conn;
    try {
        conn = await db.getConnection();
        await conn.query(
            `INSERT INTO auditoria_contexto
             (id_sessao_usuario, id_usuario, acao, detalhes, criado_em)
             VALUES (?, ?, ?, ?, NOW(6))`,
            [id_sessao_usuario, id_usuario, acao, JSON.stringify(detalhes)]
        );
    } catch (err) {
        console.warn("Falha ao registrar auditoria de contexto:", err.message);
    } finally {
        if (conn) conn.release();
    }
}

/**
 * Função auxiliar para registrar histórico de contexto
 */
async function registrarHistoricoContexto(id_sessao_usuario, contextoAtual, contextoNovo) {
    let conn;
    try {
        conn = await db.getConnection();
        await conn.query(
            `INSERT INTO sessao_contexto_historico
             (id_sessao_usuario, contexto_anterior, contexto_novo, criado_em)
             VALUES (?, ?, ?, NOW(6))`,
            [id_sessao_usuario, JSON.stringify(contextoAtual), JSON.stringify(contextoNovo)]
        );
    } catch (err) {
        console.warn("Falha ao registrar histórico de contexto:", err.message);
    } finally {
        if (conn) conn.release();
    }
}

/**
 * GET /api/contextos
 * Busca todos os contextos disponíveis para o usuário
 */
router.get("/", authMiddleware, async (req, res) => {
    const { id_sessao_usuario, id_usuario } = req.user;

    if (!id_sessao_usuario) {
        return res.status(401).json({ sucesso: false, erro: "SESSAO_NAO_INFORMADA" });
    }

    try {
        // chamada direta à SP canônica
        const [rs] = await db.query("CALL sp_auth_contexto_get(?)", [id_sessao_usuario]);
        const unidades = rs?.[0] || [];
        const perfis = rs?.[1] || [];
        const salas = rs?.[2] || [];
        const contextoAtual = rs?.[3]?.[0] || null;
        const locais = salas; // manter compat com clientes antigos
        const especialidades = [];

        await logAuditoriaContexto(id_sessao_usuario, id_usuario, "GET_CONTEXTOS", {});

        res.json({
            sucesso: true,
            resultado: { unidades, locais, perfis, salas, especialidades, contextoAtual }
        });

    } catch (err) {
        console.error("Erro ao buscar contextos:", err);
        res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO", mensagem: err.message });
    }
});

/**
 * POST /api/contextos
 * Ativa um contexto específico para a sessão
 */
router.post("/", authMiddleware, async (req, res) => {
    const { id_sessao_usuario, id_usuario } = req.user;
    const { id_unidade, id_local, id_perfil, id_sala } = req.body;

    if (!id_sessao_usuario || !id_unidade || !id_perfil) {
        return res.status(400).json({ 
            sucesso: false, 
            erro: "CAMPOS_OBRIGATORIOS", 
            mensagem: "id_sessao_usuario, id_unidade e id_perfil são obrigatórios" 
        });
    }

    try {
        const [rows] = await db.query(
            "CALL sp_auth_contexto_set(?, ?, ?, ?)",
            [id_sessao_usuario, id_unidade, id_perfil, id_local]
        );

        await logAuditoriaContexto(id_sessao_usuario, id_usuario, "SET_CONTEXTOS", {
            id_unidade, id_local, id_perfil, id_sala
        });

        res.json({
            sucesso: true,
            resultado: rows?.[0]?.[0] || { id_unidade, id_local, id_perfil, id_sala }
        });

    } catch (err) {
        console.error("Erro ao ativar contexto:", err);
        res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO", mensagem: err.message });
    }
});

/**
 * GET /api/contextos/atual
 * Retorna o contexto atual da sessão
 */
router.get("/atual", authMiddleware, async (req, res) => {
    const { id_sessao_usuario, id_usuario } = req.user;

    if (!id_sessao_usuario) {
        return res.status(401).json({ sucesso: false, erro: "SESSAO_NAO_INFORMADA" });
    }

    let conn;
    try {
        conn = await db.getConnection();

        const [sessao] = await conn.query(
            `SELECT 
                su.id_unidade, su.id_local, su.id_perfil, su.id_sala,
                u.nome as unidade_nome, l.nome as local_nome, p.nome as perfil_nome, s.nome_exibicao as sala_nome
             FROM sessao_usuario su
             LEFT JOIN unidade u ON u.id_unidade = su.id_unidade
             LEFT JOIN local l ON l.id_local = su.id_local
             LEFT JOIN perfil p ON p.id_perfil = su.id_perfil
             LEFT JOIN sala s ON s.id_sala = su.id_sala
             WHERE su.id_sessao_usuario = ?`,
            [id_sessao_usuario]
        );

        if (!sessao.length) {
            return res.json({ sucesso: false, erro: "SESSAO_NAO_ENCONTRADA" });
        }

        // Auditoria de leitura do contexto atual
        await logAuditoriaContexto(id_sessao_usuario, id_usuario, "GET_CONTEXTO_ATUAL", {});

        res.json({ sucesso: true, resultado: sessao[0] });

    } catch (err) {
        console.error("Erro ao buscar contexto atual:", err);
        res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
    } finally {
        if (conn) conn.release();
    }
});

module.exports = router;
