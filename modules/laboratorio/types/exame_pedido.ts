export interface ExamePedido {
  id_pedido: number;
  codigo_interno: string;
  id_senha: number;
  id_ffa: number;
  id_atendimento: number;
  status: string;
  id_usuario_solicitante: number;
  criado_em: string;
  id_entidade: number;
}

export interface ExamePedidoCreate {
  codigo_interno?: string;
  status?: string;
  criado_em?: string;
}

export interface ExamePedidoUpdate {
  codigo_interno?: string;
  status?: string;
  criado_em?: string;
}
