export interface UsuarioAlocacao {
  id_alocacao: number;
  id_usuario: number;
  id_sala: number;
  id_especialidade: number;
  inicio: string;
  fim: string;
  id_entidade: number;
}

export interface UsuarioAlocacaoCreate {
  inicio?: string;
  fim?: string;
}

export interface UsuarioAlocacaoUpdate {
  inicio?: string;
  fim?: string;
}
