/**
 * Script para executar scripts SQL no banco de dados
 * Uso: node run-seed.js
 */

const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

const config = {
    host: "localhost",
    user: "root",
    password: "root",
    database: "pronto_atendimento",
    multipleStatements: true
};

// Scripts que não usam DROP TABLE para evitar conflitos
const sqlFiles = [
    // Primeiro: criar tabelas que não existem (sem DROP)
    { file: 'kernel_orchestrator_init.sql', useDrop: false },
    { file: 'seed_autenticacao_completo.sql', useDrop: false }
];

async function executeSqlFile(filename, useDrop) {
    const filePath = path.join(__dirname, 'sql', filename);
    console.log(`\n📄 Executando: ${filename}`);
    
    let sql = fs.readFileSync(filePath, 'utf8');
    
    // Se não pode usar DROP, remover comandos DROP TABLE
    if (!useDrop) {
        sql = sql.replace(/DROP TABLE IF EXISTS `?\w+`?;/gi, '-- DROP TABLE removed');
    }
    
    let conn;
    try {
        conn = await mysql.createConnection(config);
        await conn.query(sql);
        console.log(`✅ ${filename} executado com sucesso!`);
    } catch (err) {
        console.error(`❌ Erro em ${filename}:`, err.message);
    } finally {
        if (conn) await conn.end();
    }
}

async function main() {
    console.log('🚀 Iniciando execução dos scripts SQL...');
    
    for (const {file, useDrop} of sqlFiles) {
        await executeSqlFile(file, useDrop);
    }
    
    console.log('\n✨ Concluído!');
}

main();
