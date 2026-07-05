export interface InternacaoPrescricao {
  id_internacao_prescricao: number;
  id_internacao: number;
  data_prescricao: string;
  status: string;
  observacoes: string;
  id_usuario_prescritor: number;
  id_sessao_usuario: number;
  criado_em: string;
  atualizado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface InternacaoPrescricaoCreate {
  data_prescricao?: string;
  status?: string;
  observacoes?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface InternacaoPrescricaoUpdate {
  data_prescricao?: string;
  status?: string;
  observacoes?: string;
  criado_em?: string;
  atualizado_em?: string;
}
