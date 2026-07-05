export interface RemocaoLogistica {
  id_remocao: number;
  id_ffa: number;
  id_atendimento: number;
  motorista_nome: string;
  tecnico_nome: string;
  destino: string;
  status: string;
  data_saida: string;
  id_entidade: number;
}

export interface RemocaoLogisticaCreate {
  motorista_nome?: string;
  tecnico_nome?: string;
  destino?: string;
  status?: string;
}

export interface RemocaoLogisticaUpdate {
  motorista_nome?: string;
  tecnico_nome?: string;
  destino?: string;
  status?: string;
}
