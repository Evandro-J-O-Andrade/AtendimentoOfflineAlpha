const express = require("express");
const router = express.Router();

/**
 * ======================================
 * ROTAS DE TOTEM
 * Sistema de autoatendimento para geração de senhas
 * ======================================
 */

/**
 * GET /api/totem/opcoes
 * Lista opções de atendimento disponíveis no totem
 */
router.get("/opcoes", async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const [opcoes] = await conn.query(`
            SELECT 
                id_opcao,
                codigo,
                label,
                lane,
                tipo_atendimento,
                prefixo,
                ordem,
                ativo
            FROM totem_senha_opcao
            WHERE ativo = 1
            ORDER BY ordem ASC
        `);

        const normalizadas = opcoes.map((item) => ({
            id_opcao: item.id_opcao,
            nome: item.label,
            codigo: item.codigo,
            lane: item.lane,
            tipo_atendimento: item.tipo_atendimento,
            prefixo: item.prefixo
        }));

        res.json({ opcoes: normalizadas });

    } catch (err) {
        console.error("Erro ao buscar opções:", err);
        res.json({
            opcoes: [
                { id_opcao: 1, nome: "Prioritário", codigo: "PRIORITARIO", tipo_atendimento: "PRIORITARIO", prefixo: "P" },
                { id_opcao: 2, nome: "Pediatria", codigo: "PEDIATRICO", tipo_atendimento: "PEDIATRICO", prefixo: "D" },
                { id_opcao: 3, nome: "Normal - Adulto", codigo: "CLINICO", tipo_atendimento: "CLINICO", prefixo: "A" }
            ]
        });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * GET /api/totem/plantao-medico
 * Lista escala/plantao medico para exibicao no topo do totem
 */
router.get("/plantao-medico", async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        const id_unidade = Number(req.query.id_unidade || 1);

        // 1) Fonte principal: plantao ativo no horario atual
        let [plantao] = await conn.query(
            `
            SELECT
                pl.tipo_plantao AS especialidade,
                pe.nome AS medico_nome,
                m.crm AS crm
            FROM plantao pl
            JOIN funcionario f ON f.id_funcionario = pl.id_funcionario
            JOIN pessoa pe ON pe.id_pessoa = f.id_pessoa
            LEFT JOIN usuario u ON u.id_pessoa = pe.id_pessoa
            LEFT JOIN medico m ON m.id_usuario = u.id_usuario
            WHERE pl.id_unidade = ?
              AND pl.ativo = 1
              AND NOW() BETWEEN pl.inicio_plantao AND pl.fim_plantao
            ORDER BY pl.tipo_plantao, pe.nome
            `,
            [id_unidade]
        );

        // 2) Fallback: escala_medica do dia
        if (!plantao.length) {
            [plantao] = await conn.query(
                `
                SELECT
                    'MEDICO CLINICO' AS especialidade,
                    pe.nome AS medico_nome,
                    m.crm AS crm
                FROM escala_medica em
                JOIN usuario u ON u.id_usuario = em.id_usuario_medico
                LEFT JOIN pessoa pe ON pe.id_pessoa = u.id_pessoa
                LEFT JOIN medico m ON m.id_usuario = u.id_usuario
                WHERE em.id_unidade = ?
                  AND em.data_plantao = CURDATE()
                  AND em.status_presenca IN ('PREVISTO','CONFIRMADO')
                ORDER BY pe.nome
                `,
                [id_unidade]
            );
        }

        res.json({
            plantao: plantao.map((item) => ({
                especialidade: item.especialidade || "MEDICO CLINICO",
                medico_nome: item.medico_nome || "MEDICO DE PLANTAO",
                crm: item.crm || "N/A"
            }))
        });
    } catch (err) {
        console.error("Erro ao buscar plantao medico:", err);
        res.status(500).json({ error: "ERRO_AO_BUSCAR_PLANTAO_MEDICO" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/totem/gerar-senha
 * Gera nova senha para atendimento
 */
router.post("/gerar-senha", async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        await conn.beginTransaction();
        
        const { 
            id_opcao, 
            id_unidade = 1,
            id_local_operacional = 1 
        } = req.body;

        const [opcaoRows] = await conn.query(
            `
            SELECT id_opcao, codigo, label, lane, tipo_atendimento, prefixo
            FROM totem_senha_opcao
            WHERE id_opcao = ? AND ativo = 1
            LIMIT 1
            `,
            [id_opcao]
        );

        const opcao = opcaoRows[0] || {
            codigo: "CLINICO",
            label: "Normal - Adulto",
            lane: "ADULTO",
            tipo_atendimento: "CLINICO",
            prefixo: "A"
        };

        const prefixo = (opcao.prefixo || opcao.codigo?.slice(0, 1) || "A").toUpperCase();

        await conn.query(
            `
            INSERT INTO senha_sequencia (id_sistema, id_unidade, data_ref, prefixo, ultimo_numero)
            VALUES (1, ?, CURDATE(), ?, 1)
            ON DUPLICATE KEY UPDATE ultimo_numero = ultimo_numero + 1
            `,
            [id_unidade, prefixo]
        );

        const [[seq]] = await conn.query(
            `
            SELECT ultimo_numero
            FROM senha_sequencia
            WHERE id_sistema = 1
              AND id_unidade = ?
              AND data_ref = CURDATE()
              AND prefixo = ?
            `,
            [id_unidade, prefixo]
        );

        const numeroSenha = Number(seq?.ultimo_numero || 1);
        const codigoVisual = `${prefixo}${String(numeroSenha).padStart(3, "0")}`;

        const [[unidade]] = await conn.query(
            `SELECT id_saas_entidade FROM unidade WHERE id_unidade = ? LIMIT 1`,
            [id_unidade]
        );

        const [[fluxoStatus]] = await conn.query(
            `SELECT id_fluxo_status FROM fluxo_status WHERE ativo = 1 ORDER BY id_fluxo_status ASC LIMIT 1`
        );

        const prioridade =
            String(opcao.codigo || "").toUpperCase().includes("PRIOR")
                ? 1
                : String(opcao.codigo || "").toUpperCase().includes("PEDI")
                    ? 2
                    : 5;

        const uuidSync = require("crypto").randomUUID();

        const [result] = await conn.query(
            `
            INSERT INTO senha (
                id_saas_entidade,
                id_unidade,
                id_local,
                codigo_visual,
                prioridade,
                id_fluxo_status,
                contexto_fluxo,
                origem,
                dispositivo,
                id_sessao_usuario,
                ordem_fila,
                chamada_sequencial,
                uuid_sync
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            `,
            [
                unidade?.id_saas_entidade || 1,
                id_unidade,
                id_local_operacional,
                codigoVisual,
                prioridade,
                fluxoStatus?.id_fluxo_status || 1,
                opcao.tipo_atendimento || "CLINICO",
                "PAINEL_TOTEM",
                req.ip || null,
                null,
                numeroSenha,
                0,
                uuidSync
            ]
        );

        const id_senha = result.insertId;

        await conn.query(
            `
            INSERT INTO totem_evento (id_totem, evento, ip_acesso)
            VALUES (1, 'SENHA_GERADA', ?)
            `,
            [req.ip || null]
        );

        await conn.commit();

        res.json({
            success: true,
            senha: {
                id: id_senha,
                numero: numeroSenha,
                prefixo,
                tipo: codigoVisual,
                prioridade
            },
            mensagem: "Senha gerada com sucesso"
        });
    } catch (err) {
        if (conn) await conn.rollback();
        console.error("Erro ao gerar senha:", err);
        res.status(500).json({ error: "ERRO_AO_GERAR_SENHA" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * GET /api/totem/senha/:id
 * Consulta status de uma senha
 */
router.get("/senha/:id", async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const { id } = req.params;

        const [senha] = await conn.query(`
            SELECT 
                s.id_senha,
                s.codigo_visual,
                s.contexto_fluxo,
                s.prioridade,
                s.criado_em,
                s.chamada_em
            FROM senha s
            WHERE s.id_senha = ?
        `, [id]);

        if (senha.length === 0) {
            return res.status(404).json({ error: "SENHA_NAO_ENCONTRADA" });
        }

        res.json({ senha: senha[0] });

    } catch (err) {
        console.error("Erro ao buscar senha:", err);
        res.status(500).json({ error: "ERRO_AO_BUSCAR_SENHA" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/totem/feedback
 * Registra feedback do paciente sobre o atendimento
 */
router.post("/feedback", async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const { id_senha, avaliacao, comentario } = req.body;

        await conn.query(`
            INSERT INTO totem_feedback (
                id_senha,
                avaliacao,
                comentario,
                ip_acesso,
                data_feedback
            ) VALUES (?, ?, ?, ?, NOW())
        `, [id_senha, avaliacao, comentario, req.ip]);

        res.json({ success: true, mensagem: "Feedback registrado" });

    } catch (err) {
        console.error("Erro ao registrar feedback:", err);
        res.status(500).json({ error: "ERRO_AO_REGISTRAR_FEEDBACK" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * GET /api/totem/fila-posicao
 * Consulta posição do paciente na fila
 */
router.get("/fila-posicao/:id_senha", async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const { id_senha } = req.params;

        // Busca posição na fila
        const [posicao] = await conn.query(`
            SELECT 
                COUNT(*) as posicao
            FROM fila_operacional fo
            INNER JOIN senha s ON s.id_senha = fo.id_senha
            WHERE fo.id_unidade = (SELECT id_unidade FROM senha WHERE id_senha = ?)
            AND fo.status = 'AGUARDANDO'
            AND fo.data_entrada < (SELECT data_entrada FROM senha WHERE id_senha = ?)
        `, [id_senha, id_senha]);

        const [senha] = await conn.query(`
            SELECT tipo, status FROM senha WHERE id_senha = ?
        `, [id_senha]);

        res.json({ 
            posicao: posicao[0].posicao + 1,
            senha: senha[0]
        });

    } catch (err) {
        console.error("Erro ao buscar posição:", err);
        res.status(500).json({ error: "ERRO_AO_BUSCAR_POSICAO" });
    } finally {
        if (conn) conn.release();
    }
});

module.exports = router;
