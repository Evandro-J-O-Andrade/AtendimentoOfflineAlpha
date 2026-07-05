export interface ClassificacaoRisco {
  id_risco: number;
  cor: string;
  tempo_max: number;
  descricao: string;
  id_entidade: number;
}

export interface ClassificacaoRiscoCreate {
  cor?: string;
  tempo_max?: number;
  descricao?: string;
}

export interface ClassificacaoRiscoUpdate {
  cor?: string;
  tempo_max?: number;
  descricao?: string;
}
