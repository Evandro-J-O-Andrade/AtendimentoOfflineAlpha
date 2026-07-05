export interface FfaDiagnostico {
  id_diagnostico: number;
  id_ffa: number;
  id_sessao_usuario: number;
  id_usuario: number;
  cid10: string;
  descricao: string;
  tipo: string;
  observacao: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface FfaDiagnosticoCreate {
  descricao?: string;
  tipo?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface FfaDiagnosticoUpdate {
  descricao?: string;
  tipo?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}
