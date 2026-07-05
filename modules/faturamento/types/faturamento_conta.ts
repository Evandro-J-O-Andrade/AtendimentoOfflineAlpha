export interface FaturamentoConta {
  id_conta: number;
  tipo_conta: string;
  id_ffa: number;
  id_internacao: number;
  status: string;
  valor_total: number;
  aberta_em: string;
  fechada_em: string;
  fechado_por: number;
  numero_conta: string;
  competencia: string;
  id_senha: number;
  id_unidade: number;
  id_local_operacional: number;
  total_bruto: number;
  total_desconto: number;
  total_liquido: number;
  observacao: string;
  id_sessao_usuario_criacao: number;
  criado_por: number;
  atualizado_em: string;
  cancelado_em: string;
  cancelado_por: number;
  id_entidade: number;
}

export interface FaturamentoContaCreate {
  tipo_conta?: string;
  status?: string;
  valor_total?: number;
  aberta_em?: string;
  fechada_em?: string;
  fechado_por?: number;
  numero_conta?: string;
  competencia?: string;
  total_bruto?: number;
  total_desconto?: number;
  observacao?: string;
  criado_por?: number;
  atualizado_em?: string;
  cancelado_em?: string;
  cancelado_por?: number;
}

export interface FaturamentoContaUpdate {
  tipo_conta?: string;
  status?: string;
  valor_total?: number;
  aberta_em?: string;
  fechada_em?: string;
  fechado_por?: number;
  numero_conta?: string;
  competencia?: string;
  total_bruto?: number;
  total_desconto?: number;
  observacao?: string;
  criado_por?: number;
  atualizado_em?: string;
  cancelado_em?: string;
  cancelado_por?: number;
}
