export interface UsuarioSetor {
  id_usuario_setor: number;
  id_usuario: number;
  id_setor: number;
  pode_operar: number;
  criado_em: string;
  id_entidade: number;
}

export interface UsuarioSetorCreate {
  pode_operar?: number;
  criado_em?: string;
}

export interface UsuarioSetorUpdate {
  pode_operar?: number;
  criado_em?: string;
}
