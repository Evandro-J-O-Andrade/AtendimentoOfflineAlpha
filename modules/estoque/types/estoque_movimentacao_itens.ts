export interface EstoqueMovimentacaoItens {
  id: number;
  id_atendimento: number;
  id_produto: number;
  quantidade_saida: number;
  id_usuario_quem_deu_baixa: number;
  data_movimento: string;
  id_entidade: number;
}

export interface EstoqueMovimentacaoItensCreate {
  data_movimento?: string;
}

export interface EstoqueMovimentacaoItensUpdate {
  data_movimento?: string;
}
