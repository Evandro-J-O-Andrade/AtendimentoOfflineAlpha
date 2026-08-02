import { getDatabasePool } from '@backend/database/mysql/connection'

export class PermissionService {
  private connection = getDatabasePool()

  async evaluate(idSessao: number): Promise<string[]> {
    const conn = await this.connection

    const [sessaoRows] = await conn.query(
      'SELECT id_usuario, id_entidade, id_perfil, id_unidade, id_local FROM sessao_usuario WHERE id_sessao_usuario = ? AND id_entidade IS NOT NULL LIMIT 1',
      [idSessao]
    )
    const sessao = (sessaoRows as any[])[0]
    if (!sessao) {
      return []
    }

    const idPerfil = Number(sessao.id_perfil ?? 0)
    const idLocal = Number(sessao.id_local ?? 0)
    const idEntidade = Number(sessao.id_entidade ?? 0)

    if (!idPerfil || !idEntidade) {
      return []
    }

    const [permRows] = await conn.query(
      `SELECT DISTINCT p.codigo
       FROM permissao p
       JOIN perfil_permissao pp ON pp.id_permissao = p.id_permissao
       LEFT JOIN permissao_local pl ON pl.id_permissao = p.id_permissao
       WHERE pp.id_perfil = ?
         AND (pl.id_local IS NULL OR pl.id_local = ?)
         AND p.flag_ativo = 1
         AND (p.id_entidade = ? OR p.id_entidade IS NULL)`,
      [idPerfil, idLocal, idEntidade]
    )

    return (permRows as any[])
      .map((row: any) => row.codigo)
      .filter((code: any): code is string => typeof code === 'string')
  }

  async assert(idSessao: number, permission: string): Promise<void> {
    const granted = await this.evaluate(idSessao)
    if (!granted.includes(permission)) {
      throw new Error(`PERMISSION_DENIED: ${permission}`)
    }
  }
}

export const permissionService = new PermissionService()
