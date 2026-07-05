export interface FfaEvolucao {
  id_evolucao: number;
  id_ffa: number;
  id_sessao_usuario: number;
  id_usuario: number;
  criado_em: string;
  tipo: string;
  modulo: string;
  id_local_operacional: number;
  ip: string;
  user_agent: string;
  hash_integridade: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface FfaEvolucaoCreate {
  criado_em?: string;
  tipo?: string;
  modulo?: string;
  ip?: string;
  user_agent?: string;
  atualizado_em?: string;
}

export interface FfaEvolucaoUpdate {
  criado_em?: string;
  tipo?: string;
  modulo?: string;
  ip?: string;
  user_agent?: string;
  atualizado_em?: string;
}
