import { createPool } from 'mysql2/promise'

const cfg = {
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: 'root',
  database: 'pronto_atendimento'
}

const pool = createPool(cfg)

async function run() {
  const conn = await pool.getConnection()
  try {
    const [rows] = await conn.query("SHOW CREATE TABLE auditoria_evento")
    console.log(rows[0]['Create Table'])
  } finally {
    conn.release()
    await pool.end()
  }
}

run().catch(err => {
  console.error(err)
  process.exit(1)
})
