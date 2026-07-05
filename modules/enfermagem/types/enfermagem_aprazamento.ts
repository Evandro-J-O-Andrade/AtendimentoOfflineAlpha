export interface EnfermagemAprazamento {
  id: number;
  id_atendimento: number;
  medicamento: string;
  via_administracao: string;
  frequencia: string;
  horario_previsto: string;
  horario_executado: string;
  id_usuario_execucao: number;
  status: string;
  observacao: string;
  id_entidade: number;
}

export interface EnfermagemAprazamentoCreate {
  medicamento?: string;
  via_administracao?: string;
  frequencia?: string;
  horario_previsto?: string;
  horario_executado?: string;
  status?: string;
  observacao?: string;
}

export interface EnfermagemAprazamentoUpdate {
  medicamento?: string;
  via_administracao?: string;
  frequencia?: string;
  horario_previsto?: string;
  horario_executado?: string;
  status?: string;
  observacao?: string;
}
