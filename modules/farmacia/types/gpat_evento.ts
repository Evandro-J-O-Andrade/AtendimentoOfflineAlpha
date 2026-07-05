export interface GpatEvento {
  id_gpat_evento: number;
  id_gpat: number;
  tipo_evento: string;
  detalhes: string;
  id_usuario: number;
  id_sessao_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface GpatEventoCreate {
  tipo_evento?: string;
  detalhes?: string;
  criado_em?: string;
}

export interface GpatEventoUpdate {
  tipo_evento?: string;
  detalhes?: string;
  criado_em?: string;
}
