export interface SessaoUsuario {
  id_sessao_usuario: number;
  uuid_sessao: string;
  id_usuario: number;
  id_perfil: number;
  id_sistema: number;
  id_unidade: number;
  id_local: number;
  id_sala: number;
  id_dispositivo: number;
  token_jwt: string;
  refresh_token: string;
  ip_origem: string;
  user_agent: string;
  iniciado_em: string;
  expira_em: string;
  contexto_definido_em: string;
  finalizado_em: string;
  motivo_finalizacao: string;
  ativo: number;
  revogado: number;
  criado_em: string;
  atualizado_em: string;
  ip_country: string;
  ip_city: string;
  token_hash: string;
  refresh_hash: string;
  device_fingerprint: string;
  id_entidade: number;
}

export interface SessaoUsuarioCreate {
  token_jwt?: string;
  refresh_token?: string;
  ip_origem?: string;
  user_agent?: string;
  iniciado_em?: string;
  expira_em?: string;
  finalizado_em?: string;
  motivo_finalizacao?: string;
  ativo?: number;
  revogado?: number;
  criado_em?: string;
  atualizado_em?: string;
  ip_country?: string;
  ip_city?: string;
  token_hash?: string;
  refresh_hash?: string;
  device_fingerprint?: string;
}

export interface SessaoUsuarioUpdate {
  token_jwt?: string;
  refresh_token?: string;
  ip_origem?: string;
  user_agent?: string;
  iniciado_em?: string;
  expira_em?: string;
  finalizado_em?: string;
  motivo_finalizacao?: string;
  ativo?: number;
  revogado?: number;
  criado_em?: string;
  atualizado_em?: string;
  ip_country?: string;
  ip_city?: string;
  token_hash?: string;
  refresh_hash?: string;
  device_fingerprint?: string;
}
