export interface AuthTentativaLogin {
  id_tentativa: number;
  login: string;
  ip_origem: string;
  user_agent: string;
  sucesso: number;
  motivo_falha: string;
  criado_em: string;
  id_entidade: number;
}

export interface AuthTentativaLoginCreate {
  login?: string;
  ip_origem?: string;
  user_agent?: string;
  sucesso?: number;
  motivo_falha?: string;
  criado_em?: string;
}

export interface AuthTentativaLoginUpdate {
  login?: string;
  ip_origem?: string;
  user_agent?: string;
  sucesso?: number;
  motivo_falha?: string;
  criado_em?: string;
}
