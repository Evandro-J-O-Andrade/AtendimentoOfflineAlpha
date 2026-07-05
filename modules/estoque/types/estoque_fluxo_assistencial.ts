export interface EstoqueFluxoAssistencial {
  id: number;
  id_paciente: number;
  id_ffaitem: number;
  id_movimento: number;
  id_movimento_item: number;
  id_produto: number;
  id_lote: number;
  quantidade: number;
  hash_execucao: string;
  criado_em: string;
  id_entidade: number;
}

export interface EstoqueFluxoAssistencialCreate {
  hash_execucao?: string;
  criado_em?: string;
}

export interface EstoqueFluxoAssistencialUpdate {
  hash_execucao?: string;
  criado_em?: string;
}
