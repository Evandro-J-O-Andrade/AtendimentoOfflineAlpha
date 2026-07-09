import { createConnection } from '@backend/database/mysql/connection'

const config = {
  host: process.env.DB_HOST ?? 'localhost',
  port: Number(process.env.DB_PORT ?? 3306),
  user: process.env.DB_USER ?? 'root',
  password: process.env.DB_PASSWORD ?? '',
  database: process.env.DB_NAME ?? 'pronto_atendimento'
}

export class PermissionService {
  private connection = createConnection(config)

  async evaluate(idSessao: number): Promise<string[]> {
    const conn = await this.connection

    await conn.query('CALL sp_auth_permissions_evaluate(?, @permissions)', [idSessao])
    const [rows] = await conn.query('SELECT @permissions AS permissions')

    const raw = (rows as any[])[0]?.permissions
    if (!raw) {
      return []
    }

    const parsed = typeof raw === 'string' ? JSON.parse(raw) : raw
    if (!Array.isArray(parsed)) {
      return []
    }

    return parsed.filter((code): code is string => typeof code === 'string')
  }

  async assert(idSessao: number, permission: string): Promise<void> {
    const granted = await this.evaluate(idSessao)
    if (!granted.includes(permission)) {
      throw new Error(`PERMISSION_DENIED: ${permission}`)
    }
  }
}

export const permissionService = new PermissionService()
