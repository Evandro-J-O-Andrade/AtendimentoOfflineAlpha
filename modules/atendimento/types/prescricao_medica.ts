export interface PrescricaoMedica {
  id: number;
  id_atendimento: number;
  id_usuario_medico: number;
  item_nome: string;
  dose: string;
  via: string;
  frequencia: string;
  status: string;
  data_prescricao: string;
  id_entidade: number;
}

export interface PrescricaoMedicaCreate {
  item_nome?: string;
  dose?: string;
  via?: string;
  frequencia?: string;
  status?: string;
  data_prescricao?: string;
}

export interface PrescricaoMedicaUpdate {
  item_nome?: string;
  dose?: string;
  via?: string;
  frequencia?: string;
  status?: string;
  data_prescricao?: string;
}
