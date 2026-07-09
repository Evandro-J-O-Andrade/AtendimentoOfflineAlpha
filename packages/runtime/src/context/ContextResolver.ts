import type { AuthSessionContract, ContextContract } from '@atendimentooffline/contracts'
import type { ContextResolutionResult } from '../contracts/RuntimeContracts'

export function resolveContext(
  session: AuthSessionContract,
  available: ContextContract[],
  chosenContextId?: string
): ContextResolutionResult {
  if (!session.authenticated || !session.person) {
    return { status: 'CONTEXT_SELECTION_REQUIRED', available }
  }
  if (chosenContextId) {
    const found = available.find((c) => c.id === chosenContextId)
    if (found) return { status: 'ACTIVE', context: found, available }
  }
  if (available.length === 1) {
    return { status: 'ACTIVE', context: available[0], available }
  }
  return { status: 'CONTEXT_SELECTION_REQUIRED', available }
}
