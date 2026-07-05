export interface EstoqueReservaEvento {
  id_evento: number;
  id_reserva: number;
  id_sessao_usuario: number;
  tipo_evento: string;
  detalhe: string;
  hash_anterior: string;
  hash_atual: string;
  criado_em: string;
  id_entidade: number;
}

export interface EstoqueReservaEventoCreate {
  tipo_evento?: string;
  detalhe?: string;
  hash_anterior?: string;
  hash_atual?: string;
  criado_em?: string;
}

export interface EstoqueReservaEventoUpdate {
  tipo_evento?: string;
  detalhe?: string;
  hash_anterior?: string;
  hash_atual?: string;
  criado_em?: string;
}
