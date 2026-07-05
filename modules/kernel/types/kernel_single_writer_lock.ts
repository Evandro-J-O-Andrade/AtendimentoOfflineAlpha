export interface KernelSingleWriterLock {
  id_lock: number;
  uuid_runtime: string;
  bloqueado: number;
  criado_em: string;
  id_entidade: number;
}

export interface KernelSingleWriterLockCreate {
  bloqueado?: number;
  criado_em?: string;
}

export interface KernelSingleWriterLockUpdate {
  bloqueado?: number;
  criado_em?: string;
}
