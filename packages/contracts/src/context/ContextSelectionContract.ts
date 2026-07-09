import type { ContextContract } from './ContextContract'

export interface ContextSelectionContract {
  selectedContext: ContextContract | null
  availableContexts: ContextContract[]
  defaultContext: ContextContract | null
}
