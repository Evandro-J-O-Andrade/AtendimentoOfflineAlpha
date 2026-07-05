export interface PessoaEmail {
  id_pessoa_email: number;
  id_pessoa: number;
  email: string;
  tipo: string;
  principal: number;
  verificado: number;
  ativo: number;
  valido_de: string;
  valido_ate: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface PessoaEmailCreate {
  email?: string;
  tipo?: string;
  principal?: number;
  verificado?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface PessoaEmailUpdate {
  email?: string;
  tipo?: string;
  principal?: number;
  verificado?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
