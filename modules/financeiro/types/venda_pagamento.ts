export interface VendaPagamento {
  id_venda_pagamento: number;
  id_venda: number;
  id_forma_pagamento: number;
  valor: number;
  criado_em: string;
  id_entidade: number;
}

export interface VendaPagamentoCreate {
  valor?: number;
  criado_em?: string;
}

export interface VendaPagamentoUpdate {
  valor?: number;
  criado_em?: string;
}
