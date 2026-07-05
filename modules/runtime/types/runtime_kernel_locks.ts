export interface RuntimeKernelLocks {
  id: number;
  uuid_runtime: string;
  locked_by: number;
  acquired_at: string;
  expires_at: string;
  id_entidade: number;
}

export interface RuntimeKernelLocksCreate {
  locked_by?: number;
  acquired_at?: string;
  expires_at?: string;
}

export interface RuntimeKernelLocksUpdate {
  locked_by?: number;
  acquired_at?: string;
  expires_at?: string;
}
