export interface PrioridadeSocial {
  id: number;
  codigo: string;
  descricao: string;
  peso: number;
  ativo: number;
  id_entidade: number;
}

export interface PrioridadeSocialCreate {
  codigo?: string;
  descricao?: string;
  peso?: number;
  ativo?: number;
}

export interface PrioridadeSocialUpdate {
  codigo?: string;
  descricao?: string;
  peso?: number;
  ativo?: number;
}
