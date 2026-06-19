const mysql = require("mysql2/promise");

async function checkTableStructure() {
    const pool = mysql.createPool({
        host: "localhost",
        user: "root",
        password: "root",
        database: "pronto_atendimento",
        waitForConnections: true,
        connectionLimit: 10
    });

    try {
        // Verificar estrutura da tabela perfil
        const [columns] = await pool.execute("DESCRIBE perfil");
        console.log("Estrutura da tabela perfil:");
        console.log(columns.map(c => `${c.Field} (${c.Type})`).join(", "));
        
    } catch (error) {
        console.error('❌ Erro:', error.message);
    } finally {
        await pool.end();
    }
}

checkTableStructure();
