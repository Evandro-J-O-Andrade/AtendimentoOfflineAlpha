const mysql = require("mysql2/promise");
const fs = require("fs");
const path = require("path");

async function applyProcedure() {
    const pool = mysql.createPool({
        host: "localhost",
        user: "root",
        password: "root",
        database: "pronto_atendimento",
        waitForConnections: true,
        connectionLimit: 2,
        multipleStatements: true
    });

    const spFile = path.join(__dirname, "sql", "sp_master_dispatcher_v2.sql");
    let spContent = fs.readFileSync(spFile, "utf8");

    // Ajustar o DELIMITER para o formato que o mysql2 aceita
    // Remover as instruções DELIMITER e usar apenas o corpo
    spContent = spContent.replace(/DELIMITER ;;;/g, "");
    spContent = spContent.replace(/DELIMITER ;/g, "");
    spContent = spContent.replace(/;;/g, ";");

    // Dividir em instruções individuais
    const statements = spContent.split(";").filter(s => s.trim().length > 0);

    let conn;
    try {
        conn = await pool.getConnection();
        
        for (const stmt of statements) {
            if (stmt.trim().length > 10) {
                console.log("Executando:", stmt.substring(0, 50) + "...");
                await conn.query(stmt);
            }
        }

        console.log("✅ Procedure sp_master_dispatcher aplicada com sucesso!");
    } catch (err) {
        console.error("❌ Erro ao aplicar procedure:", err.message);
    } finally {
        if (conn) conn.release();
        await pool.end();
    }
}

applyProcedure();
