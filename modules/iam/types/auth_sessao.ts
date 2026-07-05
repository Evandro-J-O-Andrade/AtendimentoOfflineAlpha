export interface AuthSessao {
  id_sessao: number;
  id_usuario: number;
  id_unidade: number;
  id_local_operacional: number;
  id_perfil: number;
  token_sessao: string;
  ip_origem: string;
  user_agent: string;
  dispositivo: string;
  geo_localizacao: string;
  ativo: number;
  expira_em: string;
  ultima_atividade: string;
  criado_em: string;
  id_entidade: number;
}

export interface AuthSessaoCreate {
  token_sessao?: string;
  ip_origem?: string;
  user_agent?: string;
  dispositivo?: string;
  geo_localizacao?: string;
  ativo?: number;
  expira_em?: string;
  criado_em?: string;
}

export interface AuthSessaoUpdate {
  token_sessao?: string;
  ip_origem?: string;
  user_agent?: string;
  dispositivo?: string;
  geo_localizacao?: string;
  ativo?: number;
  expira_em?: string;
  criado_em?: string;
}
