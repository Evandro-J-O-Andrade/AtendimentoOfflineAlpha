export interface QualidadeEventosAdversos {
  id: number;
  id_atendimento: number;
  tipo_evento: string;
  gravidade: string;
  descricao: string;
  data_evento: string;
  id_entidade: number;
}

export interface QualidadeEventosAdversosCreate {
  tipo_evento?: string;
  descricao?: string;
  data_evento?: string;
}

export interface QualidadeEventosAdversosUpdate {
  tipo_evento?: string;
  descricao?: string;
  data_evento?: string;
}
