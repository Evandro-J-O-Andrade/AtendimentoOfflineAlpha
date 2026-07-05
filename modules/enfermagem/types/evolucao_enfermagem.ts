export interface EvolucaoEnfermagem {
  id_evolucao: number;
  id_internacao: number;
  descricao: string;
  id_enfermeiro: number;
  data_hora: string;
  id_entidade: number;
}

export interface EvolucaoEnfermagemCreate {
  descricao?: string;
  data_hora?: string;
}

export interface EvolucaoEnfermagemUpdate {
  descricao?: string;
  data_hora?: string;
}
