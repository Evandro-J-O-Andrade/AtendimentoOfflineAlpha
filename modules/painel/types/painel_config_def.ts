export interface PainelConfigDef {
  id_painel_config_def: number;
  chave: string;
  aplica_em: string;
  tipo_valor: string;
  default_bool: number;
  default_int: number;
  default_decimal: number;
  default_text: string;
  default_json: Record<string, unknown>;
  default_enum: string;
  categoria: string;
  descricao: string;
  enum_opcoes_json: Record<string, unknown>;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface PainelConfigDefCreate {
  chave?: string;
  aplica_em?: string;
  tipo_valor?: string;
  default_bool?: number;
  default_int?: number;
  default_decimal?: number;
  default_text?: string;
  default_json?: Record<string, unknown>;
  default_enum?: string;
  categoria?: string;
  descricao?: string;
  enum_opcoes_json?: Record<string, unknown>;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface PainelConfigDefUpdate {
  chave?: string;
  aplica_em?: string;
  tipo_valor?: string;
  default_bool?: number;
  default_int?: number;
  default_decimal?: number;
  default_text?: string;
  default_json?: Record<string, unknown>;
  default_enum?: string;
  categoria?: string;
  descricao?: string;
  enum_opcoes_json?: Record<string, unknown>;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
