export interface GpatAtendimento {
  id_gpat: number;
  codigo: string;
  status: string;
  id_cliente: number;
  tipo_prescritor: string;
  id_usuario_medico: number;
  id_prescritor_externo: number;
  data_emissao: string;
  data_validade: string;
  observacao: string;
  criado_em: string;
  atualizado_em: string;
  id_sessao_abertura: number;
  id_sessao_fechamento: number;
  id_usuario_abertura: number;
  id_usuario_fechamento: number;
  id_atendimento: number;
  id_entidade: number;
}

export interface GpatAtendimentoCreate {
  codigo?: string;
  status?: string;
  tipo_prescritor?: string;
  data_emissao?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface GpatAtendimentoUpdate {
  codigo?: string;
  status?: string;
  tipo_prescritor?: string;
  data_emissao?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}
