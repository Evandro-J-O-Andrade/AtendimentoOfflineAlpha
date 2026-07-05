export interface TotemEvento {
  id_totem_evento: number;
  id_totem: number;
  evento: string;
  detalhe: string;
  ip_acesso: string;
  criado_em: string;
  id_entidade: number;
}

export interface TotemEventoCreate {
  evento?: string;
  detalhe?: string;
  ip_acesso?: string;
  criado_em?: string;
}

export interface TotemEventoUpdate {
  evento?: string;
  detalhe?: string;
  ip_acesso?: string;
  criado_em?: string;
}
