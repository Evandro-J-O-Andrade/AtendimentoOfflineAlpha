export interface CodigoExternoMap {
  id_map: number;
  id_codigo: number;
  dominio: string;
  sistema_externo: string;
  codigo_externo: string;
  modo_cadastro: string;
  observacao: string;
  payload: Record<string, unknown>;
  id_sessao_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface CodigoExternoMapCreate {
  dominio?: string;
  sistema_externo?: string;
  codigo_externo?: string;
  modo_cadastro?: string;
  observacao?: string;
  payload?: Record<string, unknown>;
  criado_em?: string;
}

export interface CodigoExternoMapUpdate {
  dominio?: string;
  sistema_externo?: string;
  codigo_externo?: string;
  modo_cadastro?: string;
  observacao?: string;
  payload?: Record<string, unknown>;
  criado_em?: string;
}
