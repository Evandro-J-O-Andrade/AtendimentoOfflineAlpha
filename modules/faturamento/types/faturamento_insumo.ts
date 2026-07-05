export interface FaturamentoInsumo {
  id_fat_insumo: number;
  id_item: number;
  origem: string;
  id_produto: number;
  lote: string;
  validade: string;
  id_entidade: number;
}

export interface FaturamentoInsumoCreate {
  origem?: string;
  lote?: string;
}

export interface FaturamentoInsumoUpdate {
  origem?: string;
  lote?: string;
}
