export interface Ffa {
  id_ffa: number;
  id_unidade: number;
  id_paciente: number;
  estado_clinico: string;
  contexto_fluxo: Record<string, unknown>;
  versao_ledger: number;
  id_sessao_usuario_abertura: number;
  criado_em: string;
  atualizado_em: string;
  fechado_em: string;
  id_entidade: number;
}

export interface FfaCreate {
  estado_clinico?: string;
  contexto_fluxo?: Record<string, unknown>;
  versao_ledger?: number;
  criado_em?: string;
  atualizado_em?: string;
  fechado_em?: string;
}

export interface FfaUpdate {
  estado_clinico?: string;
  contexto_fluxo?: Record<string, unknown>;
  versao_ledger?: number;
  criado_em?: string;
  atualizado_em?: string;
  fechado_em?: string;
}
