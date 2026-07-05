export interface EstoqueMovimentacao {
  id_movimentacao: number;
  id_saldo: number;
  tipo_movimento: string;
  origem_modulo: string;
  id_origem: number;
  quantidade: number;
  id_usuario: number;
  confirmado: number;
  confirmado_em: string;
  criado_em: string;
  id_entidade: number;
}

export interface EstoqueMovimentacaoCreate {
  tipo_movimento?: string;
  origem_modulo?: string;
  confirmado?: number;
  confirmado_em?: string;
  criado_em?: string;
}

export interface EstoqueMovimentacaoUpdate {
  tipo_movimento?: string;
  origem_modulo?: string;
  confirmado?: number;
  confirmado_em?: string;
  criado_em?: string;
}
