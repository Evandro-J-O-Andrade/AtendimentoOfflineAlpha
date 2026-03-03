const pool = require("../config/database");

class ContextService {
    static async validarContexto({ id_cidade, id_unidade, sistema }) {
        // simples validação de exemplo, adaptável ao esquema real
        if (!id_cidade || !id_unidade || !sistema) {
            return false;
        }

        const [rows] = await pool.execute(
            "SELECT 1 FROM unidade WHERE id_unidade = ? AND id_sistema = ? AND id_cidade = ?",
            [id_unidade, sistema, id_cidade]
        );

        return rows.length > 0;
    }
}

module.exports = ContextService;
