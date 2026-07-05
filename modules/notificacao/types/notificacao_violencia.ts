export interface NotificacaoViolencia {
  id: number;
  id_atendimento: number;
  categoria: string;
  tipo: string;
  data_ocorrencia: string;
  local_ocorrencia: string;
  suspeito_relacao: string;
  cid10_relacionado: string;
  status_notificacao: string;
  id_sessao_usuario: number;
  id_usuario_criador: number;
  observacao: string;
  protocolo_externo: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface NotificacaoViolenciaCreate {
  categoria?: string;
  tipo?: string;
  data_ocorrencia?: string;
  local_ocorrencia?: string;
  suspeito_relacao?: string;
  status_notificacao?: string;
  observacao?: string;
  protocolo_externo?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface NotificacaoViolenciaUpdate {
  categoria?: string;
  tipo?: string;
  data_ocorrencia?: string;
  local_ocorrencia?: string;
  suspeito_relacao?: string;
  status_notificacao?: string;
  observacao?: string;
  protocolo_externo?: string;
  criado_em?: string;
  atualizado_em?: string;
}
