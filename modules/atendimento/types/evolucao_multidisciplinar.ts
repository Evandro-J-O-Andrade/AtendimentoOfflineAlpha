export interface EvolucaoMultidisciplinar {
  id_evolucao: number;
  id_atendimento: number;
  area: string;
  descricao: string;
  id_usuario: number;
  data_hora: string;
  id_entidade: number;
}

export interface EvolucaoMultidisciplinarCreate {
  area?: string;
  descricao?: string;
  data_hora?: string;
}

export interface EvolucaoMultidisciplinarUpdate {
  area?: string;
  descricao?: string;
  data_hora?: string;
}
