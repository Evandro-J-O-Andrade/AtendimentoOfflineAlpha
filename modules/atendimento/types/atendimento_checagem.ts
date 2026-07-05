export interface AtendimentoChecagem {
  id: number;
  id_prescricao: number;
  horario_planejado: string;
  horario_executado: string;
  id_enfermeiro: number;
  status: string;
  motivo_recusa: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface AtendimentoChecagemCreate {
  horario_planejado?: string;
  horario_executado?: string;
  status?: string;
  motivo_recusa?: string;
}

export interface AtendimentoChecagemUpdate {
  horario_planejado?: string;
  horario_executado?: string;
  status?: string;
  motivo_recusa?: string;
}
