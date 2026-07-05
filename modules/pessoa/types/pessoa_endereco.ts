export interface PessoaEndereco {
  id_pessoa_endereco: number;
  id_pessoa: number;
  id_cidade: number;
  tipo: string;
  principal: number;
  cep: string;
  logradouro: string;
  numero: string;
  complemento: string;
  bairro: string;
  referencia: string;
  latitude: number;
  longitude: number;
  valido_de: string;
  valido_ate: string;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface PessoaEnderecoCreate {
  tipo?: string;
  principal?: number;
  cep?: string;
  logradouro?: string;
  numero?: string;
  complemento?: string;
  bairro?: string;
  referencia?: string;
  latitude?: number;
  longitude?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface PessoaEnderecoUpdate {
  tipo?: string;
  principal?: number;
  cep?: string;
  logradouro?: string;
  numero?: string;
  complemento?: string;
  bairro?: string;
  referencia?: string;
  latitude?: number;
  longitude?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
