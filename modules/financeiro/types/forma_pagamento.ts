export interface FormaPagamento {
  id_forma_pagamento: number;
  codigo: string;
  descricao: string;
  id_entidade: number;
}

export interface FormaPagamentoCreate {
  codigo?: string;
  descricao?: string;
}

export interface FormaPagamentoUpdate {
  codigo?: string;
  descricao?: string;
}
