import { getDatabasePool } from '@backend/database/mysql/connection'

export class PermissionService {
  private connection = getDatabasePool()

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
