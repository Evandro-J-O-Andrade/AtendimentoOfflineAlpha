export interface AtendimentoIdentidadeFluxo {
  id_fluxo: number;
  uuid_evento: string;
  uuid_pessoa_assistida: string;
  tipo_entidade: string;
  origem_cadastro: string;
  metadata_fluxo: Record<string, unknown>;
  criado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface AtendimentoIdentidadeFluxoCreate {
  origem_cadastro?: string;
  metadata_fluxo?: Record<string, unknown>;
  criado_em?: string;
}

export interface AtendimentoIdentidadeFluxoUpdate {
  origem_cadastro?: string;
  metadata_fluxo?: Record<string, unknown>;
  criado_em?: string;
}
