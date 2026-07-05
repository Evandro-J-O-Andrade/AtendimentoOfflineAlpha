export interface PedidoMedico {
  id_pedido_medico: number;
  id_ffa: number;
  id_gpat: number;
  id_usuario_solicitante: number;
  id_local_operacional: number;
  status: string;
  justificativa: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface PedidoMedicoCreate {
  status?: string;
  justificativa?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface PedidoMedicoUpdate {
  status?: string;
  justificativa?: string;
  criado_em?: string;
  atualizado_em?: string;
}
