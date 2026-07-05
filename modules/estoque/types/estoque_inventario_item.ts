export interface EstoqueInventarioItem {
  id_item: number;
  id_inventario: number;
  id_produto: number;
  id_lote: number;
  qtd_sistema: number;
  qtd_contada: number;
  divergencia: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface EstoqueInventarioItemCreate {
  qtd_sistema?: number;
  qtd_contada?: number;
  divergencia?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface EstoqueInventarioItemUpdate {
  qtd_sistema?: number;
  qtd_contada?: number;
  divergencia?: number;
  criado_em?: string;
  atualizado_em?: string;
}
