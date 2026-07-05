export interface GasoEvento {
  id_gaso_evento: number;
  id_gaso: number;
  evento: string;
  detalhe: string;
  id_usuario: number;
  id_sessao_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface GasoEventoCreate {
  evento?: string;
  detalhe?: string;
  criado_em?: string;
}

export interface GasoEventoUpdate {
  evento?: string;
  detalhe?: string;
  criado_em?: string;
}
