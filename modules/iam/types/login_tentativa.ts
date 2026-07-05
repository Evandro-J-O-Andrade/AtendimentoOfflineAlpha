export interface LoginTentativa {
  id_tentativa: number;
  id_usuario: number;
  login: string;
  ip_origem: string;
  dispositivo_origem: string;
  tentativa_faixa_horaria: string;
  sucesso: number;
  metadata: Record<string, unknown>;
  criado_em: string;
  id_entidade: number;
}

export interface LoginTentativaCreate {
  login?: string;
  ip_origem?: string;
  dispositivo_origem?: string;
  tentativa_faixa_horaria?: string;
  sucesso?: number;
  metadata?: Record<string, unknown>;
  criado_em?: string;
}

export interface LoginTentativaUpdate {
  login?: string;
  ip_origem?: string;
  dispositivo_origem?: string;
  tentativa_faixa_horaria?: string;
  sucesso?: number;
  metadata?: Record<string, unknown>;
  criado_em?: string;
}
