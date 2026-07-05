export interface LocalFila {
  id_local_fila: number;
  id_local: number;
  codigo_fila: string;
  nome_fila: string;
  prioridade: number;
  criado_em: string;
  id_entidade: number;
}

export interface LocalFilaCreate {
  codigo_fila?: string;
  nome_fila?: string;
  criado_em?: string;
}

export interface LocalFilaUpdate {
  codigo_fila?: string;
  nome_fila?: string;
  criado_em?: string;
}
