export interface ServicoAgendamento {
  id_servico: number;
  id_sistema: number;
  id_unidade: number;
  codigo: string;
  nome: string;
  duracao_minutos: number;
  categoria: string;
  tipo: string;
  exige_profissional: number;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface ServicoAgendamentoCreate {
  codigo?: string;
  nome?: string;
  duracao_minutos?: number;
  categoria?: string;
  tipo?: string;
  exige_profissional?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface ServicoAgendamentoUpdate {
  codigo?: string;
  nome?: string;
  duracao_minutos?: number;
  categoria?: string;
  tipo?: string;
  exige_profissional?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
