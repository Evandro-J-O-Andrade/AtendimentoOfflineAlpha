export interface IdentificadorGlobalAssistencial {
  id_global: number;
  uuid_assistencial: string;
  tipo_entidade: string;
  hash_imutavel: string;
  origem_runtime: string;
  bloqueado: number;
  criado_em: string;
  id_entidade: number;
}

export interface IdentificadorGlobalAssistencialCreate {
  hash_imutavel?: string;
  origem_runtime?: string;
  bloqueado?: number;
  criado_em?: string;
}

export interface IdentificadorGlobalAssistencialUpdate {
  hash_imutavel?: string;
  origem_runtime?: string;
  bloqueado?: number;
  criado_em?: string;
}
