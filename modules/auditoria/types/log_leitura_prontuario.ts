export interface LogLeituraProntuario {
  id: number;
  id_atendimento: number;
  id_usuario: number;
  data_hora: string;
  motivo_acesso: string;
  id_entidade: number;
}

export interface LogLeituraProntuarioCreate {
  data_hora?: string;
  motivo_acesso?: string;
}

export interface LogLeituraProntuarioUpdate {
  data_hora?: string;
  motivo_acesso?: string;
}
