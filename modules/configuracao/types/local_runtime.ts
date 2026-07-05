export interface LocalRuntime {
  id_local_runtime: number;
  id_local: number;
  dispositivo_tipo: string;
  criado_em: string;
  id_entidade: number;
}

export interface LocalRuntimeCreate {
  dispositivo_tipo?: string;
  criado_em?: string;
}

export interface LocalRuntimeUpdate {
  dispositivo_tipo?: string;
  criado_em?: string;
}
