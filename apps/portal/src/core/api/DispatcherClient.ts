import type { DispatcherRequest, DispatcherResponse } from '../contracts/DispatcherSchemas'

export interface DispatcherClient {
  send(request: DispatcherRequest): Promise<DispatcherResponse>
}

export class ApiDispatcherClient implements DispatcherClient {
  constructor(private baseUrl: string) {}

  async send(request: DispatcherRequest): Promise<DispatcherResponse> {
    const response = await fetch(`${this.baseUrl}/dispatcher`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${request.idSessao}`
      },
      body: JSON.stringify({
        modulo: request.modulo,
        acao: request.acao,
        payload: request.payload,
        id_sessao: request.idSessao
      })
    })

    if (!response.ok) {
      throw new Error(`HTTP_${response.status}`)
    }

    const data = (await response.json()) as DispatcherResponse

    if (!data.sucesso) {
      throw new Error(data.mensagem ?? 'ERRO_DESCONHECIDO')
    }

    return data
  }
}
