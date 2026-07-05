export interface AtendimentoExameFisico {
  id: number;
  id_unidade: number;
  id_ffa: number;
  id_usuario: number;
  id_sessao_usuario: number;
  cabeca_pescoco: string;
  torax: string;
  abdome: string;
  membros: string;
  neurologico: string;
  ip_origem: string;
  device_info: string;
  criado_em: string;
  id_entidade: number;
  id_atendimento: number;
}

export interface AtendimentoExameFisicoCreate {
  cabeca_pescoco?: string;
  torax?: string;
  abdome?: string;
  membros?: string;
  neurologico?: string;
  ip_origem?: string;
  device_info?: string;
  criado_em?: string;
}

export interface AtendimentoExameFisicoUpdate {
  cabeca_pescoco?: string;
  torax?: string;
  abdome?: string;
  membros?: string;
  neurologico?: string;
  ip_origem?: string;
  device_info?: string;
  criado_em?: string;
}
