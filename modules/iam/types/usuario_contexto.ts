export interface UsuarioContexto {
  id_usuario_contexto: number;
  id_usuario: number;
  id_sistema: number;
  id_unidade: number;
  id_local_operacional: number;
  id_perfil: number;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface UsuarioContextoCreate {
  ativo?: number;
  criado_em?: string;
}

export interface UsuarioContextoUpdate {
  ativo?: number;
  criado_em?: string;
}
