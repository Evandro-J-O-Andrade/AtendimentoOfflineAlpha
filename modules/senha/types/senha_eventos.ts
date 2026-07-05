export interface SenhaEventos {
  id_evento: number;
  id_sessao_usuario: number;
  id_senha: number;
  tipo_evento: string;
  detalhe: string;
  status_de: string;
  status_para: string;
  criado_em: string;
  id_entidade: number;
}

export interface SenhaEventosCreate {
  tipo_evento?: string;
  detalhe?: string;
  status_de?: string;
  status_para?: string;
  criado_em?: string;
}

export interface SenhaEventosUpdate {
  tipo_evento?: string;
  detalhe?: string;
  status_de?: string;
  status_para?: string;
  criado_em?: string;
}
