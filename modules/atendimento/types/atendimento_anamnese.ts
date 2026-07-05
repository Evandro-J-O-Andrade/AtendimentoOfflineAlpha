export interface AtendimentoAnamnese {
  id: number;
  id_unidade: number;
  id_ffa: number;
  id_usuario: number;
  id_sessao_usuario: number;
  queixa_principal: string;
  historico_doenca: string;
  antecedentes_pessoais: string;
  ip_origem: string;
  device_info: string;
  criado_em: string;
  id_entidade: number;
  id_atendimento: number;
}

export interface AtendimentoAnamneseCreate {
  queixa_principal?: string;
  historico_doenca?: string;
  antecedentes_pessoais?: string;
  ip_origem?: string;
  device_info?: string;
  criado_em?: string;
}

export interface AtendimentoAnamneseUpdate {
  queixa_principal?: string;
  historico_doenca?: string;
  antecedentes_pessoais?: string;
  ip_origem?: string;
  device_info?: string;
  criado_em?: string;
}
