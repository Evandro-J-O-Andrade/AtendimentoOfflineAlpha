export interface AtendimentoTransicaoLedger {
  id: number;
  uuid_transacao: string;
  estado_origem: string;
  estado_destino: string;
  fingerprint_hash: string;
  criado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface AtendimentoTransicaoLedgerCreate {
  estado_origem?: string;
  estado_destino?: string;
  fingerprint_hash?: string;
  criado_em?: string;
}

export interface AtendimentoTransicaoLedgerUpdate {
  estado_origem?: string;
  estado_destino?: string;
  fingerprint_hash?: string;
  criado_em?: string;
}
