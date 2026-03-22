const mysql = require("mysql2/promise");

const pool = mysql.createPool({
    host: "localhost",
    user: "root",
    password: "root",
    database: "pronto_atendimento",
    waitForConnections: true,
    connectionLimit: 10,
    multipleStatements: true  // Necessário para executar SPs com múltiplos statements
});

module.exports = pool;