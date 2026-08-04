import { getDatabasePool } from '@backend/database/mysql/connection'

export interface RuntimeContext {
  id_sessao: number
  id_usuario: number
  id_entidade: number
  id_unidade: number
  id_perfil: number
  id_local: number
}

export interface DispatcherContext {
  id_sessao?: number
  id_usuario?: number
  id_entidade?: number
  id_unidade?: number
  id_perfil?: number
  id_local?: number
}

export interface DispatcherRequest {
  capability: string
  payload?: Record<string, unknown>
  context?: DispatcherContext
  uuid_transacao?: string
  idempotencia?: boolean
}

export interface DispatcherResponse {
  sucesso: boolean
  resultado?: unknown
  mensagem?: string
  uuid?: string
  executor?: string
}

export class DispatcherService {
  private connection = getDatabasePool()

  async dispatch(request: DispatcherRequest): Promise<DispatcherResponse> {
    const conn = await this.connection

    const capability = request.capability.toUpperCase()
    const uuid = request.uuid_transacao ?? crypto.randomUUID()
    const idSessao = request.context?.id_sessao ?? 0
    const payload = request.payload ?? {}
    const idReferencia = (payload?.id_referencia as number) ?? 0
    const payloadJson = JSON.stringify({ ...payload, id_referencia: idReferencia })

    const [dominio, acao] = capability.split('.')

    try {
      const [rows] = await conn.query(
        'CALL sp_master_dispatcher(?, ?, ?, ?, ?, ?)',
        [idSessao, uuid, dominio, acao, idReferencia, payloadJson]
      )

      const allRows = rows as any[]
      const out = allRows[allRows.length - 2]
      const result = out?.[0]?.result

      if (!result) {
        return {
          sucesso: false,
          mensagem: 'ERRO_DESCONHECIDO',
          uuid,
        }
      }

      const status = result?.status
      const sucesso = status === 'SUCCESS'

      if (!sucesso) {
        return {
          sucesso: false,
          mensagem: String(result?.mensagem ?? 'ERRO_DESCONHECIDO'),
          uuid,
          executor: result?.executor,
        }
      }

      return {
        sucesso: true,
        resultado: result,
        mensagem: 'OK',
        uuid,
        executor: result?.executor,
      }
    } catch (error: any) {
      const spMessage = error?.sqlMessage ?? 'ERRO_INTERNO'
      return {
        sucesso: false,
        mensagem: spMessage,
        uuid,
      }
    }
  }
}

export const dispatcherService = new DispatcherService()
