export interface FarmConvenioAutorizacao {
  id_autorizacao: number;
  id_dispensacao: number;
  numero_autorizacao: string;
  status: string;
  criado_em: string;
  id_entidade: number;
}

export interface FarmConvenioAutorizacaoCreate {
  numero_autorizacao?: string;
  status?: string;
  criado_em?: string;
}

export interface FarmConvenioAutorizacaoUpdate {
  numero_autorizacao?: string;
  status?: string;
  criado_em?: string;
}
