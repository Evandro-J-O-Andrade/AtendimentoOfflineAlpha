const express = require("express");
const router = express.Router();
const jwt = require("jsonwebtoken");
const db = require("../config/database");
const { SECRET } = require("../config/jwt");

const guardiaoRuntime = require("../runtime/runtimeGuard");

const ACTION_DEFS = [
    {
        modulo: "totem",
        codigo: "SENHA_EMITIR",
        titulo: "Emitir Senha",
        sp: "sp_senha_emitir",
        paramsObrigatorios: [],
        exemploPayload: { tipo_atendimento: "CLINICO", origem: "TOTEM" },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_senha_emitir(?, ?, ?)", [
                decoded.id_sessao_usuario,
                payload.tipo_atendimento || "CLINICO",
                payload.origem || "TOTEM"
            ]);
            return { mensagem: "SP executada com sucesso." };
        }
    },
    {
        modulo: "totem",
        codigo: "SENHA_CHAMAR",
        titulo: "Chamar Senha",
        sp: "sp_senha_chamar",
        paramsObrigatorios: [],
        exemploPayload: { id_unidade: 1, id_local: 1, id_saas_entidade: 1 },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_senha_chamar(?, ?, ?, ?)", [
                decoded.id_sessao_usuario,
                payload.id_unidade || decoded.id_unidade || 1,
                payload.id_local ?? decoded.id_local_operacional ?? null,
                payload.id_saas_entidade || 1
            ]);
            return { mensagem: "SP executada com sucesso." };
        }
    },
    {
        modulo: "totem",
        codigo: "SENHA_FINALIZAR",
        titulo: "Finalizar Senha",
        sp: "sp_senha_finalizar",
        paramsObrigatorios: ["id_senha"],
        exemploPayload: { id_senha: 1 },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_senha_finalizar(?, ?)", [
                decoded.id_sessao_usuario,
                payload.id_senha
            ]);
            return { mensagem: "SP executada com sucesso." };
        }
    },
    {
        modulo: "recepcao",
        codigo: "RECEPCAO_INICIAR_COMPLEMENTACAO",
        titulo: "Iniciar Complementacao",
        sp: "sp_recepcao_iniciar_complementacao",
        paramsObrigatorios: ["id_senha"],
        exemploPayload: { id_senha: 1 },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_recepcao_iniciar_complementacao(?, ?)", [
                decoded.id_sessao_usuario,
                payload.id_senha
            ]);
            return { mensagem: "SP executada com sucesso." };
        }
    },
    {
        modulo: "recepcao",
        codigo: "RECEPCAO_REGISTRAR_ATENDIMENTO",
        titulo: "Registrar Atendimento (FFA)",
        sp: "sp_recepcao_complementar_e_abrir_ffa",
        paramsObrigatorios: ["id_senha", "id_paciente"],
        exemploPayload: { id_senha: 1, id_paciente: 1 },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_recepcao_complementar_e_abrir_ffa(?, ?, ?)", [
                decoded.id_sessao_usuario,
                payload.id_senha,
                payload.id_paciente
            ]);
            return { mensagem: "SP executada com sucesso." };
        }
    },
    {
        modulo: "recepcao",
        codigo: "RECEPCAO_ENCAMINHAR_FFA",
        titulo: "Encaminhar FFA",
        sp: "sp_recepcao_encaminhar_ffa",
        paramsObrigatorios: ["id_ffa"],
        exemploPayload: { id_ffa: 1, tipo_destino: "TRIAGEM" },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_recepcao_encaminhar_ffa(?, ?, ?)", [
                decoded.id_sessao_usuario,
                payload.id_ffa,
                payload.tipo_destino || null
            ]);
            return { mensagem: "SP executada com sucesso." };
        }
    },
    {
        modulo: "triagem",
        codigo: "TRIAGEM_FINALIZAR",
        titulo: "Finalizar Triagem",
        sp: "sp_triagem_finalizar",
        paramsObrigatorios: ["id_fila"],
        exemploPayload: { id_fila: 1 },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_triagem_finalizar(?, ?)", [
                decoded.id_sessao_usuario,
                payload.id_fila
            ]);
            return { mensagem: "SP executada com sucesso." };
        }
    },
    {
        modulo: "medico",
        codigo: "MEDICO_ENCAMINHAR",
        titulo: "Medico Encaminhar",
        sp: "sp_medico_encaminhar",
        paramsObrigatorios: ["id_ffa", "id_local_operacional_destino"],
        exemploPayload: { id_ffa: 1, id_local_operacional_destino: 1 },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_medico_encaminhar(?, ?, ?)", [
                decoded.id_sessao_usuario,
                payload.id_ffa,
                payload.id_local_operacional_destino
            ]);
            return { mensagem: "SP executada com sucesso." };
        }
    },
    {
        modulo: "medico",
        codigo: "MEDICO_FINALIZAR",
        titulo: "Medico Finalizar",
        sp: "sp_medico_finalizar",
        paramsObrigatorios: ["id_fila"],
        exemploPayload: { id_fila: 1 },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_medico_finalizar(?, ?)", [
                decoded.id_sessao_usuario,
                payload.id_fila
            ]);
            return { mensagem: "SP executada com sucesso." };
        }
    },
    {
        modulo: "medico",
        codigo: "MEDICO_MARCAR_RETORNO",
        titulo: "Medico Marcar Retorno",
        sp: "sp_medico_marcar_retorno",
        paramsObrigatorios: ["id_senha", "data_limite"],
        exemploPayload: { id_senha: 1, data_limite: "2026-03-10 12:00:00" },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_medico_marcar_retorno(?, ?, ?)", [
                decoded.id_sessao_usuario,
                payload.id_senha,
                payload.data_limite
            ]);
            return { mensagem: "SP executada com sucesso." };
        }
    },
    {
        modulo: "fila",
        codigo: "FILA_CHAMAR_PROXIMA",
        titulo: "Fila Chamar Proxima",
        sp: "sp_fila_chamar_proxima",
        paramsObrigatorios: ["setor"],
        exemploPayload: { setor: "TRIAGEM", id_local_operacional: 1 },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_fila_chamar_proxima(?, ?, ?, @p_id_fila)", [
                decoded.id_sessao_usuario,
                payload.setor,
                payload.id_local_operacional ?? decoded.id_local_operacional ?? null
            ]);
            const [[out]] = await conn.query("SELECT @p_id_fila AS id_fila");
            return { mensagem: "SP executada com sucesso.", dados: out };
        }
    },
    {
        modulo: "fila",
        codigo: "FILA_FINALIZAR",
        titulo: "Fila Finalizar",
        sp: "sp_fila_finalizar",
        paramsObrigatorios: ["id_fila"],
        exemploPayload: { id_fila: 1, detalhe: "setor=TRIAGEM" },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_fila_finalizar(?, ?, ?)", [
                decoded.id_sessao_usuario,
                payload.id_fila,
                payload.detalhe || "manual=1"
            ]);
            return { mensagem: "SP executada com sucesso." };
        }
    },
    {
        modulo: "atendimento",
        codigo: "ATENDIMENTO_TRANSICIONAR",
        titulo: "Transicionar Atendimento",
        sp: "sp_atendimento_transicionar",
        paramsObrigatorios: ["estado_destino", "uuid_transacao"],
        exemploPayload: { estado_destino: "AGUARDANDO_MEDICO", uuid_transacao: "abc123" },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_atendimento_transicionar(?, ?, ?)", [
                decoded.id_sessao_usuario,
                payload.estado_destino,
                payload.uuid_transacao
            ]);
            return { mensagem: "SP executada com sucesso." };
        }
    },
    {
        modulo: "atendimento",
        codigo: "ATENDIMENTO_FINALIZAR_EVASAO",
        titulo: "Finalizar Evasao",
        sp: "sp_atendimento_finalizar_evasao",
        paramsObrigatorios: ["id_ffa"],
        exemploPayload: { id_ffa: 1, observacao: "evasao recepcao" },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_atendimento_finalizar_evasao(?, ?, ?)", [
                decoded.id_sessao_usuario,
                payload.id_ffa,
                payload.observacao || null
            ]);
            return { mensagem: "SP executada com sucesso." };
        }
    },
    {
        modulo: "farmacia",
        codigo: "FARMACIA_DISPENSAR",
        titulo: "Dispensar Medicacao",
        sp: "sp_farmacia_dispensar_registrar",
        paramsObrigatorios: ["id_paciente", "id_produto", "id_lote", "quantidade"],
        exemploPayload: { id_unidade: 1, id_paciente: 1, id_produto: 1, id_lote: 1, quantidade: 1, observacao: "dispensacao" },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_farmacia_dispensar_registrar(?, ?, ?, ?, ?, ?, ?)", [
                decoded.id_sessao_usuario,
                payload.id_unidade || decoded.id_unidade || 1,
                payload.id_paciente,
                payload.id_produto,
                payload.id_lote,
                payload.quantidade,
                payload.observacao || null
            ]);
            return { mensagem: "SP executada com sucesso." };
        }
    },
    {
        modulo: "estoque",
        codigo: "ESTOQUE_CRIAR_MOVIMENTO",
        titulo: "Criar Movimento de Estoque",
        sp: "sp_estoque_movimento_criar",
        paramsObrigatorios: ["id_estoque_local", "tipo"],
        exemploPayload: { id_estoque_local: 1, tipo: "ENTRADA", origem: "ALMOX", destino: "FARM", observacao: "movimento inicial" },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_estoque_movimento_criar(?, ?, ?, ?, ?, ?, @p_id_movimento)", [
                decoded.id_sessao_usuario,
                payload.id_estoque_local,
                payload.tipo,
                payload.origem || null,
                payload.destino || null,
                payload.observacao || null
            ]);
            const [[out]] = await conn.query("SELECT @p_id_movimento AS id_movimento");
            return { mensagem: "SP executada com sucesso.", dados: out };
        }
    },
    {
        modulo: "estoque",
        codigo: "ESTOQUE_CADASTRAR_LOTE",
        titulo: "Cadastrar Lote no Movimento",
        sp: "sp_estoque_movimento_item_add",
        paramsObrigatorios: ["id_movimento", "id_produto", "id_lote", "quantidade"],
        exemploPayload: { id_movimento: 1, id_produto: 1, id_lote: 1, quantidade: 10, valor_unitario: 1.5 },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_estoque_movimento_item_add(?, ?, ?, ?, ?, ?)", [
                decoded.id_sessao_usuario,
                payload.id_movimento,
                payload.id_produto,
                payload.id_lote,
                payload.quantidade,
                payload.valor_unitario || 0
            ]);
            return { mensagem: "SP executada com sucesso." };
        }
    },
    {
        modulo: "estoque",
        codigo: "ESTOQUE_MOVIMENTAR",
        titulo: "Movimentar Estoque",
        sp: "sp_estoque_movimentar",
        paramsObrigatorios: ["id_unidade", "id_item", "id_lote", "quantidade", "tipo_movimento"],
        exemploPayload: { id_unidade: 1, id_item: 1, id_local_origem: 1, id_local_destino: 2, id_lote: 1, quantidade: 5, tipo_movimento: "TRANSFERENCIA" },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_estoque_movimentar(?, ?, ?, ?, ?, ?, ?, ?)", [
                payload.id_unidade,
                payload.id_item,
                payload.id_local_origem || null,
                payload.id_local_destino || null,
                payload.id_lote,
                payload.quantidade,
                payload.tipo_movimento,
                decoded.id_sessao_usuario
            ]);
            return { mensagem: "SP executada com sucesso." };
        }
    },
    {
        modulo: "estoque",
        codigo: "ESTOQUE_CADASTRAR_PRODUTO",
        titulo: "Cadastrar Produto",
        sp: "sp_estoque_produto_criar_com_codigo",
        paramsObrigatorios: ["nome"],
        exemploPayload: { nome: "DIPIRONA 500MG", categoria: "MEDICAMENTO", exige_receita: 0, controlado: 0 },
        executar: async (conn, decoded, payload) => {
            await conn.query("CALL sp_estoque_produto_criar_com_codigo(?, ?, ?, ?, ?, @p_id_produto, @p_sku, @p_barcode)", [
                decoded.id_sessao_usuario,
                payload.nome,
                payload.categoria || "MEDICAMENTO",
                payload.exige_receita || 0,
                payload.controlado || 0
            ]);
            const [[out]] = await conn.query(
                "SELECT @p_id_produto AS id_produto, @p_sku AS sku, @p_barcode AS barcode"
            );
            return { mensagem: "SP executada com sucesso.", dados: out };
        }
    }
];

const ACTION_MAP = new Map(ACTION_DEFS.map((a) => [a.codigo, a]));

async function executarViaMaster(conn, decoded, acao, payload) {
    const payloadJson = JSON.stringify(payload || {});
    await conn.query(
        `CALL sp_master_dispatcher_runtime(?, ?, ?, ?, ?, ?, @resultado, @sucesso, @mensagem)`,
        [
            decoded.id_sessao_usuario,
            decoded.id_usuario,
            decoded.id_perfil,
            acao.codigo,
            String(acao.modulo || "DEFAULT").toUpperCase(),
            payloadJson
        ]
    );

    const [[out]] = await conn.query(
        `SELECT @resultado AS resultado, @sucesso AS sucesso, @mensagem AS mensagem`
    );

    return {
        sucesso: out?.sucesso === 1 || out?.sucesso === true,
        mensagem: out?.mensagem || "Dispatcher executado.",
        dados: out?.resultado ? JSON.parse(out.resultado) : null
    };
}

function validarToken(req, res) {
    const authHeader = req.headers.authorization;
    if (!authHeader) {
        res.status(401).json({ erro: "Token não fornecido" });
        return null;
    }

    const token = authHeader.split(" ")[1];
    try {
        return jwt.verify(token, SECRET);
    } catch (err) {
        res.status(401).json({ erro: "Token inválido ou expirado" });
        return null;
    }
}

/*
=====================================
Painel Assistencial Runtime
=====================================
*/

router.get("/painel", guardiaoRuntime, (req, res) => {

    res.json({
        status: "ok",
        runtime: req.runtime
    });

});

/*
=====================================
Rota Admin - Sem validação de contexto operacional
=====================================
Usada para o dashboard do administrador do sistema
que precisa acessar todas as funcionalidades
*/

router.get("/admin", async (req, res) => {
    const decoded = validarToken(req, res);
    if (!decoded) return;

    let conn;
    try {
        conn = await db.getConnection();

        const [[usuarios]] = await conn.query("SELECT COUNT(*) AS total FROM usuario WHERE ativo = 1");
        const [[unidades]] = await conn.query("SELECT COUNT(*) AS total FROM unidade");
        const [[locais]]   = await conn.query("SELECT COUNT(*) AS total FROM local_operacional");
        const [[senhasDia]] = await conn.query("SELECT COUNT(*) AS total FROM senha WHERE DATE(criado_em) = CURDATE()");

        res.json({
            status: "ok",
            admin: true,
            usuario: {
                id_usuario: decoded.id_usuario,
                perfil: decoded.perfil,
                id_perfil: decoded.id_perfil
            },
            indicadores: {
                usuarios_ativos: usuarios?.total || 0,
                unidades: unidades?.total || 0,
                locais_operacionais: locais?.total || 0,
                senhas_hoje: senhasDia?.total || 0
            },
            mensagem: "Dashboard Administrador"
        });
    } catch (err) {
        console.error("Erro /painel/admin:", err.message);
        res.status(500).json({ erro: "ERRO_DE_CONEXAO" });
    } finally {
        if (conn) conn.release();
    }
});

router.get("/admin/catalogo-acoes", async (req, res) => {
    const decoded = validarToken(req, res);
    if (!decoded) return;

    let conn;
    try {
        conn = await db.getConnection();

        const procedures = [...new Set(ACTION_DEFS.map((item) => item.sp))];

        const placeholders = procedures.map(() => "?").join(", ");
        const [rows] = await conn.query(
            `SELECT ROUTINE_NAME AS nome
             FROM information_schema.ROUTINES
             WHERE ROUTINE_SCHEMA = DATABASE()
               AND ROUTINE_TYPE = 'PROCEDURE'
               AND ROUTINE_NAME IN (${placeholders})`,
            procedures
        );

        const existentes = new Set(rows.map((row) => row.nome));
        const catalogo = ACTION_DEFS.reduce((acc, acao) => {
            if (!acc[acao.modulo]) acc[acao.modulo] = [];
            acc[acao.modulo].push({
                codigo: acao.codigo,
                titulo: acao.titulo,
                sp: acao.sp,
                estrategia_execucao: "MASTER_COM_FALLBACK_DIRETO",
                params_obrigatorios: acao.paramsObrigatorios,
                exemplo_payload: acao.exemploPayload,
                sp_disponivel: existentes.has(acao.sp)
            });
            return acc;
        }, {});

        res.json({
            sucesso: true,
            catalogo,
            usuario: {
                id_usuario: decoded.id_usuario,
                id_perfil: decoded.id_perfil,
                perfil: decoded.perfil
            }
        });
    } catch (err) {
        console.error("Erro ao montar catálogo admin:", err);
        res.status(500).json({ sucesso: false, erro: "ERRO_CATALOGO_ACOES" });
    } finally {
        if (conn) conn.release();
    }
});

router.post("/admin/executar-acao", async (req, res) => {
    const decoded = validarToken(req, res);
    if (!decoded) return;

    const { codigo, payload } = req.body || {};
    if (!codigo) {
        return res.status(400).json({ sucesso: false, erro: "CODIGO_ACAO_OBRIGATORIO" });
    }

    const acao = ACTION_MAP.get(codigo);
    if (!acao) {
        return res.status(404).json({ sucesso: false, erro: "ACAO_NAO_ENCONTRADA" });
    }

    let conn;
    try {
        conn = await db.getConnection();
        const dadosPayload = payload || {};
        const faltantes = (acao.paramsObrigatorios || []).filter((p) => {
            const v = dadosPayload[p];
            return v === undefined || v === null || v === "";
        });
        if (faltantes.length > 0) {
            return res.status(400).json({
                sucesso: false,
                erro: "PARAMETROS_OBRIGATORIOS",
                faltantes
            });
        }

        let resultadoExecucao;
        let modoExecucao = "MASTER";
        try {
            resultadoExecucao = await executarViaMaster(conn, decoded, acao, dadosPayload);
            if (!resultadoExecucao.sucesso) {
                throw new Error(resultadoExecucao.mensagem || "Falha no dispatcher master.");
            }
        } catch (errMaster) {
            // Fallback para SP direta enquanto as master SPs são estabilizadas.
            resultadoExecucao = await acao.executar(conn, decoded, dadosPayload);
            modoExecucao = "DIRETO_FALLBACK";
        }

        res.json({
            sucesso: true,
            codigo,
            sp: acao.sp,
            modo_execucao: modoExecucao,
            mensagem: resultadoExecucao?.mensagem || "SP executada com sucesso.",
            dados: resultadoExecucao?.dados || null
        });
    } catch (err) {
        console.error("Erro ao executar ação admin:", err);
        res.status(500).json({
            sucesso: false,
            codigo,
            sp: acao.sp,
            erro: "ERRO_EXECUTAR_ACAO",
            detalhe: err.message
        });
    } finally {
        if (conn) conn.release();
    }
});

module.exports = router;

