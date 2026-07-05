export interface Prescricao {
  id_prescricao: number;
  id_atendimento: number;
  tipo: string;
  descricao: string;
  id_medico: number;
  data_hora: string;
  bloqueada: number;
  id_entidade: number;
}

export interface PrescricaoCreate {
  tipo?: string;
  descricao?: string;
  data_hora?: string;
  bloqueada?: number;
}

export interface PrescricaoUpdate {
  tipo?: string;
  descricao?: string;
  data_hora?: string;
  bloqueada?: number;
}
