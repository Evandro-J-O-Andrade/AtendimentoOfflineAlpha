export interface PessoaIdentificador {
  id_pessoa_identificador: number;
  id_pessoa: number;
  tipo_identificador: string;
  identificador: string;
  sistema_origem: string;
  descricao: string;
  principal: number;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface PessoaIdentificadorCreate {
  sistema_origem?: string;
  descricao?: string;
  principal?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface PessoaIdentificadorUpdate {
  sistema_origem?: string;
  descricao?: string;
  principal?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
