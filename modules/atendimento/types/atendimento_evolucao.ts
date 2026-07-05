export interface AtendimentoEvolucao {
  id: number;
  id_unidade: number;
  id_ffa: number;
  escala_dor: number;
  id_atendimento: number;
  id_usuario: number;
  id_sessao_usuario: number;
  tipo_profissional: string;
  texto_evolucao: string;
  hash_seguranca: string;
  ip_origem: string;
  device_info: string;
  criado_em: string;
  id_entidade: number;
}

export interface AtendimentoEvolucaoCreate {
  escala_dor?: number;
  tipo_profissional?: string;
  texto_evolucao?: string;
  hash_seguranca?: string;
  ip_origem?: string;
  device_info?: string;
  criado_em?: string;
}

export interface AtendimentoEvolucaoUpdate {
  escala_dor?: number;
  tipo_profissional?: string;
  texto_evolucao?: string;
  hash_seguranca?: string;
  ip_origem?: string;
  device_info?: string;
  criado_em?: string;
}
