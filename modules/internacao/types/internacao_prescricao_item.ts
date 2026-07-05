export interface InternacaoPrescricaoItem {
  id_internacao_prescricao_item: number;
  id_internacao_prescricao: number;
  tipo: string;
  descricao: string;
  dosagem: string;
  frequencia: string;
  via_administracao: string;
  inicio_em: string;
  fim_em: string;
  status: string;
  observacoes: string;
  criado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface InternacaoPrescricaoItemCreate {
  tipo?: string;
  descricao?: string;
  dosagem?: string;
  frequencia?: string;
  via_administracao?: string;
  inicio_em?: string;
  fim_em?: string;
  status?: string;
  observacoes?: string;
  criado_em?: string;
}

export interface InternacaoPrescricaoItemUpdate {
  tipo?: string;
  descricao?: string;
  dosagem?: string;
  frequencia?: string;
  via_administracao?: string;
  inicio_em?: string;
  fim_em?: string;
  status?: string;
  observacoes?: string;
  criado_em?: string;
}
