export interface KernelRuntimeHeartbeat {
  id_heartbeat: number;
  uuid_runtime: string;
  estado_runtime: string;
  ultimo_ping: string;
  ativo: number;
  id_entidade: number;
}

export interface KernelRuntimeHeartbeatCreate {
  estado_runtime?: string;
  ultimo_ping?: string;
  ativo?: number;
}

export interface KernelRuntimeHeartbeatUpdate {
  estado_runtime?: string;
  ultimo_ping?: string;
  ativo?: number;
}
