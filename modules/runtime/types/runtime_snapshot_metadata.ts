export interface RuntimeSnapshotMetadata {
  id_snapshot: number;
  dominio_fluxo: string;
  versao_fluxo: number;
  hash_snapshot: string;
  payload_metadata: Record<string, unknown>;
  ativo: number;
  criado_em: string;
  expiracao_snapshot: string;
  ultima_validacao_runtime: string;
  id_entidade: number;
}

export interface RuntimeSnapshotMetadataCreate {
  dominio_fluxo?: string;
  versao_fluxo?: number;
  hash_snapshot?: string;
  payload_metadata?: Record<string, unknown>;
  ativo?: number;
  criado_em?: string;
  expiracao_snapshot?: string;
}

export interface RuntimeSnapshotMetadataUpdate {
  dominio_fluxo?: string;
  versao_fluxo?: number;
  hash_snapshot?: string;
  payload_metadata?: Record<string, unknown>;
  ativo?: number;
  criado_em?: string;
  expiracao_snapshot?: string;
}
