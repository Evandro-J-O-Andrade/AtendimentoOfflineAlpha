export interface FilaSenha {
  id: number;
  id_senha: number;
  status: string;
  criado_em: string;
  id_entidade: number;
}

export interface FilaSenhaCreate {
  status?: string;
  criado_em?: string;
}

export interface FilaSenhaUpdate {
  status?: string;
  criado_em?: string;
}
