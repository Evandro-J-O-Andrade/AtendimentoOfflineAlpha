export interface PessoaVinculo {
  id_pessoa_vinculo: number;
  id_pessoa_origem: number;
  id_pessoa_destino: number;
  tipo_vinculo: string;
  observacao: string;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface PessoaVinculoCreate {
  tipo_vinculo?: string;
  observacao?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface PessoaVinculoUpdate {
  tipo_vinculo?: string;
  observacao?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
