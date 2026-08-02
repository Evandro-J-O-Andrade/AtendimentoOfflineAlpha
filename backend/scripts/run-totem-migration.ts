import { createPool } from 'mysql2/promise'
import { readFileSync } from 'fs'
import { join } from 'path'

const cfg = {
  host: process.env.DB_HOST ?? 'localhost',
  port: Number(process.env.DB_PORT ?? 3306),
  user: process.env.DB_USER ?? 'root',
  password: process.env.DB_PASSWORD ?? '',
  database: process.env.DB_NAME ?? 'pronto_atendimento'
}

const sqlPath = join(process.cwd(), '..', 'database', 'migrations', 'add_totem_executor_domain.sql')
const sql = readFileSync(sqlPath, 'utf-8')

const pool = createPool(cfg)

async function main() {
  const conn = await pool.getConnection()
  try {
    await conn.query(sql)
    console.log('migration_applied')
  } catch (e: any) {
    console.error('migration_failed', e?.message ?? e)
    process.exitCode = 1
  } finally {
    conn.release()
    await pool.end()
  }
}

main()
