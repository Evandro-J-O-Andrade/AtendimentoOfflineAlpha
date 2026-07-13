import { createPool as mysqlCreatePool, type Pool } from 'mysql2/promise'

export type DatabaseConfig = {
  host: string
  port: number
  user: string
  password: string
  database: string
}

export function getDatabaseConfig(): DatabaseConfig {
  return {
    host: process.env.DB_HOST ?? 'localhost',
    port: Number(process.env.DB_PORT ?? 3306),
    user: process.env.DB_USER ?? 'root',
    password: process.env.DB_PASSWORD ?? '',
    database: process.env.DB_NAME ?? 'pronto_atendimento'
  }
}

let pool: Pool | null = null

/**
 * Pool de conexões único e preguiçoso (lazy).
 * Não abre conexão no boot — a primeira query dispara a conexão com o banco.
 * Todos os Runtimes (Auth/Portal/Permission) compartilham este pool.
 */
export function getDatabasePool(): Pool {
  if (!pool) {
    const cfg = getDatabaseConfig()
    pool = mysqlCreatePool({
      host: cfg.host,
      port: cfg.port,
      user: cfg.user,
      password: cfg.password,
      database: cfg.database,
      connectionLimit: 10,
      waitForConnections: true,
      queueLimit: 0,
      enableKeepAlive: true
    })
  }
  return pool
}
