export interface ProtocoloAssistencialGlobal {
  id_protocolo: number;
  dominio_fluxo: string;
  versao_protocolo: number;
  hash_protocolar: string;
  payload_protocolo: Record<string, unknown>;
  estado_protocolo: string;
  criado_em: string;
  atualizado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface ProtocoloAssistencialGlobalCreate {
  dominio_fluxo?: string;
  versao_protocolo?: number;
  hash_protocolar?: string;
  payload_protocolo?: Record<string, unknown>;
  estado_protocolo?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface ProtocoloAssistencialGlobalUpdate {
  dominio_fluxo?: string;
  versao_protocolo?: number;
  hash_protocolar?: string;
  payload_protocolo?: Record<string, unknown>;
  estado_protocolo?: string;
  criado_em?: string;
  atualizado_em?: string;
}
