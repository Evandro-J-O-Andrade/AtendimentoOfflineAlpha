export interface CodigoUniversal {
  id_codigo: number;
  dominio: string;
  prefixo_5: string;
  sequencia: number;
  codigo_interno: string;
  barcode: string;
  origem_interno: string;
  id_ffa: number;
  id_senha: number;
  id_paciente: number;
  id_produto: number;
  id_usuario: number;
  id_cliente: number;
  status: string;
  payload: Record<string, unknown>;
  id_sessao_usuario: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface CodigoUniversalCreate {
  dominio?: string;
  prefixo_5?: string;
  sequencia?: number;
  codigo_interno?: string;
  barcode?: string;
  origem_interno?: string;
  status?: string;
  payload?: Record<string, unknown>;
  criado_em?: string;
  atualizado_em?: string;
}

export interface CodigoUniversalUpdate {
  dominio?: string;
  prefixo_5?: string;
  sequencia?: number;
  codigo_interno?: string;
  barcode?: string;
  origem_interno?: string;
  status?: string;
  payload?: Record<string, unknown>;
  criado_em?: string;
  atualizado_em?: string;
}
