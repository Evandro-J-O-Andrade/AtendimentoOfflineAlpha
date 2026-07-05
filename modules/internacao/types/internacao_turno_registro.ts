export interface InternacaoTurnoRegistro {
  id_internacao_turno_registro: number;
  id_internacao: number;
  data_referencia: string;
  turno: string;
  observacoes_gerais: string;
  id_usuario_responsavel: number;
  id_sessao_usuario: number;
  criado_em: string;
  atualizado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface InternacaoTurnoRegistroCreate {
  data_referencia?: string;
  turno?: string;
  observacoes_gerais?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface InternacaoTurnoRegistroUpdate {
  data_referencia?: string;
  turno?: string;
  observacoes_gerais?: string;
  criado_em?: string;
  atualizado_em?: string;
}
