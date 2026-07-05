export interface PainelConfig {
  id_painel_config: number;
  id_painel: number;
  chave: string;
  valor_bool: number;
  valor_int: number;
  valor_decimal: number;
  valor_text: string;
  valor_json: Record<string, unknown>;
  valor_enum: string;
  atualizado_em: string;
  id_sessao_usuario: number;
  id_usuario: number;
  id_entidade: number;
}

export interface PainelConfigCreate {
  chave?: string;
  valor_bool?: number;
  valor_int?: number;
  valor_decimal?: number;
  valor_text?: string;
  valor_json?: Record<string, unknown>;
  valor_enum?: string;
  atualizado_em?: string;
}

export interface PainelConfigUpdate {
  chave?: string;
  valor_bool?: number;
  valor_int?: number;
  valor_decimal?: number;
  valor_text?: string;
  valor_json?: Record<string, unknown>;
  valor_enum?: string;
  atualizado_em?: string;
}
