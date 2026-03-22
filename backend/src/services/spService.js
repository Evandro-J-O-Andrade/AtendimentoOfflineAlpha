const pool = require('../config/database');

function parseJSONSafe(value) {
    if (value === null || value === undefined) return null;
    if (typeof value !== 'string') return value;

    try {
        return JSON.parse(value);
    } catch {
        return value;
    }
}

function normalizarResultadoProcedure(resultado) {
    return {
        ok: Boolean(resultado?.sucesso),
        data: parseJSONSafe(resultado?.resultado),
        erro: resultado?.sucesso ? null : (resultado?.mensagem || 'ERRO_DESCONHECIDO'),
        mensagem: resultado?.mensagem || null,
        sucesso: Boolean(resultado?.sucesso),
        resultado: parseJSONSafe(resultado?.resultado)
    };
}

async function lerOutParams() {
    const [vars] = await pool.execute(
        `SELECT @p_resultado AS resultado, @p_sucesso AS sucesso, @p_mensagem AS mensagem`
    );

    const resultado = vars?.[0] || {};
    return normalizarResultadoProcedure(resultado);
}

async function executeOrquestradora({
    p_id_sessao,
    p_modulo,
    p_acao,
    p_payload,
    p_id_unidade = null,
    p_id_setor = null,
    p_metadados = null
}) {
    const payloadFinal = {
        ...(p_payload || {}),
        p_id_unidade,
        p_id_setor,
        p_metadados
    };

    await pool.execute(
        `CALL sp_master_orquestradora(?, ?, ?, ?, @p_resultado, @p_sucesso, @p_mensagem)`,
        [
            p_id_sessao,
            p_modulo,
            p_acao,
            JSON.stringify(payloadFinal)
        ]
    );

    return lerOutParams();
}

async function executeQueryDispatcher({
    p_id_sessao,
    p_modulo,
    p_filtros,
    p_id_unidade = null,
    p_id_setor = null
}) {
    const filtrosFinais = {
        ...(p_filtros || {}),
        p_id_unidade,
        p_id_setor
    };

    await pool.execute(
        `CALL sp_master_query_dispatcher(?, ?, ?, @p_resultado, @p_sucesso, @p_mensagem)`,
        [
            p_id_sessao,
            p_modulo,
            JSON.stringify(filtrosFinais)
        ]
    );

    return lerOutParams();
}

async function executeLogin({ p_acao, p_payload }) {
    await pool.execute(
        `CALL sp_master_login(?, ?, @p_resultado, @p_sucesso, @p_mensagem)`,
        [p_acao, JSON.stringify(p_payload || {})]
    );

    return lerOutParams();
}

async function executarProcedureDireta(nomeProcedure, parametros = []) {
    const placeholders = parametros.map(() => '?').join(', ');
    const sql = `CALL ${nomeProcedure}(${placeholders})`;
    const [rows] = await pool.execute(sql, parametros);
    return rows;
}

module.exports = {
    executeOrquestradora,
    executeQueryDispatcher,
    executeLogin,
    executarProcedureDireta,
    executarOrquestradora: async (p_id_sessao, p_modulo, p_acao, p_payload) => {
        return executeOrquestradora({ p_id_sessao, p_modulo, p_acao, p_payload });
    },
    executarQueryDispatcher: async (p_id_sessao, p_modulo, p_filtro) => {
        return executeQueryDispatcher({ p_id_sessao, p_modulo, p_filtros: p_filtro });
    },
    executarLogin: async (p_acao, p_payload) => {
        return executeLogin({ p_acao, p_payload });
    }
};
