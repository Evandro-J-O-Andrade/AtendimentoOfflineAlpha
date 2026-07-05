export interface AuthBloqueio {
  id_bloqueio: number;
  id_usuario: number;
  tipo_bloqueio: string;
  motivo: string;
  bloqueado_por: number;
  expira_em: string;
  ativo: number;
  desbloqueado_por: number;
  desbloqueado_em: string;
  criado_em: string;
  id_entidade: number;
}

export interface AuthBloqueioCreate {
  tipo_bloqueio?: string;
  motivo?: string;
  bloqueado_por?: number;
  expira_em?: string;
  ativo?: number;
  desbloqueado_por?: number;
  desbloqueado_em?: string;
  criado_em?: string;
}

export interface AuthBloqueioUpdate {
  tipo_bloqueio?: string;
  motivo?: string;
  bloqueado_por?: number;
  expira_em?: string;
  ativo?: number;
  desbloqueado_por?: number;
  desbloqueado_em?: string;
  criado_em?: string;
}
