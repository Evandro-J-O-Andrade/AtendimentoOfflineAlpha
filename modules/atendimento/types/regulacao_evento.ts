export interface RegulacaoEvento {
  id_regulacao: number;
  id_unidade: number;
  id_ffa: number;
  status: string;
  destino_unidade: number;
  tipo_regulacao: string;
  observacao: string;
  criado_em: string;
  id_entidade: number;
}

export interface RegulacaoEventoCreate {
  status?: string;
  tipo_regulacao?: string;
  observacao?: string;
  criado_em?: string;
}

export interface RegulacaoEventoUpdate {
  status?: string;
  tipo_regulacao?: string;
  observacao?: string;
  criado_em?: string;
}
