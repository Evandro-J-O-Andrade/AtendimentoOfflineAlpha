export interface EstoqueAlmoxarifadoCentral {
  id: number;
  id_produto: number;
  lote: string;
  validade: string;
  quantidade_atual: number;
  valor_unitario_compra: number;
  id_fornecedor: number;
  nota_fiscal: string;
  data_entrada: string;
  id_entidade: number;
}

export interface EstoqueAlmoxarifadoCentralCreate {
  lote?: string;
  valor_unitario_compra?: number;
  nota_fiscal?: string;
  data_entrada?: string;
}

export interface EstoqueAlmoxarifadoCentralUpdate {
  lote?: string;
  valor_unitario_compra?: number;
  nota_fiscal?: string;
  data_entrada?: string;
}
