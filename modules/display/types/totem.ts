export interface Totem {
  id_totem: number;
  id_unidade: number;
  codigo: string;
  descricao: string;
  ip: string;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface TotemCreate {
  codigo?: string;
  descricao?: string;
  ip?: string;
  ativo?: number;
  criado_em?: string;
}

export interface TotemUpdate {
  codigo?: string;
  descricao?: string;
  ip?: string;
  ativo?: number;
  criado_em?: string;
}
