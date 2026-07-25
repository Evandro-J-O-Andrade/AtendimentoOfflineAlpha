import { getDatabasePool } from '@backend/database/mysql/connection'

export class ContextService {
  private connection = getDatabasePool()

  /**
   * Retorna unidades disponiveis para a sessao.
   * @param idSessao Identificador da sessao
   * @returns Objeto com sucesso, mensagem e resultado
   */
  async unidades(idSessao: number) {
    const conn = await this.connection
    await conn.query('CALL sp_contexto_unidades_get(?, @resultado, @sucesso, @mensagem)', [idSessao])
    const [outRows] = await conn.query('SELECT @resultado AS resultado, @sucesso AS sucesso, @mensagem AS mensagem')
    const out = (outRows as any[])[0]
    const sucesso = Boolean(out?.sucesso)
    if (!sucesso) {
      return { sucesso: false, mensagem: String(out?.mensagem ?? 'ERRO'), resultado: [] }
    }
    const raw = typeof out.resultado === 'string' ? JSON.parse(out.resultado) : out.resultado
    const unidades = (raw?.unidades ?? []).map((u: any) => ({
      id_unidade: Number(u.id_unidade),
      nome_unidade: String(u.nome_unidade)
    }))
    return { sucesso: true, mensagem: '', resultado: unidades }
  }

  /**
   * Retorna locais disponiveis para a sessao e unidade.
   * @param idSessao Identificador da sessao
   * @param idUnidade Identificador da unidade
   * @returns Objeto com sucesso, mensagem e resultado
   */
  async locais(idSessao: number, idUnidade: number) {
    const conn = await this.connection
    await conn.query('CALL sp_contexto_locais_get(?, ?, @resultado, @sucesso, @mensagem)', [idSessao, idUnidade])
    const [outRows] = await conn.query('SELECT @resultado AS resultado, @sucesso AS sucesso, @mensagem AS mensagem')
    const out = (outRows as any[])[0]
    const sucesso = Boolean(out?.sucesso)
    if (!sucesso) {
      return { sucesso: false, mensagem: String(out?.mensagem ?? 'ERRO'), resultado: [] }
    }
    const raw = typeof out.resultado === 'string' ? JSON.parse(out.resultado) : out.resultado
    const locais = (raw?.locais ?? []).map((l: any) => ({
      id_local: Number(l.id_local),
      nome_local: String(l.nome_local),
      id_unidade: Number(l.id_unidade)
    }))
    return { sucesso: true, mensagem: '', resultado: locais }
  }

  /**
   * Retorna perfis disponiveis para a sessao e unidade.
   * @param idSessao Identificador da sessao
   * @param idUnidade Identificador da unidade
   * @returns Objeto com sucesso, mensagem e resultado
   */
  async perfis(idSessao: number, idUnidade: number) {
    const conn = await this.connection
    await conn.query('CALL sp_contexto_perfis_get(?, ?, @resultado, @sucesso, @mensagem)', [idSessao, idUnidade])
    const [outRows] = await conn.query('SELECT @resultado AS resultado, @sucesso AS sucesso, @mensagem AS mensagem')
    const out = (outRows as any[])[0]
    const sucesso = Boolean(out?.sucesso)
    if (!sucesso) {
      return { sucesso: false, mensagem: String(out?.mensagem ?? 'ERRO'), resultado: [] }
    }
    const raw = typeof out.resultado === 'string' ? JSON.parse(out.resultado) : out.resultado
    const perfis = (raw?.perfis ?? []).map((p: any) => ({
      id_perfil: Number(p.id_perfil),
      nome_perfil: String(p.nome_perfil),
      id_unidade: Number(p.id_unidade)
    }))
    return { sucesso: true, mensagem: '', resultado: perfis }
  }

  /**
   * Retorna salas disponiveis para a sessao.
   * @param idSessao Identificador da sessao
   * @param idUnidade Identificador opcional da unidade
   * @returns Objeto com sucesso, mensagem e resultado
   */
  async salas(idSessao: number, idUnidade?: number) {
    const conn = await this.connection
    await conn.query('CALL sp_contexto_salas_get(?, ?, @resultado, @sucesso, @mensagem)', [idSessao, idUnidade ?? null])
    const [outRows] = await conn.query('SELECT @resultado AS resultado, @sucesso AS sucesso, @mensagem AS mensagem')
    const out = (outRows as any[])[0]
    const sucesso = Boolean(out?.sucesso)
    if (!sucesso) {
      return { sucesso: false, mensagem: String(out?.mensagem ?? 'ERRO'), resultado: [] }
    }
    const raw = typeof out.resultado === 'string' ? JSON.parse(out.resultado) : out.resultado
    const salas = (raw?.salas ?? []).map((s: any) => ({
      id_sala: Number(s.id_sala),
      nome_sala: String(s.nome_sala),
      id_unidade: Number(s.id_unidade)
    }))
    return { sucesso: true, mensagem: '', resultado: salas }
  }
}

export const contextService = new ContextService()
