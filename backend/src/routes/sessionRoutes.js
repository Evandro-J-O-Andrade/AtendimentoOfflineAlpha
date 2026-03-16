const express = require("express");
const pool = require("../config/database");
const authMiddleware = require("../auth/authMiddleware");

const router = express.Router();

// Retorna sessão completa: usuário, contexto do token e permissões do perfil
router.get("/session", authMiddleware, async (req, res) => {
    const {
        id_usuario,
        id_sessao_usuario,
        id_sistema,
        id_unidade,
        id_local_operacional,
        id_perfil,
    } = req.user || {};

    try {
        // Dados básicos do usuário
        const [userRows] = await pool.query(
            `SELECT id_usuario, login, ativo
               FROM usuario
              WHERE id_usuario = ?
              LIMIT 1`,
            [id_usuario]
        );
        const usuario = userRows?.[0] || { id_usuario, login: null };

        // Contexto atual (do token)
        const contexto = {
            id_sessao_usuario,
            id_sistema,
            id_unidade,
            id_local_operacional,
            id_perfil,
        };

        // Permissões por perfil/sistema (sem depender da view)
        let permissoes = [];
        try {
            const [permRows] = await pool.query(
                `SELECT p.codigo, p.acao_frontend, p.grupo_menu, p.nome, p.icone, p.ordem_menu, p.url_menu
                   FROM permissao p
                   JOIN perfil_permissao pp ON pp.id_permissao = p.id_permissao AND pp.ativo = 1
                  WHERE pp.id_perfil = ? AND p.ativo = 1
                  ORDER BY p.ordem_menu, p.nome`,
                [id_perfil]
            );
            permissoes = permRows || [];
        } catch (e) {
            console.warn("/api/session permissoes falhou:", e.message);
        }

        return res.json({ usuario, contexto, permissoes });
    } catch (err) {
        console.error("/api/session erro:", err.message);
        return res.status(500).json({ erro: "ERRO_DE_CONEXAO" });
    }
});

module.exports = router;
