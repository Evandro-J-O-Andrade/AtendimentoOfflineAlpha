import { getDatabasePool } from '@backend/database/mysql/connection'

export class IntegrationService {
  private connection = getDatabasePool()

  async n8nWebhook(idSessao: number, webhookId: string, payload: any) {
    const conn = await this.connection
    const payloadStr = JSON.stringify(payload)

    await conn.query('CALL sp_integracao_n8n_disparar(?, ?, ?, @resultado, @sucesso, @mensagem)', [
      idSessao,
      webhookId,
      payloadStr
    ])
    const [outRows] = await conn.query(
      'SELECT @resultado AS resultado, @sucesso AS sucesso, @mensagem AS mensagem'
    )

    const out = (outRows as any[])[0]
    if (!out || !out.sucesso) {
      return { sucesso: false, mensagem: out?.mensagem ?? 'ERRO_DISPARO_N8N' }
    }

    const resultado = typeof out.resultado === 'string' ? JSON.parse(out.resultado) : out.resultado
    return { sucesso: true, resultado }
  }

  async webhookReceber(origem: string, payload: any) {
    const conn = await this.connection
    const payloadStr = JSON.stringify(payload)

    await conn.query('CALL sp_evento_registrar(?, ?, @sucesso, @mensagem)', [origem, payloadStr])
    const [outRows] = await conn.query('SELECT @sucesso AS sucesso, @mensagem AS mensagem')

    const out = (outRows as any[])[0]
    return {
      sucesso: Boolean(out?.sucesso),
      mensagem: out?.mensagem ?? 'EVENTO_REGISTRADO'
    }
  }

  async status(idSessao: number) {
    const conn = await this.connection

    await conn.query('CALL sp_integracao_status(?, @resultado, @sucesso, @mensagem)', [idSessao])
    const [outRows] = await conn.query(
      'SELECT @resultado AS resultado, @sucesso AS sucesso, @mensagem AS mensagem'
    )

    const out = (outRows as any[])[0]
    if (!out || !out.sucesso) {
      return []
    }

    const raw = typeof out.resultado === 'string' ? JSON.parse(out.resultado) : out.resultado
    return (raw ?? []) as any[]
  }
}

export const integrationService = new IntegrationService()
