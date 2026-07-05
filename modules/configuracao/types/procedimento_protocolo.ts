export interface ProcedimentoProtocolo {
  id_protocolo: number;
  tipo: string;
  codigo: string;
  barcode: string;
  status: string;
  id_ffa: number;
  id_fila: number;
  id_sessao_criacao: number;
  id_usuario_criacao: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface ProcedimentoProtocoloCreate {
  tipo?: string;
  codigo?: string;
  barcode?: string;
  status?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface ProcedimentoProtocoloUpdate {
  tipo?: string;
  codigo?: string;
  barcode?: string;
  status?: string;
  criado_em?: string;
  atualizado_em?: string;
}
