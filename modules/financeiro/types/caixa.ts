export interface Caixa {
  id_caixa: number;
  id_unidade: number;
  id_local_operacional: number;
  status: string;
  aberto_em: string;
  fechado_em: string;
  aberto_por: number;
  fechado_por: number;
  id_entidade: number;
}

export interface CaixaCreate {
  status?: string;
  aberto_em?: string;
  fechado_em?: string;
  aberto_por?: number;
  fechado_por?: number;
}

export interface CaixaUpdate {
  status?: string;
  aberto_em?: string;
  fechado_em?: string;
  aberto_por?: number;
  fechado_por?: number;
}
