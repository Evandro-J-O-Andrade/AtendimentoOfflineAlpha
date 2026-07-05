export interface InternacaoMovimentacao {
  id: number;
  id_internacao: number;
  id_leito_origem: number;
  id_leito_destino: number;
  id_usuario_transferencia: number;
  data_movimentacao: string;
  motivo: string;
  id_sessao_usuario: number;
  id_local_operacional: number;
  id_unidade: number;
  id_atendimento: number;
  id_entidade: number;
}

export interface InternacaoMovimentacaoCreate {
  data_movimentacao?: string;
  motivo?: string;
}

export interface InternacaoMovimentacaoUpdate {
  data_movimentacao?: string;
  motivo?: string;
}
