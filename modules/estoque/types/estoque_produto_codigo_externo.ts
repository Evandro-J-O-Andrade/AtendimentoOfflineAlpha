export interface EstoqueProdutoCodigoExterno {
  id_codigo_ext: number;
  id_produto: number;
  sistema_externo: string;
  codigo_externo: string;
  preferencial: number;
  criado_em: string;
  id_sessao_usuario: number;
  id_entidade: number;
}

export interface EstoqueProdutoCodigoExternoCreate {
  sistema_externo?: string;
  codigo_externo?: string;
  preferencial?: number;
  criado_em?: string;
}

export interface EstoqueProdutoCodigoExternoUpdate {
  sistema_externo?: string;
  codigo_externo?: string;
  preferencial?: number;
  criado_em?: string;
}
