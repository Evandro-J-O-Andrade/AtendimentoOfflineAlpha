export interface AtendimentoDiagnostico {
  id_diagnostico: number;
  id_atendimento: number;
  codigo_cid: string;
  descricao: string;
  principal: number;
  criado_em: string;
  id_entidade: number;
}

export interface AtendimentoDiagnosticoCreate {
  descricao?: string;
  principal?: number;
  criado_em?: string;
}

export interface AtendimentoDiagnosticoUpdate {
  descricao?: string;
  principal?: number;
  criado_em?: string;
}
