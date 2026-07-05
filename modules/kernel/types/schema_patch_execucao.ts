export interface SchemaPatchExecucao {
  id_patch_execucao: number;
  patch_nome: string;
  hash_patch: string;
  status_execucao: string;
  detalhes: Record<string, unknown>;
  executado_em: string;
  id_entidade: number;
}

export interface SchemaPatchExecucaoCreate {
  patch_nome?: string;
  hash_patch?: string;
  status_execucao?: string;
  detalhes?: Record<string, unknown>;
  executado_em?: string;
}

export interface SchemaPatchExecucaoUpdate {
  patch_nome?: string;
  hash_patch?: string;
  status_execucao?: string;
  detalhes?: Record<string, unknown>;
  executado_em?: string;
}
