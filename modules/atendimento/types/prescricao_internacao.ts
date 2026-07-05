export interface PrescricaoInternacao {
  id_prescricao: number;
  id_internacao: number;
  tipo: string;
  descricao: string;
  id_medico: number;
  ativa: number;
  data_hora: string;
  id_entidade: number;
}

export interface PrescricaoInternacaoCreate {
  tipo?: string;
  descricao?: string;
  ativa?: number;
  data_hora?: string;
}

export interface PrescricaoInternacaoUpdate {
  tipo?: string;
  descricao?: string;
  ativa?: number;
  data_hora?: string;
}
