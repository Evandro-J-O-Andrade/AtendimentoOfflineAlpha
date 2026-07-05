export interface Triagem {
  id_triagem: number;
  id_atendimento: number;
  id_risco: number;
  queixa: string;
  sinais_vitais: Record<string, unknown>;
  observacao: string;
  id_enfermeiro: number;
  data_hora: string;
  id_entidade: number;
}

export interface TriagemCreate {
  queixa?: string;
  sinais_vitais?: Record<string, unknown>;
  observacao?: string;
  data_hora?: string;
}

export interface TriagemUpdate {
  queixa?: string;
  sinais_vitais?: Record<string, unknown>;
  observacao?: string;
  data_hora?: string;
}
