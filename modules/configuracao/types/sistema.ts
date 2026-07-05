export interface Sistema {
  id_sistema: number;
  nome: string;
  codigo: string;
  criado_em: string;
  id_entidade: number;
}

export interface SistemaCreate {
  nome?: string;
  codigo?: string;
  criado_em?: string;
}

export interface SistemaUpdate {
  nome?: string;
  codigo?: string;
  criado_em?: string;
}
