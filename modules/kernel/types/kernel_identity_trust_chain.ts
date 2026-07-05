export interface KernelIdentityTrustChain {
  id_chain: number;
  id_tenant: number;
  id_usuario: number;
  id_sessao: number;
  id_dispositivo: number;
  ip_origem: string;
  user_agent: string;
  fingerprint_runtime: string;
  fingerprint_behavior: string;
  fingerprint_device: string;
  estado_runtime: string;
  score_risco: number;
  limite_risco: number;
  tentativas: number;
  janela_tentativa: number;
  nonce_runtime: string;
  lineage_hash: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface KernelIdentityTrustChainCreate {
  ip_origem?: string;
  user_agent?: string;
  fingerprint_runtime?: string;
  fingerprint_behavior?: string;
  fingerprint_device?: string;
  estado_runtime?: string;
  score_risco?: number;
  limite_risco?: number;
  tentativas?: number;
  janela_tentativa?: number;
  nonce_runtime?: string;
  lineage_hash?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface KernelIdentityTrustChainUpdate {
  ip_origem?: string;
  user_agent?: string;
  fingerprint_runtime?: string;
  fingerprint_behavior?: string;
  fingerprint_device?: string;
  estado_runtime?: string;
  score_risco?: number;
  limite_risco?: number;
  tentativas?: number;
  janela_tentativa?: number;
  nonce_runtime?: string;
  lineage_hash?: string;
  criado_em?: string;
  atualizado_em?: string;
}
