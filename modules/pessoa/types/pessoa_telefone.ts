export interface PessoaTelefone {
  id_pessoa_telefone: number;
  id_pessoa: number;
  numero: string;
  tipo: string;
  principal: number;
  whatsapp: number;
  ativo: number;
  valido_de: string;
  valido_ate: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface PessoaTelefoneCreate {
  numero?: string;
  tipo?: string;
  principal?: number;
  whatsapp?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface PessoaTelefoneUpdate {
  numero?: string;
  tipo?: string;
  principal?: number;
  whatsapp?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
