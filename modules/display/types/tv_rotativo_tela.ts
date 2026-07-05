export interface TvRotativoTela {
  id_tela: number;
  id_painel: number;
  codigo_tela: string;
  ordem: number;
  duracao_seg: number;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface TvRotativoTelaCreate {
  codigo_tela?: string;
  ordem?: number;
  duracao_seg?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface TvRotativoTelaUpdate {
  codigo_tela?: string;
  ordem?: number;
  duracao_seg?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
