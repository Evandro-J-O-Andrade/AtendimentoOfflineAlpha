import { createConnection as mysqlCreateConnection } from 'mysql2/promise'

export type DatabaseConfig = {
  host: string
  port: number
  user: string
  password: string
  database: string
}

export function createConnection(config: DatabaseConfig) {
  return mysqlCreateConnection({
    host: config.host,
    port: config.port,
    user: config.user,
    password: config.password,
    database: config.database
  })
}
