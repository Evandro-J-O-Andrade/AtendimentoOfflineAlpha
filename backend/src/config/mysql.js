// ========================================================
// MySQL Connection Pool
// ========================================================
import mysql from 'mysql2/promise';
import dotenv from 'dotenv';

dotenv.config();

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
  connectionLimit: parseInt(process.env.DB_CONNECTION_LIMIT) || 10,
  waitForConnections: process.env.DB_WAIT_FOR_CONNECTIONS !== 'false',
  queueLimit: parseInt(process.env.DB_QUEUE_LIMIT) || 0,
  enableKeepAlive: process.env.DB_ENABLE_KEEP_ALIVE !== 'false',
  keepAliveInitialDelayMs: parseInt(process.env.DB_KEEP_ALIVE_INITIAL_DELAY_MS) || 0,
  supportBigNumbers: true,
  bigNumberStrings: true,
  dateStrings: true,
});

// Teste conexão no startup
pool.getConnection()
  .then(conn => {
    console.log('✅ MySQL conectado com sucesso');
    conn.release();
  })
  .catch(err => {
    console.error('❌ Erro ao conectar MySQL:', err);
    process.exit(1);
  });

export default pool;

// ========================================================
// Função helper: Chamar procedure com async/await
// ========================================================
export async function callProcedure(procedureName, params = []) {
  const connection = await pool.getConnection();
  try {
    const placeholders = params.map(() => '?').join(',');
    const sql = `CALL ${procedureName}(${placeholders})`;
    
    const [results] = await connection.execute({
      sql,
      values: params,
      supportBigNumbers: true,
      bigNumberStrings: true
    });
    
    return results[0] || results; // Procedures retornam array
  } catch (error) {
    console.error(`Erro ao chamar ${procedureName}:`, error);
    throw error;
  } finally {
    await connection.end();
  }
}

// ========================================================
// Função helper: Query simples (SELECT/INSERT/UPDATE/DELETE)
// ========================================================
export async function executeQuery(sql, params = []) {
  const connection = await pool.getConnection();
  try {
    const [results] = await connection.execute(sql, params);
    return results;
  } catch (error) {
    console.error('Erro ao executar query:', error);
    throw error;
  } finally {
    await connection.end();
  }
}
