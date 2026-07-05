export interface CoordenadorEstadoGlobal {
  id_coordenacao: number;
  uuid_runtime: string;
  id_unidade: number;
  estado_atual: string;
  hash_estado: string;
  payload_snapshot: Record<string, unknown>;
  bloqueado: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface CoordenadorEstadoGlobalCreate {
  estado_atual?: string;
  hash_estado?: string;
  payload_snapshot?: Record<string, unknown>;
  bloqueado?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface CoordenadorEstadoGlobalUpdate {
  estado_atual?: string;
  hash_estado?: string;
  payload_snapshot?: Record<string, unknown>;
  bloqueado?: number;
  criado_em?: string;
  atualizado_em?: string;
}
