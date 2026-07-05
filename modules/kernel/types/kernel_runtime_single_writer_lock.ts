export interface KernelRuntimeSingleWriterLock {
  id_lock: number;
  contexto_runtime: string;
  id_sessao_usuario: number;
  estado_lock: string;
  criado_em: string;
  id_entidade: number;
}

export interface KernelRuntimeSingleWriterLockCreate {
  contexto_runtime?: string;
  estado_lock?: string;
  criado_em?: string;
}

export interface KernelRuntimeSingleWriterLockUpdate {
  contexto_runtime?: string;
  estado_lock?: string;
  criado_em?: string;
}
