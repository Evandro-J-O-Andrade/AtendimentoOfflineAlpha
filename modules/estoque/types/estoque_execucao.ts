export interface EstoqueExecucao {
  hash_execucao: string;
  id_sessao_usuario: number;
  contexto_operacional: string;
  criado_em: string;
  id_entidade: number;
}

export interface EstoqueExecucaoCreate {
  hash_execucao?: string;
  contexto_operacional?: string;
  criado_em?: string;
}

export interface EstoqueExecucaoUpdate {
  hash_execucao?: string;
  contexto_operacional?: string;
  criado_em?: string;
}
