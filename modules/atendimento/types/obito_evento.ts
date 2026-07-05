export interface ObitoEvento {
  id_obito_evento: number;
  id_obito: number;
  tipo_evento: string;
  descricao: string;
  id_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface ObitoEventoCreate {
  tipo_evento?: string;
  descricao?: string;
  criado_em?: string;
}

export interface ObitoEventoUpdate {
  tipo_evento?: string;
  descricao?: string;
  criado_em?: string;
}
