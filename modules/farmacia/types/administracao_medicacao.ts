export interface AdministracaoMedicacao {
  id_admin: number;
  id_prescricao: number;
  id_enfermeiro: number;
  dose: string;
  via: string;
  data_hora: string;
  observacao: string;
  id_entidade: number;
}

export interface AdministracaoMedicacaoCreate {
  dose?: string;
  via?: string;
  data_hora?: string;
  observacao?: string;
}

export interface AdministracaoMedicacaoUpdate {
  dose?: string;
  via?: string;
  data_hora?: string;
  observacao?: string;
}
