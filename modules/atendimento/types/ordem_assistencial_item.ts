export interface OrdemAssistencialItem {
  id_item: number;
  id_ordem: number;
  tipo_item: string;
  id_farmaco: number;
  descricao_item: string;
  dose: string;
  via: string;
  posologia: string;
  dias: number;
  quantidade: number;
  unidade: string;
  frequencia_min: number;
  frequencia_txt: string;
  horarios_json: Record<string, unknown>;
  inicio_em: string;
  fim_em: string;
  quantidade_total: number;
  status: string;
  observacao: string;
  criado_por: number;
  id_sessao_usuario_criado: number;
  criado_em: string;
  atualizado_por: number;
  id_sessao_usuario_atualizado: number;
  atualizado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface OrdemAssistencialItemCreate {
  tipo_item?: string;
  descricao_item?: string;
  dose?: string;
  via?: string;
  posologia?: string;
  dias?: number;
  frequencia_min?: number;
  frequencia_txt?: string;
  horarios_json?: Record<string, unknown>;
  inicio_em?: string;
  fim_em?: string;
  status?: string;
  observacao?: string;
  criado_por?: number;
  criado_em?: string;
  atualizado_por?: number;
  atualizado_em?: string;
}

export interface OrdemAssistencialItemUpdate {
  tipo_item?: string;
  descricao_item?: string;
  dose?: string;
  via?: string;
  posologia?: string;
  dias?: number;
  frequencia_min?: number;
  frequencia_txt?: string;
  horarios_json?: Record<string, unknown>;
  inicio_em?: string;
  fim_em?: string;
  status?: string;
  observacao?: string;
  criado_por?: number;
  criado_em?: string;
  atualizado_por?: number;
  atualizado_em?: string;
}
