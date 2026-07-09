export type ContextKind = 'UNIT' | 'HOSPITAL' | 'CLINIC' | 'COMPANY' | 'BRANCH'

export interface ContextContract {
  id: string
  tenantId: string
  name: string
  kind: ContextKind
  parentId?: string | null
}
