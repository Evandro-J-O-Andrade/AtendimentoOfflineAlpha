export interface FilaEvento {
  id: number;
  id_fila: number;
  evento: string;
  id_usuario: number;
  id_local: number;
  detalhe: string;
  criado_em: string;
  id_entidade: number;
}

export interface FilaEventoCreate {
  evento?: string;
  detalhe?: string;
  criado_em?: string;
}

export interface FilaEventoUpdate {
  evento?: string;
  detalhe?: string;
  criado_em?: string;
}
