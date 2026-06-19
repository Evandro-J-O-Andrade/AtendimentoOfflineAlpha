const mysql = require("mysql2/promise");

const pool = mysql.createPool({
    host: process.env.DB_HOST || "localhost",
    user: process.env.DB_USER || "evandro.andrade",
    password: process.env.DB_PASS || "@An29070818",
    database: process.env.DB_NAME || "pronto_atendimento",
    port: process.env.DB_PORT ? Number(process.env.DB_PORT) : 3306,
    waitForConnections: true,
    connectionLimit: 10,
    multipleStatements: true // Necessário para executar SPs com múltiplos statements
});

module.exports = pool;
