export interface EventoLimpeza {
  id_evento: number;
  id_setor: number;
  tipo_evento: string;
  registrado_por: number;
  observacao: string;
  criado_em: string;
  id_entidade: number;
}

export interface EventoLimpezaCreate {
  tipo_evento?: string;
  registrado_por?: number;
  observacao?: string;
  criado_em?: string;
}

export interface EventoLimpezaUpdate {
  tipo_evento?: string;
  registrado_por?: number;
  observacao?: string;
  criado_em?: string;
}
