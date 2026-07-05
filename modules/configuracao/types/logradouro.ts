export interface Logradouro {
  id_logradouro: number;
  cep: string;
  logradouro: string;
  numero: string;
  complemento: string;
  bairro: string;
  cidade: string;
  uf: string;
  criado_em: string;
  id_entidade: number;
}

export interface LogradouroCreate {
  cep?: string;
  logradouro?: string;
  numero?: string;
  complemento?: string;
  bairro?: string;
  uf?: string;
  criado_em?: string;
}

export interface LogradouroUpdate {
  cep?: string;
  logradouro?: string;
  numero?: string;
  complemento?: string;
  bairro?: string;
  uf?: string;
  criado_em?: string;
}
