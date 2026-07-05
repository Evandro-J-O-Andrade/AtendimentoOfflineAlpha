export interface Internacao {
  id_internacao: number;
  id_ffa: number;
  id_leito: number;
  tipo: string;
  motivo: string;
  status: string;
  data_entrada: string;
  id_usuario_entrada: number;
  data_saida: string;
  id_usuario_saida: number;
  motivo_alta: string;
  criado_em: string;
  encerrado_em: string;
  precaucao: string;
  previsao_alta: string;
  id_medico_responsavel: number;
  id_sessao_usuario_entrada: number;
  id_sessao_usuario_saida: number;
  id_local_operacional_entrada: number;
  id_local_operacional_saida: number;
  id_unidade_entrada: number;
  id_unidade_saida: number;
  id_atendimento: number;
  id_entidade: number;
}

export interface InternacaoCreate {
  tipo?: string;
  motivo?: string;
  status?: string;
  data_entrada?: string;
  motivo_alta?: string;
  criado_em?: string;
  encerrado_em?: string;
  precaucao?: string;
  previsao_alta?: string;
}

export interface InternacaoUpdate {
  tipo?: string;
  motivo?: string;
  status?: string;
  data_entrada?: string;
  motivo_alta?: string;
  criado_em?: string;
  encerrado_em?: string;
  precaucao?: string;
  previsao_alta?: string;
}
