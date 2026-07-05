export interface EstoqueDocumentoExecucao {
  id: number;
  hash_execucao: string;
  id_documento: number;
  tipo_documento: string;
  id_movimento: number;
  id_sessao_usuario: number;
  contexto_operacional: string;
  estado_execucao: string;
  tentativa_execucao: number;
  hash_pipeline_anterior: string;
  hash_pipeline_atual: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface EstoqueDocumentoExecucaoCreate {
  hash_execucao?: string;
  tipo_documento?: string;
  contexto_operacional?: string;
  estado_execucao?: string;
  tentativa_execucao?: number;
  hash_pipeline_anterior?: string;
  hash_pipeline_atual?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface EstoqueDocumentoExecucaoUpdate {
  hash_execucao?: string;
  tipo_documento?: string;
  contexto_operacional?: string;
  estado_execucao?: string;
  tentativa_execucao?: number;
  hash_pipeline_anterior?: string;
  hash_pipeline_atual?: string;
  criado_em?: string;
  atualizado_em?: string;
}
