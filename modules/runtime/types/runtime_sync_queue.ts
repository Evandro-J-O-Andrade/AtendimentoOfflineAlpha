export interface RuntimeSyncQueue {
  id_queue: number;
  uuid_evento: string;
  tentativa_sync: number;
  ultimo_erro: string;
  proximo_retry_em: string;
  criado_em: string;
  id_entidade: number;
}

export interface RuntimeSyncQueueCreate {
  tentativa_sync?: number;
  ultimo_erro?: string;
  proximo_retry_em?: string;
  criado_em?: string;
}

export interface RuntimeSyncQueueUpdate {
  tentativa_sync?: number;
  ultimo_erro?: string;
  proximo_retry_em?: string;
  criado_em?: string;
}
