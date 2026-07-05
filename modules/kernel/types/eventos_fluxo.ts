export interface EventosFluxo {
  id: number;
  entidade: string;
  entidade_id: number;
  tipo_evento: string;
  descricao: string;
  id_usuario: number;
  perfil_usuario: string;
  local: string;
  data_hora: string;
  id_entidade: number;
}

export interface EventosFluxoCreate {
  tipo_evento?: string;
  descricao?: string;
  perfil_usuario?: string;
  local?: string;
  data_hora?: string;
}

export interface EventosFluxoUpdate {
  tipo_evento?: string;
  descricao?: string;
  perfil_usuario?: string;
  local?: string;
  data_hora?: string;
}
