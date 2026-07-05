export interface ProcedimentoProtocoloEvento {
  id_evento: number;
  id_protocolo: number;
  tipo_evento: string;
  detalhe: string;
  criado_em: string;
  id_sessao_usuario: number;
  id_usuario: number;
  id_entidade: number;
}

export interface ProcedimentoProtocoloEventoCreate {
  tipo_evento?: string;
  detalhe?: string;
  criado_em?: string;
}

export interface ProcedimentoProtocoloEventoUpdate {
  tipo_evento?: string;
  detalhe?: string;
  criado_em?: string;
}
