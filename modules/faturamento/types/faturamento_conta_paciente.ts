export interface FaturamentoContaPaciente {
  id: number;
  id_atendimento: number;
  id_convenio: number;
  status_conta: string;
  valor_total: number;
  numero_guia_principal: string;
  data_fechamento: string;
  id_entidade: number;
}

export interface FaturamentoContaPacienteCreate {
  status_conta?: string;
  valor_total?: number;
  numero_guia_principal?: string;
  data_fechamento?: string;
}

export interface FaturamentoContaPacienteUpdate {
  status_conta?: string;
  valor_total?: number;
  numero_guia_principal?: string;
  data_fechamento?: string;
}
