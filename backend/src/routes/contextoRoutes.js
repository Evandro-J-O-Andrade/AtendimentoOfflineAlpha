const express = require("express");
const router = express.Router();
const authMiddleware = require("../auth/authMiddleware");

/**
 * ======================================
 * ROTAS DE CONTEXTO
 * Sistema de seleção e ativação de contexto operacional
 * ======================================
 */

/**
 * GET /api/contexto
 * Busca contextos disponíveis para o usuário
 */
router.get("/", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        const id_usuario = req.user.id_usuario;

        // Busca sistemas do usuário
        const [sistemas] = await conn.query(`
            SELECT DISTINCT s.id_sistema, s.nome as nome
            FROM usuario_sistema us
            JOIN sistema s ON s.id_sistema = us.id_sistema
            WHERE us.id_usuario = ? AND us.ativo = 1
        `, [id_usuario]);

        // Busca unidades do usuário
        const [unidades] = await conn.query(`
            SELECT DISTINCT u.id_unidade, u.nome
            FROM usuario_unidade uu
            JOIN unidade u ON u.id_unidade = uu.id_unidade
            WHERE uu.id_usuario = ? AND uu.ativo = 1
        `, [id_usuario]);

        // Busca locais operacionais do usuário
        const [locais] = await conn.query(`
            SELECT DISTINCT l.id_local_operacional, l.nome, l.tipo
            FROM usuario_local_operacional ulo
            JOIN local_operacional l ON l.id_local_operacional = ulo.id_local_operacional
            WHERE ulo.id_usuario = ? AND l.ativo = 1
        `, [id_usuario]);

        res.json({
            sistemas,
            unidades,
            locais
        });

    } catch (err) {
        console.error("Erro ao buscar contextos:", err);
        res.status(500).json({ error: "ERRO_AO_BUSCAR_CONTEXTOS" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/contexto/ativar
 * Ativa um contexto específico para a sessão
 */
router.post("/ativar", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const { 
            id_sistema, 
            id_unidade, 
            id_local_operacional 
        } = req.body;

        const id_sessao = req.user.id_sessao_usuario;
        const id_usuario = req.user.id_usuario;

        if (!id_sistema || !id_unidade || !id_local_operacional) {
            return res.status(400).json({ 
                error: "PARAMETROS_OBRIGATORIOS",
                message: "id_sistema, id_unidade e id_local_operacional são obrigatórios"
            });
        }

        // Valida se o contexto pertence ao usuário
        const [validacoes] = await conn.query(`
            SELECT 1 FROM usuario_contexto uc
            WHERE uc.id_usuario = ? 
            AND uc.id_sistema = ? 
            AND uc.id_unidade = ? 
            AND uc.id_local_operacional = ?
            AND uc.ativo = 1
            LIMIT 1
        `, [id_usuario, id_sistema, id_unidade, id_local_operacional]);

        if (validacoes.length === 0) {
            // Se não encontrou, tenta criar automaticamente
            await conn.query(`
                INSERT INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo)
                VALUES (?, ?, ?, ?, 1, 1)
                ON DUPLICATE KEY UPDATE ativo = 1
            `, [id_usuario, id_sistema, id_unidade, id_local_operacional]);
        }

        // Atualiza a sessão com o contexto
        await conn.query(`
            UPDATE sessao_usuario
            SET id_sistema = ?,
                id_unidade = ?,
                id_local_operacional = ?,
                ultimo_heartbeat = NOW()
            WHERE id_sessao_usuario = ?
        `, [id_sistema, id_unidade, id_local_operacional, id_sessao]);

        // Busca o perfil do contexto
        const [perfil] = await conn.query(`
            SELECT p.id_perfil, p.nome as perfil_nome
            FROM usuario_contexto uc
            JOIN perfil p ON p.id_perfil = uc.id_perfil
            WHERE uc.id_usuario = ?
            AND uc.id_sistema = ?
            AND uc.id_unidade = ?
            AND uc.id_local_operacional = ?
            AND uc.ativo = 1
        `, [id_usuario, id_sistema, id_unidade, id_local_operacional]);

        res.json({
            success: true,
            message: "Contexto ativado com sucesso",
            contexto: {
                id_sistema,
                id_unidade,
                id_local_operacional,
                perfil: perfil.length > 0 ? perfil[0] : null
            }
        });

    } catch (err) {
        console.error("Erro ao ativar contexto:", err);
        res.status(500).json({ error: "ERRO_AO_ATIVAR_CONTEXTO" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * GET /api/contexto/atual
 * Retorna o contexto atual da sessão
 */
router.get("/atual", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const id_sessao = req.user.id_sessao_usuario;

        const [sessao] = await conn.query(`
            SELECT 
                s.id_sistema,
                s.nome as sistema_nome,
                u.id_unidade,
                u.nome as unidade_nome,
                lo.id_local_operacional,
                lo.nome as local_nome,
                p.id_perfil,
                p.nome as perfil_nome
            FROM sessao_usuario su
            LEFT JOIN sistema s ON s.id_sistema = su.id_sistema
            LEFT JOIN unidade u ON u.id_unidade = su.id_unidade
            LEFT JOIN local_operacional lo ON lo.id_local_operacional = su.id_local_operacional
            LEFT JOIN perfil p ON p.id_perfil = su.id_perfil
            WHERE su.id_sessao_usuario = ?
        `, [id_sessao]);

        if (sessao.length === 0) {
            return res.status(404).json({ error: "SESSAO_NAO_ENCONTRADA" });
        }

        res.json({ contexto: sessao[0] });

    } catch (err) {
        console.error("Erro ao buscar contexto atual:", err);
        res.status(500).json({ error: "ERRO_AO_BUSCAR_CONTEXTO" });
    } finally {
        if (conn) conn.release();
    }
});

module.exports = router;
