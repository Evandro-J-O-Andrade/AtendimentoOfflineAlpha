import type { ApiClient } from '@atendimentooffline/api'
import type { AuthSessionContract } from './contracts/AuthSessionContract'

export async function resolveSession(api: ApiClient): Promise<AuthSessionContract> {
  return api.get<AuthSessionContract>('/auth/session')
}
