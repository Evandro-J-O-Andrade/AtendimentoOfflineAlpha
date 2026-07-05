export interface CatAcidenteTrabalhoEvento {
  id_evento: number;
  id_cat: number;
  tipo_evento: string;
  status_anterior: string;
  status_novo: string;
  detalhes: string;
  id_sessao_usuario: number;
  id_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface CatAcidenteTrabalhoEventoCreate {
  tipo_evento?: string;
  status_anterior?: string;
  status_novo?: string;
  detalhes?: string;
  criado_em?: string;
}

export interface CatAcidenteTrabalhoEventoUpdate {
  tipo_evento?: string;
  status_anterior?: string;
  status_novo?: string;
  detalhes?: string;
  criado_em?: string;
}
