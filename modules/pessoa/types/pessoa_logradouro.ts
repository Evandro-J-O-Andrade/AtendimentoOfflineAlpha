export interface PessoaLogradouro {
  id_pessoa: number;
  id_logradouro: number;
  principal: number;
  data_inicio: string;
  data_fim: string;
  ativo: number;
  id_entidade: number;
}

export interface PessoaLogradouroCreate {
  principal?: number;
  data_inicio?: string;
  data_fim?: string;
  ativo?: number;
}

export interface PessoaLogradouroUpdate {
  principal?: number;
  data_inicio?: string;
  data_fim?: string;
  ativo?: number;
}
