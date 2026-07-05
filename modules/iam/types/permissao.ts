export interface Permissao {
  id_permissao: number;
  codigo: string;
  nome: string;
  descricao: string;
  dominio: string;
  nome_procedure: string;
  acao_frontend: string;
  metadata: Record<string, unknown>;
  criado_em: string;
  grupo_menu: string;
  icone: string;
  ordem_menu: number;
  id_entidade: number;
}

export interface PermissaoCreate {
  codigo?: string;
  nome?: string;
  descricao?: string;
  dominio?: string;
  nome_procedure?: string;
  acao_frontend?: string;
  metadata?: Record<string, unknown>;
  criado_em?: string;
  grupo_menu?: string;
  icone?: string;
  ordem_menu?: number;
}

export interface PermissaoUpdate {
  codigo?: string;
  nome?: string;
  descricao?: string;
  dominio?: string;
  nome_procedure?: string;
  acao_frontend?: string;
  metadata?: Record<string, unknown>;
  criado_em?: string;
  grupo_menu?: string;
  icone?: string;
  ordem_menu?: number;
}
