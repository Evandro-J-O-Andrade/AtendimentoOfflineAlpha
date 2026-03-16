const express = require("express");
const pool = require("../config/database");
const authMiddleware = require("../auth/authMiddleware");

const router = express.Router();

// Lista permissões/ações disponíveis para o perfil atual
router.get("/rotas", authMiddleware, async (req, res) => {
    const { id_perfil, id_sistema } = req.user || {};
    try {
        const [rows] = await pool.query(
            `SELECT 
                p.id_permissao,
                p.codigo,
                p.nome,
                p.grupo_menu,
                p.icone,
                p.ordem_menu,
                p.acao_frontend
             FROM permissao p
             JOIN perfil_permissao pp ON pp.id_permissao = p.id_permissao AND pp.ativo = 1
            WHERE pp.id_perfil = ?
              AND p.ativo = 1
              AND (p.id_sistema IS NULL OR p.id_sistema = ?)
            ORDER BY p.ordem_menu, p.nome`,
            [id_perfil || 1, id_sistema || 1]
        );

        res.json({ permissoes: rows });
    } catch (err) {
        console.error("Erro /permissoes/rotas:", err);
        res.status(500).json({ erro: "ERRO_DE_CONEXAO" });
    }
});

module.exports = router;
