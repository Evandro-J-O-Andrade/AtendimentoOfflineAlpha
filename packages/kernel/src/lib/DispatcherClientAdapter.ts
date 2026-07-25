/**
 * @fileoverview Adaptador do DispatcherClient para transporte via API HTTP.
 * @module lib/DispatcherClientAdapter
 * @description Implementacao canônica de {@link DispatcherClient} utilizando
 * {@link ApiClient} como transporte subjacente.
 */

import type { DispatcherRequest, DispatcherResponse, DispatcherClient } from './DispatcherContracts'
import { ApiClient } from '@atendimentooffline/api'

/**
 * Implementacao de {@link DispatcherClient} baseada em {@link ApiClient}.
 *
 * @remarks Requer configuracao de baseUrl valida para o Backend Enterprise.
 */
export class ApiDispatcherClientAdapter implements DispatcherClient {
  constructor(private readonly baseUrl: string) {}

  async send(request: DispatcherRequest): Promise<DispatcherResponse> {
    const client = new ApiClient({ baseUrl: this.baseUrl })

    const data = await client.post<DispatcherResponse>('/dispatcher', {
      modulo: request.modulo,
      acao: request.acao,
      payload: request.payload,
      id_sessao: request.idSessao
    })

    if (!data.sucesso) {
      throw new Error(data.mensagem ?? 'ERRO_DESCONHECIDO')
    }

    return data
  }
}
