export interface TvRotativo {
  id_tv_rotativo: number;
  nome: string;
  id_unidade: number;
  intervalo_seg: number;
  criado_em: string;
  criado_por: number;
  atualizado_em: string;
  atualizado_por: number;
  id_entidade: number;
}

export interface TvRotativoCreate {
  nome?: string;
  intervalo_seg?: number;
  criado_em?: string;
  criado_por?: number;
  atualizado_em?: string;
  atualizado_por?: number;
}

export interface TvRotativoUpdate {
  nome?: string;
  intervalo_seg?: number;
  criado_em?: string;
  criado_por?: number;
  atualizado_em?: string;
  atualizado_por?: number;
}
