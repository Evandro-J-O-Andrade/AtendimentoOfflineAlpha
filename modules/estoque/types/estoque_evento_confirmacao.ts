export interface EstoqueEventoConfirmacao {
  id_evento: number;
  hash_execucao: string;
  id_movimento: number;
  id_usuario_executor: number;
  id_usuario_confirmador: number;
  tipo_evento: string;
  status_confirmacao: string;
  id_entidade: number;
}

export interface EstoqueEventoConfirmacaoCreate {
  hash_execucao?: string;
  tipo_evento?: string;
  status_confirmacao?: string;
}

export interface EstoqueEventoConfirmacaoUpdate {
  hash_execucao?: string;
  tipo_evento?: string;
  status_confirmacao?: string;
}
