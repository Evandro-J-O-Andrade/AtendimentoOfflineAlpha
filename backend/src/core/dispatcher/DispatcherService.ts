import { getDatabasePool } from '@backend/database/mysql/connection'

export interface DispatcherRequest {
  modulo: string
  acao: string
  payload: Record<string, unknown>
  id_sessao: number
  uuid_transacao?: string
}

export interface DispatcherResponse {
  sucesso: boolean
  resultado?: unknown
  mensagem?: string
}

export class DispatcherService {
  private connection = getDatabasePool()

  async dispatch(request: DispatcherRequest): Promise<DispatcherResponse> {
    const conn = await this.connection

    const dominio = request.modulo.toUpperCase()
    const acao = request.acao.toUpperCase()
    const uuid = request.uuid_transacao ?? crypto.randomUUID()
    const idReferencia = (request.payload?.id_referencia as number) ?? 0
    const payloadJson = JSON.stringify(request.payload)

    try {
      const [rows] = await conn.query(
        'CALL sp_master_dispatcher(?, ?, ?, ?, ?, ?)',
        [request.id_sessao, uuid, dominio, acao, idReferencia, payloadJson]
      )

      const allRows = rows as any[]
      const out = allRows[allRows.length - 2]
      const result = out?.[0]?.result

      if (!result) {
        return {
          sucesso: false,
          mensagem: 'ERRO_DESCONHECIDO'
        }
      }

      const status = result?.status
      const sucesso = status === 'SUCCESS'

      if (!sucesso) {
        return {
          sucesso: false,
          mensagem: String(result?.mensagem ?? 'ERRO_DESCONHECIDO')
        }
      }

      return {
        sucesso: true,
        resultado: result,
        mensagem: 'OK'
      }
    } catch (error: any) {
      const spMessage = error?.sqlMessage ?? 'ERRO_INTERNO'
      return {
        sucesso: false,
        mensagem: spMessage
      }
    }
  }
}

export const dispatcherService = new DispatcherService()
