export interface Intercorrencia {
  id_intercorrencia: number;
  id_atendimento: number;
  id_internacao: number;
  descricao: string;
  gravidade: string;
  id_usuario: number;
  data_hora: string;
  id_entidade: number;
}

export interface IntercorrenciaCreate {
  descricao?: string;
  data_hora?: string;
}

export interface IntercorrenciaUpdate {
  descricao?: string;
  data_hora?: string;
}
