export interface Cidade {
  id_cidade: number;
  nome: string;
  estado: string;
  codigo_ibge: string;
  id_entidade: number;
  criado_em: string;
  atualizado_em: string;
}

export interface CidadeCreate {
  nome?: string;
  estado?: string;
  codigo_ibge?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface CidadeUpdate {
  nome?: string;
  estado?: string;
  codigo_ibge?: string;
  criado_em?: string;
  atualizado_em?: string;
}
