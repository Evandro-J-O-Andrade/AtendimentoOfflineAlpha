export interface Unidade {
  id_unidade: number;
  id_entidade: number;
  id_cidade: number;
  nome: string;
  tipo: string;
  criado_em: string;
}

export interface UnidadeCreate {
  nome?: string;
  tipo?: string;
  criado_em?: string;
}

export interface UnidadeUpdate {
  nome?: string;
  tipo?: string;
  criado_em?: string;
}
