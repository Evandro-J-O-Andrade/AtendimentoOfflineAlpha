export interface FluxoOrquestradorCanonico {
  id_orquestrador: number;
  dominio_fluxo: string;
  estado_atual: string;
  estado_proximo: string;
  regra_execucao: Record<string, unknown>;
  exige_assinatura_digital: number;
  timeout_execucao_segundos: number;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface FluxoOrquestradorCanonicoCreate {
  dominio_fluxo?: string;
  estado_atual?: string;
  estado_proximo?: string;
  regra_execucao?: Record<string, unknown>;
  exige_assinatura_digital?: number;
  timeout_execucao_segundos?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface FluxoOrquestradorCanonicoUpdate {
  dominio_fluxo?: string;
  estado_atual?: string;
  estado_proximo?: string;
  regra_execucao?: Record<string, unknown>;
  exige_assinatura_digital?: number;
  timeout_execucao_segundos?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
