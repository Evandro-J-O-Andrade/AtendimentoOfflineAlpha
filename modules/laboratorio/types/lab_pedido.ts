export interface LabPedido {
  id_pedido: number;
  protocolo_interno: string;
  id_senha: number;
  id_ffa: number;
  id_atendimento: number;
  id_laboratorio: number;
  status: string;
  impresso: number;
  criado_em: string;
  id_entidade: number;
}

export interface LabPedidoCreate {
  protocolo_interno?: string;
  status?: string;
  impresso?: number;
  criado_em?: string;
}

export interface LabPedidoUpdate {
  protocolo_interno?: string;
  status?: string;
  impresso?: number;
  criado_em?: string;
}
