export interface EstoqueReserva {
  id_reserva: number;
  id_estoque_local: number;
  id_produto: number;
  id_lote: number;
  quantidade: number;
  origem_tipo: string;
  id_documento_origem: number;
  status: string;
  hash_anterior: string;
  hash_atual: string;
  id_sessao_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface EstoqueReservaCreate {
  origem_tipo?: string;
  status?: string;
  hash_anterior?: string;
  hash_atual?: string;
  criado_em?: string;
}

export interface EstoqueReservaUpdate {
  origem_tipo?: string;
  status?: string;
  hash_anterior?: string;
  hash_atual?: string;
  criado_em?: string;
}
