export interface EstoqueConta {
  id_conta: number;
  codigo: string;
  descricao: string;
  tipo: string;
  id_entidade: number;
}

export interface EstoqueContaCreate {
  codigo?: string;
  descricao?: string;
  tipo?: string;
}

export interface EstoqueContaUpdate {
  codigo?: string;
  descricao?: string;
  tipo?: string;
}
