export interface UsuarioUnidade {
  id_usuario_unidade: number;
  id_usuario: number;
  id_unidade: number;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface UsuarioUnidadeCreate {
  ativo?: number;
  criado_em?: string;
}

export interface UsuarioUnidadeUpdate {
  ativo?: number;
  criado_em?: string;
}
