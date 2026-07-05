export interface AtendimentoEvento {
  id_evento: number;
  id_unidade: number;
  id_ffa: number;
  id_atendimento: number;
  id_paciente: number;
  dominio: string;
  tipo_evento: string;
  estado_origem: string;
  estado_destino: string;
  contexto_fluxo: string;
  payload: Record<string, unknown>;
  id_sessao_usuario: number;
  id_usuario: number;
  hash_evento: string;
  criado_em: string;
  id_entidade: number;
}

export interface AtendimentoEventoCreate {
  dominio?: string;
  tipo_evento?: string;
  estado_origem?: string;
  estado_destino?: string;
  contexto_fluxo?: string;
  payload?: Record<string, unknown>;
  hash_evento?: string;
  criado_em?: string;
}

export interface AtendimentoEventoUpdate {
  dominio?: string;
  tipo_evento?: string;
  estado_origem?: string;
  estado_destino?: string;
  contexto_fluxo?: string;
  payload?: Record<string, unknown>;
  hash_evento?: string;
  criado_em?: string;
}
