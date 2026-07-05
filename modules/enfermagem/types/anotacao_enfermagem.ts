export interface AnotacaoEnfermagem {
  id_anotacao: number;
  id_internacao: number;
  descricao: string;
  id_usuario: number;
  data_hora: string;
  id_entidade: number;
}

export interface AnotacaoEnfermagemCreate {
  descricao?: string;
  data_hora?: string;
}

export interface AnotacaoEnfermagemUpdate {
  descricao?: string;
  data_hora?: string;
}
