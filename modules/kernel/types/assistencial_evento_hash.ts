export interface AssistencialEventoHash {
  id_hash: number;
  hash_fingerprint: string;
  id_ffa: number;
  evento: string;
  criado_em: string;
  id_entidade: number;
}

export interface AssistencialEventoHashCreate {
  hash_fingerprint?: string;
  evento?: string;
  criado_em?: string;
}

export interface AssistencialEventoHashUpdate {
  hash_fingerprint?: string;
  evento?: string;
  criado_em?: string;
}
