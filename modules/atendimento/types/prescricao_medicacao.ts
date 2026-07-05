export interface PrescricaoMedicacao {
  id_prescricao: number;
  id_ffa: number;
  id_medico: number;
  descricao: string;
  controlada: number;
  criada_em: string;
  ativa: number;
  id_entidade: number;
}

export interface PrescricaoMedicacaoCreate {
  descricao?: string;
  controlada?: number;
  criada_em?: string;
  ativa?: number;
}

export interface PrescricaoMedicacaoUpdate {
  descricao?: string;
  controlada?: number;
  criada_em?: string;
  ativa?: number;
}
