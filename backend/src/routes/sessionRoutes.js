const express = require("express");
const pool = require("../config/database");
const authMiddleware = require("../auth/authMiddleware");

const router = express.Router();

// Retorna sessão completa: usuário, contexto do token e permissões do perfil
router.get("/session", authMiddleware, async (req, res) => {
    let {
        id_usuario,
        id_sessao_usuario,
        id_sistema,
        id_unidade,
        id_local_operacional,
        id_perfil,
    } = req.user || {};

    // Se não tiver id_perfil no token, busca da sessão no banco
    if (!id_perfil && id_sessao_usuario) {
        try {
            const [sessaoRows] = await pool.query(
                `SELECT id_perfil, id_sistema, id_unidade, id_local_operacional 
                   FROM sessao_usuario WHERE id_sessao_usuario = ?`,
                [id_sessao_usuario]
            );
            if (sessaoRows?.[0]) {
                id_perfil = sessaoRows[0].id_perfil;
                id_sistema = id_sistema || sessaoRows[0].id_sistema;
                id_unidade = id_unidade || sessaoRows[0].id_unidade;
                id_local_operacional = id_local_operacional || sessaoRows[0].id_local_operacional;
            }
        } catch (e) {
            console.warn("Falha ao buscar perfil da sessão:", e.message);
        }
    }

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

        // Busca contextos disponíveis do usuário - usando tabela 'local' não 'local_operacional'
        let contextos = [];
        try {
            const [ctxRows] = await pool.query(
                `SELECT uc.id_sistema, uc.id_unidade, uc.id_local_operacional, uc.id_perfil,
                        s.nome AS sistema_nome, u.nome AS unidade_nome, l.descricao AS local_nome,
                        p.nome AS perfil_nome
                   FROM usuario_contexto uc
                   LEFT JOIN sistema s ON s.id_sistema = uc.id_sistema
                   LEFT JOIN unidade u ON u.id_unidade = uc.id_unidade
                   LEFT JOIN local l ON l.id_local = uc.id_local_operacional
                   LEFT JOIN perfil p ON p.id_perfil = uc.id_perfil
                  WHERE uc.id_usuario = ? AND uc.ativo = 1`,
                [id_usuario]
            );
            contextos = ctxRows || [];
        } catch (e) {
            console.warn("Falha ao buscar contextos:", e.message);
        }

        // Se não encontrou contextos, cria um padrão
        if (!contextos.length) {
            contextos = [{
                id_sistema: id_sistema || 1,
                id_unidade: id_unidade || 1,
                id_local_operacional: id_local_operacional || 1,
                id_perfil: id_perfil || 42,
                sistema_nome: 'Sistema Principal',
                unidade_nome: 'Unidade Principal',
                local_nome: 'Recepção',
                perfil_nome: 'Administrador'
            }];
        }

        // Permissões por perfil/sistema
        let permissoes = [];
        if (id_perfil) {
            try {
                const [permRows] = await pool.query(
                    `SELECT p.codigo, p.acao_frontend, p.grupo_menu, p.nome, p.icone, p.ordem_menu, p.nome_procedure AS url_menu
                       FROM permissao p
                       JOIN perfil_permissao pp ON pp.id_permissao = p.id_permissao
                      WHERE pp.id_perfil = ? AND p.ativo = 1
                      ORDER BY p.ordem_menu, p.nome`,
                    [id_perfil]
                );
                permissoes = permRows || [];
            } catch (e) {
                console.warn("/api/session permissoes falhou:", e.message);
            }
        }

        return res.json({ usuario, contexto, contextos, permissoes });
    } catch (err) {
        console.error("/api/session erro:", err.message);
        return res.status(500).json({ erro: "ERRO_DE_CONEXAO" });
    }
});

module.exports = router;
