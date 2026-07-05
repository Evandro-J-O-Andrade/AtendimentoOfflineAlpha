export interface GuardiaoRuntimeFinal {
  id_guardiao: number;
  uuid_runtime: string;
  id_unidade: number;
  hash_contexto: string;
  estado_permitido: number;
  motivo_bloqueio: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface GuardiaoRuntimeFinalCreate {
  hash_contexto?: string;
  motivo_bloqueio?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface GuardiaoRuntimeFinalUpdate {
  hash_contexto?: string;
  motivo_bloqueio?: string;
  criado_em?: string;
  atualizado_em?: string;
}
