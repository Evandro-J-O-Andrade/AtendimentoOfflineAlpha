export interface GuardiaoAclRuntime {
  id_guardiao_acl: number;
  id_usuario: number;
  id_sistema: number;
  contexto: string;
  recurso: string;
  criado_em: string;
  id_entidade: number;
}

export interface GuardiaoAclRuntimeCreate {
  contexto?: string;
  recurso?: string;
  criado_em?: string;
}

export interface GuardiaoAclRuntimeUpdate {
  contexto?: string;
  recurso?: string;
  criado_em?: string;
}
