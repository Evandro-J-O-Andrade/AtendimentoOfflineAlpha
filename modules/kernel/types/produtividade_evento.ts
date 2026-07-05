export interface ProdutividadeEvento {
  id_evento: number;
  id_unidade: number;
  id_usuario: number;
  tipo: string;
  id_ffa: number;
  id_senha: number;
  ocorrido_em: string;
  detalhe: string;
  id_entidade: number;
}

export interface ProdutividadeEventoCreate {
  tipo?: string;
  detalhe?: string;
}

export interface ProdutividadeEventoUpdate {
  tipo?: string;
  detalhe?: string;
}
