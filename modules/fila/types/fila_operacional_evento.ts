export interface FilaOperacionalEvento {
  id_evento: number;
  id_fila: number;
  id_sessao_usuario: number;
  tipo_evento: string;
  detalhe: string;
  criado_em: string;
  id_entidade: number;
}

export interface FilaOperacionalEventoCreate {
  tipo_evento?: string;
  detalhe?: string;
  criado_em?: string;
}

export interface FilaOperacionalEventoUpdate {
  tipo_evento?: string;
  detalhe?: string;
  criado_em?: string;
}
