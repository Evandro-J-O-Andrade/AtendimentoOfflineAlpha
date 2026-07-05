export interface ExamePedidoItem {
  id_item: number;
  id_pedido: number;
  codigo_procedimento: string;
  nome_exame: string;
  material: string;
  valor_custo: number;
  valor_venda: number;
  id_entidade: number;
}

export interface ExamePedidoItemCreate {
  codigo_procedimento?: string;
  nome_exame?: string;
  material?: string;
  valor_custo?: number;
  valor_venda?: number;
}

export interface ExamePedidoItemUpdate {
  codigo_procedimento?: string;
  nome_exame?: string;
  material?: string;
  valor_custo?: number;
  valor_venda?: number;
}
