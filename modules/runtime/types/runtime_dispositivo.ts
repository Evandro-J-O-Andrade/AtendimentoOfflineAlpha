export interface RuntimeDispositivo {
  id_runtime_dispositivo: number;
  id_dispositivo: number;
  uuid_runtime: string;
  tipo_runtime: string;
  versao_runtime: string;
  ip_runtime: string;
  status_runtime: string;
  ultimo_heartbeat: string;
  criado_em: string;
  id_entidade: number;
}

export interface RuntimeDispositivoCreate {
  tipo_runtime?: string;
  versao_runtime?: string;
  ip_runtime?: string;
  status_runtime?: string;
  ultimo_heartbeat?: string;
  criado_em?: string;
}

export interface RuntimeDispositivoUpdate {
  tipo_runtime?: string;
  versao_runtime?: string;
  ip_runtime?: string;
  status_runtime?: string;
  ultimo_heartbeat?: string;
  criado_em?: string;
}
