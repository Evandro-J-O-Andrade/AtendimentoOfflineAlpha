export type UserKind = 'PESSOA' | 'TECNICO' | 'SERVICO' | 'API' | 'DISPLAY' | 'TERMINAL'

export interface UserContract {
  id: string
  personId: string
  kind: UserKind
  username?: string
  isActive: boolean
}
