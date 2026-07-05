export interface UsuarioProfissionalRegistro {
  id_usuario: number;
  conselho: string;
  numero_registro: string;
  uf_registro: string;
  especialidade_principal: string;
  id_entidade: number;
}

export interface UsuarioProfissionalRegistroCreate {
  conselho?: string;
  numero_registro?: string;
  uf_registro?: string;
}

export interface UsuarioProfissionalRegistroUpdate {
  conselho?: string;
  numero_registro?: string;
  uf_registro?: string;
}
