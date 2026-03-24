const express = require("express");
const router = express.Router();
const authMiddleware = require("../auth/authMiddleware");

/**
 * ======================================
 * ROTAS DE CONTEXTO - STAGE COMPLETO
 * Sistema de seleção e ativação de contexto operacional
 * Integração com tabelas: local, sala, usuario_sala
 * ======================================
 */

/**
 * GET /api/contexto
 * Busca contextos disponíveis para o usuário (unidades, locais, perfis, salas)
 */
router.get("/", authMiddleware, async (req, res) => {
    let conn;
    try {
        // Verificar se o usuário está presente e tem os dados necessários
        if (!req.user) {
            return res.status(401).json({ sucesso: false, erro: "SEM_AUTENTICACAO", mensagem: "Usuário não autenticado" });
        }
        
        if (!req.user.id_sessao_usuario) {
            return res.status(401).json({ sucesso: false, erro: "SEM_SESSAO", mensagem: "Sessão inválida - sem ID de sessão" });
        }
        
        conn = await require("../config/database").getConnection();
        
        const id_sessao = req.user.id_sessao_usuario;
        
        // Buscar ID do usuário pela sessão - com fallback
        let id_usuario;
        try {
            const [sessoes] = await conn.query(
                "SELECT id_usuario FROM sessao_usuario WHERE id_sessao_usuario = ? AND ativo = 1 AND expira_em > NOW()",
                [id_sessao]
            );
            
            if (!sessoes.length) {
                // Fallback: usar o ID do usuário diretamente do token
                id_usuario = req.user.id_usuario;
                if (!id_usuario) {
                    return res.json({ sucesso: false, mensagem: "Sessão inválida e sem ID de usuário no token" });
                }
            } else {
                id_usuario = sessoes[0].id_usuario;
            }
        } catch (err) {
            console.warn("Erro ao buscar sessão:", err.message);
            // Fallback: usar ID do usuário do token
            id_usuario = req.user.id_usuario;
            if (!id_usuario) {
                return res.status(500).json({ sucesso: false, erro: "ERRO_SESSAO", mensagem: "Não foi possível validar a sessão" });
            }
        }
        
        // Buscar se é admin - com erro tolerante
        let isAdmin = false;
        try {
            const [isAdminResult] = await conn.query(
                "SELECT COUNT(*) as isAdmin FROM usuario_perfil WHERE id_usuario = ? AND id_perfil = 42",
                [id_usuario]
            );
            isAdmin = isAdminResult[0]?.isAdmin > 0;
        } catch (err) {
            console.warn("Erro ao verificar admin:", err.message);
        }
        
        // Buscar unidades (todas se admin, ou vinculadas)
        let unidades = [];
        try {
            if (isAdmin) {
                const [rows] = await conn.query("SELECT id_unidade, nome FROM unidade WHERE ativo = 1 ORDER BY nome");
                unidades = rows;
            } else {
                const [rows] = await conn.query(
                    `SELECT u.id_unidade, u.nome 
                     FROM usuario_unidade uu 
                     JOIN unidade u ON u.id_unidade = uu.id_unidade 
                     WHERE uu.id_usuario = ? AND uu.ativo = 1 AND u.ativo = 1`,
                    [id_usuario]
                );
                // Fallback: se não tem unidades mapeadas, retorna a primeira unidade do banco
                if (rows.length === 0) {
                    const [unidadePadrao] = await conn.query(
                        "SELECT id_unidade, nome FROM unidade WHERE ativo = 1 ORDER BY nome LIMIT 1"
                    );
                    unidades = unidadePadrao;
                } else {
                    unidades = rows;
                }
            }
        } catch (err) {
            console.warn("Erro ao buscar unidades:", err.message);
            // Fallback em caso de erro
            try {
                const [unidadePadrao] = await conn.query(
                    "SELECT id_unidade, nome FROM unidade WHERE ativo = 1 ORDER BY nome LIMIT 1"
                );
                unidades = unidadePadrao;
            } catch (e2) {
                unidades = [{ id_unidade: 1, nome: "PRONTO ATENDIMENTO" }];
            }
        }
        
        // Se ainda não tem unidades (banco vazio), retorna fallback
        if (!unidades || unidades.length === 0) {
            unidades = [{ id_unidade: 1, nome: "PRONTO ATENDIMENTO" }];
        }
        
        // Buscar locais (setores) com tipo - falha silenciosa se tabela não existir
        let locaisComOpcao = [{ id_local: 0, nome: "NÃO DEFINIDA", tipo_nome: "GERAL" }];
        try {
            const [locais] = await conn.query(
                `SELECT l.id_local, l.nome, l.codigo, tl.nome as tipo_nome, tl.categoria 
                 FROM usuario_local ulo 
                 JOIN local l ON l.id_local = ulo.id_local 
                 LEFT JOIN tipo_local tl ON tl.id_tipo_local = l.id_tipo_local
                 WHERE ulo.id_usuario = ? AND ulo.ativo = 1`,
                [id_usuario]
            );
            if (locais && locais.length > 0) {
                locaisComOpcao = [{ id_local: 0, nome: "NÃO DEFINIDA", tipo_nome: "GERAL" }, ...locais];
            }
        } catch (err) {
            console.warn("Erro ao buscar locais:", err.message);
        }
        
        // Buscar perfis - com erro tolerante
        let perfisData = [];
        try {
            const [perfis] = await conn.query(
                `SELECT p.id_perfil, p.nome 
                 FROM usuario_perfil up 
                 JOIN perfil p ON p.id_perfil = up.id_perfil 
                 WHERE up.id_usuario = ?`,
                [id_usuario]
            );
            
            // Fallback: se não tem perfis mapeados, retorna perfis padrões
            if (!perfis || perfis.length === 0) {
                try {
                    const [perfisPadrao] = await conn.query(
                        "SELECT id_perfil, nome FROM perfil WHERE ativo = 1 ORDER BY nome LIMIT 5"
                    );
                    perfisData = perfisPadrao.length > 0 ? perfisPadrao : [
                        { id_perfil: 1, nome: "RECEPÇÃO" },
                        { id_perfil: 2, nome: "TRIAGEM" },
                        { id_perfil: 3, nome: "MÉDICO" },
                        { id_perfil: 4, nome: "ENFERMEIRO" },
                        { id_perfil: 5, nome: "ADMINISTRATIVO" }
                    ];
                } catch (e2) {
                    perfisData = [
                        { id_perfil: 1, nome: "RECEPÇÃO" },
                        { id_perfil: 2, nome: "TRIAGEM" },
                        { id_perfil: 3, nome: "MÉDICO" },
                        { id_perfil: 4, nome: "ENFERMEIRO" },
                        { id_perfil: 5, nome: "ADMINISTRATIVO" }
                    ];
                }
            } else {
                perfisData = perfis;
            }
        } catch (err) {
            console.warn("Erro ao buscar perfis:", err.message);
            perfisData = [
                { id_perfil: 1, nome: "RECEPÇÃO" },
                { id_perfil: 2, nome: "TRIAGEM" },
                { id_perfil: 3, nome: "MÉDICO" },
                { id_perfil: 4, nome: "ENFERMEIRO" },
                { id_perfil: 5, nome: "ADMINISTRATIVO" }
            ];
        }
        
        // Buscar salas com tipo_sala para agrupamento - com erro tolerante
        let salas = [];
        try {
            if (isAdmin) {
                const [rows] = await conn.query(
                    `SELECT s.id_sala, s.nome_exibicao as nome, s.codigo, ts.nome as tipo_nome, ts.codigo as tipo_codigo,
                            s.permite_multiplas_especialidades, s.exibir_painel, s.gerar_tts, s.ativa
                     FROM sala s
                     LEFT JOIN tipo_sala ts ON ts.id_tipo_sala = s.id_tipo_sala
                     WHERE s.ativa = 1
                     ORDER BY ts.nome, s.nome_exibicao`
                );
                salas = rows;
            } else {
                // Salas do usuário via usuario_sala
                const [rows] = await conn.query(
                    `SELECT s.id_sala, s.nome_exibicao as nome, s.codigo, ts.nome as tipo_nome, ts.codigo as tipo_codigo,
                            s.permite_multiplas_especialidades, s.exibir_painel, s.gerar_tts, s.ativa
                     FROM usuario_sala us
                     JOIN sala s ON s.id_sala = us.id_sala
                     LEFT JOIN tipo_sala ts ON ts.id_tipo_sala = s.id_tipo_sala
                     WHERE us.id_usuario = ? AND us.ativo = 1 AND s.ativa = 1
                     ORDER BY ts.nome, s.nome_exibicao`,
                    [id_usuario]
                );
                salas = rows;
            }
        } catch (err) {
            console.warn("Erro ao buscar salas:", err.message);
            // Se tabela não existe, retorna array vazio
            salas = [];
        }
        
        // Buscar especialidades do usuário - com erro tolerante
        let especialidades = [];
        try {
            if (isAdmin) {
                const [rows] = await conn.query("SELECT id_especialidade as id, nome FROM especialidade ORDER BY nome");
                especialidades = rows;
            } else {
                const [rows] = await conn.query(
                    `SELECT e.id_especialidade as id, e.nome 
                     FROM medico_especialidade me 
                     JOIN especialidade e ON e.id_especialidade = me.id_especialidade 
                     WHERE me.id_usuario = ?
                     ORDER BY e.nome`,
                    [id_usuario]
                );
                especialidades = rows.length > 0 ? rows : [
                    { id: 1, nome: "CLINICA GERAL" },
                    { id: 2, nome: "PEDIATRIA" },
                    { id: 3, nome: "EMERGENCIA" }
                ];
            }
        } catch (err) {
            console.warn("Erro ao buscar especialidades:", err.message);
            especialidades = [
                { id: 1, nome: "CLINICA GERAL" },
                { id: 2, nome: "PEDIATRIA" },
                { id: 3, nome: "EMERGENCIA" }
            ];
        }
        
        res.json({
            sucesso: true,
            resultado: {
                unidades: unidades || [],
                locais: locaisComOpcao || [],
                perfis: perfisData || [],
                salas: salas || [],
                especialidades: especialidades || []
            }
        });

    } catch (err) {
        console.error("Erro ao buscar contextos:", err.message);
        res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO", mensagem: err.message });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/contexto
 * Ativa um contexto específico para a sessão
 */
router.post("/", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const { id_unidade, id_local, id_perfil, id_sala } = req.body;
        
        const id_sessao = req.user.id_sessao_usuario;
        const id_usuario = req.user.id_usuario;
        
        if (!id_unidade || !id_perfil) {
            return res.status(400).json({ 
                sucesso: false, 
                erro: "CAMPOS_OBRIGATORIOS",
                mensagem: "id_unidade e id_perfil são obrigatórios"
            });
        }
        
        // Valida se unidade pertence ao usuário (ou se usuário não tem mapeamento)
        const [unidadeValida] = await conn.query(`
            SELECT 1 FROM usuario_unidade 
            WHERE id_usuario = ? AND id_unidade = ? AND ativo = 1
            LIMIT 1
        `, [id_usuario, id_unidade]);
        
        // Se não tem mapeamento, permite (aceita como fallback)
        if (unidadeValida.length === 0) {
            // Verifica se o usuário tem algum mapeamento de unidade
            const [temQualquerUnidade] = await conn.query(
                "SELECT 1 FROM usuario_unidade WHERE id_usuario = ? AND ativo = 1 LIMIT 1",
                [id_usuario]
            );
            
            // Se tem映射 mas nenhuma unidade selecionada é válida, retorna erro
            if (temQualquerUnidade.length > 0) {
                return res.status(400).json({ 
                    sucesso: false, 
                    erro: "UNIDADE_INVALIDA",
                    mensagem: "Unidade não autorizada para este usuário"
                });
            }
            // Se não tem nenhum mapeamento, permite o acesso (fallback)
        }
        
        // Atualiza a sessão com o contexto
        await conn.query(`
            UPDATE sessao_usuario
            SET id_unidade = ?,
                id_local = ?,
                id_perfil = ?
            WHERE id_sessao_usuario = ?
        `, [
            id_unidade, 
            id_local === 0 || id_local === null ? null : id_local, 
            id_perfil,
            id_sessao
        ]);
        
        // Busca os dados do contexto atualizado
        const [sessaoAtualizada] = await conn.query(`
            SELECT 
                su.id_unidade,
                su.id_local,
                su.id_perfil,
                u.nome as unidade_nome,
                l.nome as local_nome,
                p.nome as perfil_nome
            FROM sessao_usuario su
            LEFT JOIN unidade u ON u.id_unidade = su.id_unidade
            LEFT JOIN local l ON l.id_local = su.id_local
            LEFT JOIN perfil p ON p.id_perfil = su.id_perfil
            WHERE su.id_sessao_usuario = ?
        `, [id_sessao]);
        
        res.json({
            sucesso: true,
            mensagem: "CONTEXTO_DEFINIDO",
            resultado: sessaoAtualizada[0] || {}
        });

    } catch (err) {
        console.error("Erro ao ativar contexto:", err.message);
        res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO", mensagem: err.message });
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
                su.id_unidade,
                su.id_local,
                su.id_perfil,
                u.nome as unidade_nome,
                l.nome as local_nome,
                p.nome as perfil_nome
            FROM sessao_usuario su
            LEFT JOIN unidade u ON u.id_unidade = su.id_unidade
            LEFT JOIN local l ON l.id_local = su.id_local
            LEFT JOIN perfil p ON p.id_perfil = su.id_perfil
            WHERE su.id_sessao_usuario = ?
        `, [id_sessao]);

        if (sessao.length === 0) {
            return res.json({ sucesso: false, erro: "SESSAO_NAO_ENCONTRADA" });
        }

        res.json({ 
            sucesso: true, 
            resultado: sessao[0] 
        });

    } catch (err) {
        console.error("Erro ao buscar contexto atual:", err.message);
        res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
    } finally {
        if (conn) conn.release();
    }
});

module.exports = router;
