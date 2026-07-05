export interface FinanceiroRepasseMedico {
  id: number;
  id_usuario_medico: number;
  id_atendimento: number;
  valor_procedimento: number;
  percentual_repasse: number;
  valor_final_medico: number;
  status_pagamento: string;
  data_competencia: string;
  id_entidade: number;
}

export interface FinanceiroRepasseMedicoCreate {
  valor_procedimento?: number;
  percentual_repasse?: number;
  valor_final_medico?: number;
  status_pagamento?: string;
  data_competencia?: string;
}

export interface FinanceiroRepasseMedicoUpdate {
  valor_procedimento?: number;
  percentual_repasse?: number;
  valor_final_medico?: number;
  status_pagamento?: string;
  data_competencia?: string;
}
