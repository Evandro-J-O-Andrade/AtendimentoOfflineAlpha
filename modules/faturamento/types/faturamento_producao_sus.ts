export interface FaturamentoProducaoSus {
  id: number;
  id_atendimento: number;
  id_sigtap: number;
  cbo_profissional: string;
  cns_paciente: string;
  data_producao: string;
  status_remessa: string;
  id_entidade: number;
}

export interface FaturamentoProducaoSusCreate {
  cbo_profissional?: string;
  cns_paciente?: string;
  data_producao?: string;
  status_remessa?: string;
}

export interface FaturamentoProducaoSusUpdate {
  cbo_profissional?: string;
  cns_paciente?: string;
  data_producao?: string;
  status_remessa?: string;
}
