import type { TotemOpcao, TotemPlantaoItem } from '@atendimentooffline/contracts'

export interface TotemSenhaState {
  opcoes: TotemOpcao[]
  plantao: TotemPlantaoItem[]
  loading: boolean
  mensagem: string
  erro: string
}

export interface TotemSenhaGrupos {
  prioritario: TotemOpcao[]
  pediatria: TotemOpcao[]
  normalAdulto: TotemOpcao[]
}
