export interface PdvPagamento {
  id_pagamento: number;
  id_venda: number;
  forma: string;
  valor: number;
  nsu: string;
  autorizacao: string;
  criado_em: string;
  id_entidade: number;
}

export interface PdvPagamentoCreate {
  forma?: string;
  valor?: number;
  nsu?: string;
  autorizacao?: string;
  criado_em?: string;
}

export interface PdvPagamentoUpdate {
  forma?: string;
  valor?: number;
  nsu?: string;
  autorizacao?: string;
  criado_em?: string;
}
