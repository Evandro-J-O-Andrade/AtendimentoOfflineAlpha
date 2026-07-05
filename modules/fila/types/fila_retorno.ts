export interface FilaRetorno {
  id: number;
  id_fila: number;
  retorno_em: string;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface FilaRetornoCreate {
  retorno_em?: string;
  ativo?: number;
  criado_em?: string;
}

export interface FilaRetornoUpdate {
  retorno_em?: string;
  ativo?: number;
  criado_em?: string;
}
