export interface DispatcherRequest {
  modulo: string
  acao: string
  payload: Record<string, unknown>
  idSessao: number
}

export interface DispatcherResponse {
  sucesso: boolean
  resultado?: unknown
  mensagem?: string
}
