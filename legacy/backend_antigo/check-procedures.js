// Script para verificar e listar as procedures do banco
const mysql = require('mysql2/promise');

async function checkProcedures() {
    const pool = mysql.createPool({
        host: "localhost",
        user: "root",
        password: "root",
        database: "pronto_atendimento",
        waitForConnections: true,
        connectionLimit: 10
    });

    try {
        // Verificar se as procedures existem
        const [procs] = await pool.query(
            "SELECT routine_name FROM information_schema.routines WHERE routine_schema = 'pronto_atendimento' AND routine_name LIKE 'sp_%'"
        );
        
        console.log('Procedures encontradas:', procs.length);
        procs.forEach(p => console.log(' -', p.routine_name));

        // Testar a procedure sp_login_usuario
        console.log('\n--- Testando sp_login_usuario ---');
        try {
            const [results] = await pool.query('CALL sp_login_usuario(?)', ['evandro.andrade']);
            console.log('Resultados:', results);
        } catch (e) {
            console.log('Erro na sp_login_usuario:', e.message);
        }

    } catch (error) {
        console.error('Erro:', error.message);
    } finally {
        await pool.end();
    }
}

checkProcedures();
