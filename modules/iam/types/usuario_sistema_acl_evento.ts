export interface UsuarioSistemaAclEvento {
  id_acl_evento: number;
  id_usuario: number;
  id_sistema: number;
  id_perfil: number;
  evento: string;
  origem_dispositivo: string;
  origem_ip: string;
  criado_em: string;
  id_entidade: number;
}

export interface UsuarioSistemaAclEventoCreate {
  evento?: string;
  origem_dispositivo?: string;
  origem_ip?: string;
  criado_em?: string;
}

export interface UsuarioSistemaAclEventoUpdate {
  evento?: string;
  origem_dispositivo?: string;
  origem_ip?: string;
  criado_em?: string;
}
