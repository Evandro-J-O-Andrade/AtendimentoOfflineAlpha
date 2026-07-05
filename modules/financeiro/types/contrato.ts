export interface Contrato {
  id_contrato: number;
  nome: string;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface ContratoCreate {
  nome?: string;
  ativo?: number;
  criado_em?: string;
}

export interface ContratoUpdate {
  nome?: string;
  ativo?: number;
  criado_em?: string;
}
