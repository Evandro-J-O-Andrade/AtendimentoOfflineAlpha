export interface CatNotificacao {
  id_cat: number;
  id_ffa: number;
  id_gpat: number;
  id_pedido_item: number;
  id_usuario_responsavel: number;
  status: string;
  data_evento: string;
  local_evento: string;
  ocupacao: string;
  empresa: string;
  cnpj: string;
  detalhes: string;
  protocolo_interno: string;
  protocolo_externo: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface CatNotificacaoCreate {
  status?: string;
  data_evento?: string;
  local_evento?: string;
  ocupacao?: string;
  empresa?: string;
  cnpj?: string;
  detalhes?: string;
  protocolo_interno?: string;
  protocolo_externo?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface CatNotificacaoUpdate {
  status?: string;
  data_evento?: string;
  local_evento?: string;
  ocupacao?: string;
  empresa?: string;
  cnpj?: string;
  detalhes?: string;
  protocolo_interno?: string;
  protocolo_externo?: string;
  criado_em?: string;
  atualizado_em?: string;
}
