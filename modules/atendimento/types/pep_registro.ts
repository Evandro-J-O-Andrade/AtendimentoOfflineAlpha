export interface PepRegistro {
  id_pep_registro: number;
  id_ffa: number;
  id_gpat: number;
  id_usuario_autor: number;
  id_local_operacional: number;
  tipo_registro: string;
  payload_json: Record<string, unknown>;
  assinado: number;
  assinado_em: string;
  hash_assinatura: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface PepRegistroCreate {
  tipo_registro?: string;
  payload_json?: Record<string, unknown>;
  assinado?: number;
  assinado_em?: string;
  hash_assinatura?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface PepRegistroUpdate {
  tipo_registro?: string;
  payload_json?: Record<string, unknown>;
  assinado?: number;
  assinado_em?: string;
  hash_assinatura?: string;
  criado_em?: string;
  atualizado_em?: string;
}
