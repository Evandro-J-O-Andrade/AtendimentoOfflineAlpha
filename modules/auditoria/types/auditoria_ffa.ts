export interface AuditoriaFfa {
  id: number;
  id_ffa: number;
  id_usuario: number;
  tipo_evento: string;
  acao: string;
  timestamp: string;
  id_entidade: number;
}

export interface AuditoriaFfaCreate {
  tipo_evento?: string;
  acao?: string;
  timestamp?: string;
}

export interface AuditoriaFfaUpdate {
  tipo_evento?: string;
  acao?: string;
  timestamp?: string;
}
