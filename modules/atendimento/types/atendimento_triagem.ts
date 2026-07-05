export interface AtendimentoTriagem {
  id: number;
  id_unidade: number;
  id_ffa: number;
  escala_dor: number;
  id_usuario: number;
  id_sessao_usuario: number;
  peso: number;
  altura: number;
  pressao_arterial: string;
  frequencia_cardiaca: number;
  temperatura: number;
  saturacao: number;
  ip_origem: string;
  device_info: string;
  criado_em: string;
  id_entidade: number;
  id_atendimento: number;
}

export interface AtendimentoTriagemCreate {
  escala_dor?: number;
  peso?: number;
  altura?: number;
  pressao_arterial?: string;
  frequencia_cardiaca?: number;
  temperatura?: number;
  saturacao?: number;
  ip_origem?: string;
  device_info?: string;
  criado_em?: string;
}

export interface AtendimentoTriagemUpdate {
  escala_dor?: number;
  peso?: number;
  altura?: number;
  pressao_arterial?: string;
  frequencia_cardiaca?: number;
  temperatura?: number;
  saturacao?: number;
  ip_origem?: string;
  device_info?: string;
  criado_em?: string;
}
