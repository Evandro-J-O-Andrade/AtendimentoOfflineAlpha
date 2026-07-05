export interface AtendimentoRecepcao {
  id_atendimento: number;
  tipo_atendimento: string;
  chegada: string;
  prioridade: string;
  motivo_procura: string;
  destino_inicial: string;
  id_recepcionista: number;
  data_hora: string;
  id_entidade: number;
}

export interface AtendimentoRecepcaoCreate {
  tipo_atendimento?: string;
  chegada?: string;
  motivo_procura?: string;
  destino_inicial?: string;
  data_hora?: string;
}

export interface AtendimentoRecepcaoUpdate {
  tipo_atendimento?: string;
  chegada?: string;
  motivo_procura?: string;
  destino_inicial?: string;
  data_hora?: string;
}
