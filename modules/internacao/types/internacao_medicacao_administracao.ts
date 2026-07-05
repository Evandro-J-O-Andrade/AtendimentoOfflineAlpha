export interface InternacaoMedicacaoAdministracao {
  id_internacao_medicacao_administracao: number;
  id_internacao: number;
  id_internacao_prescricao_item: number;
  data_hora: string;
  status: string;
  dose_aplicada: string;
  via_administracao: string;
  observacoes: string;
  id_usuario_responsavel: number;
  id_sessao_usuario: number;
  criado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface InternacaoMedicacaoAdministracaoCreate {
  data_hora?: string;
  status?: string;
  dose_aplicada?: string;
  via_administracao?: string;
  observacoes?: string;
  criado_em?: string;
}

export interface InternacaoMedicacaoAdministracaoUpdate {
  data_hora?: string;
  status?: string;
  dose_aplicada?: string;
  via_administracao?: string;
  observacoes?: string;
  criado_em?: string;
}
