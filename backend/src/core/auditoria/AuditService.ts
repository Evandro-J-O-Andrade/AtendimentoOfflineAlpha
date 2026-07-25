import { getDatabasePool } from '@backend/database/mysql/connection'

export interface AuditRegistrarInput {
  acao: string
  entidade: string
  id_entidade: number
  dados_anterior?: any
  dados_novo?: any
}

export interface AuditFiltro {
  entidade?: string
  id_entidade?: number
  acao?: string
  data_inicio?: string
  data_fim?: string
}

export class AuditService {
  private connection = getDatabasePool()

  async registrar(idSessao: number, input: AuditRegistrarInput) {
    const conn = await this.connection

    await conn.query(
      'SET @p_resultado = NULL, @p_sucesso = NULL, @p_mensagem = NULL'
    )

    await conn.query('CALL sp_auditoria_registrar(?, ?, ?, ?, ?, ?, @p_resultado, @p_sucesso, @p_mensagem)', [
      idSessao,
      input.acao,
      input.entidade,
      input.id_entidade,
      JSON.stringify(input.dados_anterior ?? null),
      JSON.stringify(input.dados_novo ?? null)
    ])

    const [outRows] = await conn.query(
      'SELECT @p_resultado AS resultado, @p_sucesso AS sucesso, @p_mensagem AS mensagem'
    )
    const resultado = (outRows as any[])[0]
    const sucesso = Boolean(resultado?.sucesso)
    const mensagem = String(resultado?.mensagem ?? 'AUDITORIA_FALHA')

    const parsed = typeof resultado?.resultado === 'string'
      ? JSON.parse(resultado.resultado)
      : (resultado?.resultado ?? {})

    return {
      sucesso,
      mensagem,
      resultado: parsed
    }
  }

  async consultar(idSessao: number, filtros?: AuditFiltro) {
    const conn = await this.connection

    await conn.query(
      'SET @p_resultado = NULL, @p_sucesso = NULL, @p_mensagem = NULL'
    )

    await conn.query('CALL sp_auditoria_consultar(?, ?, ?, ?, ?, ?, @p_resultado, @p_sucesso, @p_mensagem)', [
      idSessao,
      filtros?.entidade ?? null,
      filtros?.id_entidade ?? null,
      filtros?.acao ?? null,
      filtros?.data_inicio ?? null,
      filtros?.data_fim ?? null
    ])

    const [outRows] = await conn.query(
      'SELECT @p_resultado AS resultado, @p_sucesso AS sucesso, @p_mensagem AS mensagem'
    )
    const resultado = (outRows as any[])[0]
    const sucesso = Boolean(resultado?.sucesso)

    if (!sucesso) {
      return {
        sucesso: false,
        mensagem: String(resultado?.mensagem ?? 'AUDITORIA_CONSULTA_VAZIA'),
        resultado: null
      }
    }

    const parsed = typeof resultado?.resultado === 'string'
      ? JSON.parse(resultado.resultado)
      : (resultado?.resultado ?? {})

    return {
      sucesso: true,
      mensagem: String(resultado?.mensagem ?? 'AUDITORIA_CONSULTA_OK'),
      resultado: Array.isArray(parsed) ? parsed : parsed?.registros ?? parsed
    }
  }

  async exportar(idSessao: number, formato: 'json' | 'csv', filtros?: AuditFiltro) {
    const conn = await this.connection

    await conn.query(
      'SET @p_resultado = NULL, @p_sucesso = NULL, @p_mensagem = NULL'
    )

    await conn.query('CALL sp_auditoria_exportar(?, ?, ?, ?, ?, ?, @p_resultado, @p_sucesso, @p_mensagem)', [
      idSessao,
      formato,
      filtros?.entidade ?? null,
      filtros?.id_entidade ?? null,
      filtros?.data_inicio ?? null,
      filtros?.data_fim ?? null
    ])

    const [outRows] = await conn.query(
      'SELECT @p_resultado AS resultado, @p_sucesso AS sucesso, @p_mensagem AS mensagem'
    )
    const resultado = (outRows as any[])[0]
    const sucesso = Boolean(resultado?.sucesso)
    const mensagem = String(resultado?.mensagem ?? 'AUDITORIA_EXPORTACAO_FALHA')

    const parsed = typeof resultado?.resultado === 'string'
      ? JSON.parse(resultado.resultado)
      : (resultado?.resultado ?? {})

    return {
      sucesso,
      mensagem,
      formato,
      conteudo: parsed
    }
  }
}

export const auditService = new AuditService()
