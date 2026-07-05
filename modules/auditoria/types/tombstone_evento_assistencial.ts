export interface TombstoneEventoAssistencial {
  id_tombstone: number;
  id_ffa: number;
  evento: string;
  estado_cancelado: string;
  id_sessao_usuario: number;
  cancelado_em: string;
  id_entidade: number;
}

export interface TombstoneEventoAssistencialCreate {
  evento?: string;
  estado_cancelado?: string;
  cancelado_em?: string;
}

export interface TombstoneEventoAssistencialUpdate {
  evento?: string;
  estado_cancelado?: string;
  cancelado_em?: string;
}
