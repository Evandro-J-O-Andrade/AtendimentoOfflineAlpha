export interface UsuarioSala {
  id_usuario_sala: number;
  id_usuario: number;
  id_sala: number;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface UsuarioSalaCreate {
  ativo?: number;
  criado_em?: string;
}

export interface UsuarioSalaUpdate {
  ativo?: number;
  criado_em?: string;
}
