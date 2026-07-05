export interface AtendimentoPrescricao {
  id: number;
  id_unidade: number;
  id_ffa: number;
  id_usuario: number;
  id_sessao_usuario: number;
  medicamento: string;
  posologia: string;
  via_administracao: string;
  ip_origem: string;
  device_info: string;
  criado_em: string;
  id_entidade: number;
  id_atendimento: number;
}

export interface AtendimentoPrescricaoCreate {
  medicamento?: string;
  posologia?: string;
  via_administracao?: string;
  ip_origem?: string;
  device_info?: string;
  criado_em?: string;
}

export interface AtendimentoPrescricaoUpdate {
  medicamento?: string;
  posologia?: string;
  via_administracao?: string;
  ip_origem?: string;
  device_info?: string;
  criado_em?: string;
}
