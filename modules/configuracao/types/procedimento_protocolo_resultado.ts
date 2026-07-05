export interface ProcedimentoProtocoloResultado {
  id_resultado: number;
  id_protocolo: number;
  categoria: string;
  versao: number;
  id_resultado_anterior: number;
  criado_em: string;
  id_sessao_usuario: number;
  id_usuario: number;
  id_entidade: number;
}

export interface ProcedimentoProtocoloResultadoCreate {
  categoria?: string;
  versao?: number;
  criado_em?: string;
}

export interface ProcedimentoProtocoloResultadoUpdate {
  categoria?: string;
  versao?: number;
  criado_em?: string;
}
