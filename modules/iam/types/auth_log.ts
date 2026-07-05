export interface AuthLog {
  id_log: number;
  id_usuario: number;
  tipo_evento: string;
  ip_origem: string;
  user_agent: string;
  dispositivo: string;
  localizacao: string;
  mensagem: string;
  dados_extras: Record<string, unknown>;
  criado_em: string;
  id_entidade: number;
}

export interface AuthLogCreate {
  tipo_evento?: string;
  ip_origem?: string;
  user_agent?: string;
  dispositivo?: string;
  localizacao?: string;
  mensagem?: string;
  dados_extras?: Record<string, unknown>;
  criado_em?: string;
}

export interface AuthLogUpdate {
  tipo_evento?: string;
  ip_origem?: string;
  user_agent?: string;
  dispositivo?: string;
  localizacao?: string;
  mensagem?: string;
  dados_extras?: Record<string, unknown>;
  criado_em?: string;
}
