export interface FarmacoAuditoriaBloqueio {
  id: number;
  id_farmaco: number;
  id_lote: number;
  id_cidade: number;
  quantidade: number;
  id_ffa: number;
  usuario: number;
  motivo: string;
  criado_em: string;
  id_entidade: number;
}

export interface FarmacoAuditoriaBloqueioCreate {
  usuario?: number;
  motivo?: string;
  criado_em?: string;
}

export interface FarmacoAuditoriaBloqueioUpdate {
  usuario?: number;
  motivo?: string;
  criado_em?: string;
}
