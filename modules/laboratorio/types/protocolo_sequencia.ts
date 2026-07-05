export interface ProtocoloSequencia {
  chave: string;
  ultimo_numero: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface ProtocoloSequenciaCreate {
  chave?: string;
  ultimo_numero?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface ProtocoloSequenciaUpdate {
  chave?: string;
  ultimo_numero?: number;
  criado_em?: string;
  atualizado_em?: string;
}
