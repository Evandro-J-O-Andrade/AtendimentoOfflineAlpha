export interface FarmDispensacaoItem {
  id_item: number;
  id_dispensacao: number;
  id_produto: number;
  lote: number;
  quantidade: number;
  valor_unitario: number;
  id_entidade: number;
}

export interface FarmDispensacaoItemCreate {
  lote?: number;
  valor_unitario?: number;
}

export interface FarmDispensacaoItemUpdate {
  lote?: number;
  valor_unitario?: number;
}
