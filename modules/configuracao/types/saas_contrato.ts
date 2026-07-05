export interface SaasContrato {
  id_contrato: number;
  id_entidade: number;
  data_inicio: string;
  data_fim: string;
  status: string;
  atualizado_em: string;
}

export interface SaasContratoCreate {
  data_inicio?: string;
  data_fim?: string;
  status?: string;
  atualizado_em?: string;
}

export interface SaasContratoUpdate {
  data_inicio?: string;
  data_fim?: string;
  status?: string;
  atualizado_em?: string;
}
