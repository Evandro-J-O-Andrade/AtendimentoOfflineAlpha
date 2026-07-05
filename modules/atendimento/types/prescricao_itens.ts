export interface PrescricaoItens {
  id: number;
  id_atendimento: number;
  id_usuario_prescritor: number;
  tipo_item: string;
  descricao: string;
  posologia_detalhada: string;
  frequencia_horario: string;
  via_administracao: string;
  observacao_enfermagem: string;
  data_inicio: string;
  data_suspensao: string;
  status: string;
  id_entidade: number;
}

export interface PrescricaoItensCreate {
  tipo_item?: string;
  descricao?: string;
  posologia_detalhada?: string;
  frequencia_horario?: string;
  via_administracao?: string;
  observacao_enfermagem?: string;
  data_inicio?: string;
  data_suspensao?: string;
  status?: string;
}

export interface PrescricaoItensUpdate {
  tipo_item?: string;
  descricao?: string;
  posologia_detalhada?: string;
  frequencia_horario?: string;
  via_administracao?: string;
  observacao_enfermagem?: string;
  data_inicio?: string;
  data_suspensao?: string;
  status?: string;
}
