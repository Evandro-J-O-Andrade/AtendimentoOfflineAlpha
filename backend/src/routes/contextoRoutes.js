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
        const { sucesso, resultado, mensagem } = await executeSPMaster(
            "GET",
            "AUTH.CONTEXTO_GET",
            id_sessao_usuario
        );

        // Fallback parrudo
        let unidades = resultado?.unidades || [{ id_unidade: 1, nome: "PRONTO ATENDIMENTO" }];
        let locais = resultado?.locais || [{ id_local: 0, nome: "NÃO DEFINIDA", tipo_nome: "GERAL" }];
        let perfis = resultado?.perfis || [
            { id_perfil: 1, nome: "RECEPÇÃO" },
            { id_perfil: 2, nome: "TRIAGEM" },
            { id_perfil: 3, nome: "MÉDICO" },
            { id_perfil: 4, nome: "ENFERMEIRO" },
            { id_perfil: 5, nome: "ADMINISTRATIVO" }
        ];
        let salas = resultado?.salas || [];
        let especialidades = resultado?.especialidades || [
            { id: 1, nome: "CLINICA GERAL" },
            { id: 2, nome: "PEDIATRIA" },
            { id: 3, nome: "EMERGENCIA" }
        ];

        // Hardening: se usuário for admin, mostra tudo
        let conn;
        try {
            conn = await db.getConnection();

            const [isAdminResult] = await conn.query(
                "SELECT COUNT(*) as isAdmin FROM usuario_perfil WHERE id_usuario = ? AND id_perfil = 42",
                [id_usuario]
            );
            const isAdmin = isAdminResult[0]?.isAdmin > 0;

            if (isAdmin) {
                const [allUnidades] = await conn.query(
                    "SELECT id_unidade, nome FROM unidade WHERE ativo = 1 ORDER BY nome"
                );
                unidades = allUnidades.length ? allUnidades : unidades;

                const [allSalas] = await conn.query(
                    `SELECT s.id_sala, s.nome_exibicao as nome, s.codigo, ts.nome as tipo_nome, ts.codigo as tipo_codigo,
                            s.permite_multiplas_especialidades, s.exibir_painel, s.gerar_tts, s.ativa
                     FROM sala s
                     LEFT JOIN tipo_sala ts ON ts.id_tipo_sala = s.id_tipo_sala
                     WHERE s.ativa = 1
                     ORDER BY ts.nome, s.nome_exibicao`
                );
                salas = allSalas.length ? allSalas : salas;
            }
        } catch (err) {
            console.warn("Erro ao verificar admin ou buscar dados adicionais:", err.message);
        } finally {
            if (conn) conn.release();
        }

        // Auditoria de acesso a contextos
        await logAuditoriaContexto(id_sessao_usuario, id_usuario, "GET_CONTEXTOS", {
            fallback: !sucesso,
            mensagem,
        });

        res.json({
            sucesso: true,
            resultado: { unidades, locais, perfis, salas, especialidades }
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

    let conn;
    try {
        conn = await db.getConnection();

        // Pega contexto atual para histórico
        const [sessaoAtual] = await conn.query(
            "SELECT id_unidade, id_local, id_perfil, id_sala FROM sessao_usuario WHERE id_sessao_usuario = ?",
            [id_sessao_usuario]
        );

        // Valida se unidade pertence ao usuário
        const [unidadeValida] = await conn.query(
            "SELECT 1 FROM usuario_unidade WHERE id_usuario = ? AND id_unidade = ? AND ativo = 1 LIMIT 1",
            [id_usuario, id_unidade]
        );

        if (!unidadeValida.length) {
            const [temQualquerUnidade] = await conn.query(
                "SELECT 1 FROM usuario_unidade WHERE id_usuario = ? AND ativo = 1 LIMIT 1",
                [id_usuario]
            );
            if (temQualquerUnidade.length > 0) {
                return res.status(400).json({
                    sucesso: false,
                    erro: "UNIDADE_INVALIDA",
                    mensagem: "Unidade não autorizada para este usuário"
                });
            }
        }

        // Atualiza sessão
        await conn.query(
            `UPDATE sessao_usuario
             SET id_unidade = ?, id_local = ?, id_perfil = ?, id_sala = ?
             WHERE id_sessao_usuario = ?`,
            [
                id_unidade,
                id_local === 0 || id_local === null ? null : id_local,
                id_perfil,
                id_sala === 0 || id_sala === null ? null : id_sala,
                id_sessao_usuario
            ]
        );

        // Auditoria
        await logAuditoriaContexto(id_sessao_usuario, id_usuario, "SET_CONTEXTOS", {
            id_unidade, id_local, id_perfil, id_sala
        });

        // Histórico
        await registrarHistoricoContexto(id_sessao_usuario, sessaoAtual[0] || {}, {
            id_unidade, id_local, id_perfil, id_sala
        });

        // Retorna contexto atualizado
        const [sessaoAtualizada] = await conn.query(
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

        res.json({
            sucesso: true,
            mensagem: "CONTEXTO_DEFINIDO",
            resultado: sessaoAtualizada[0] || {}
        });

    } catch (err) {
        console.error("Erro ao ativar contexto:", err);
        res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO", mensagem: err.message });
    } finally {
        if (conn) conn.release();
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