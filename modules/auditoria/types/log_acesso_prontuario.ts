export interface LogAcessoProntuario {
  id: number;
  id_usuario: number;
  id_atendimento: number;
  ip_maquina: string;
  data_hora_acesso: string;
  modulo_acessado: string;
  id_entidade: number;
}

export interface LogAcessoProntuarioCreate {
  ip_maquina?: string;
  data_hora_acesso?: string;
  modulo_acessado?: string;
}

export interface LogAcessoProntuarioUpdate {
  ip_maquina?: string;
  data_hora_acesso?: string;
  modulo_acessado?: string;
}
