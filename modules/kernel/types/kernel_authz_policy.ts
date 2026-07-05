export interface KernelAuthzPolicy {
  id_policy: number;
  id_tenant: number;
  id_perfil: number;
  id_usuario: number;
  contexto: string;
  recurso: string;
  estado_origem: string;
  estado_destino: string;
  id_dispositivo: number;
  id_dispositivo_norm: number;
  decision_fingerprint: string;
  criado_em: string;
  id_entidade: number;
}

export interface KernelAuthzPolicyCreate {
  contexto?: string;
  recurso?: string;
  estado_origem?: string;
  estado_destino?: string;
  decision_fingerprint?: string;
  criado_em?: string;
}

export interface KernelAuthzPolicyUpdate {
  contexto?: string;
  recurso?: string;
  estado_origem?: string;
  estado_destino?: string;
  decision_fingerprint?: string;
  criado_em?: string;
}
