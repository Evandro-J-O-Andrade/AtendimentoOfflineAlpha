export interface FaturamentoConvenio {
  id: number;
  id_atendimento: number;
  id_convenio: number;
  numero_guia: string;
  valor_total: number;
  status_guia: string;
  data_emissao: string;
  id_entidade: number;
}

export interface FaturamentoConvenioCreate {
  numero_guia?: string;
  valor_total?: number;
  status_guia?: string;
  data_emissao?: string;
}

export interface FaturamentoConvenioUpdate {
  numero_guia?: string;
  valor_total?: number;
  status_guia?: string;
  data_emissao?: string;
}
