export interface PainelMensagem {
  id_mensagem: number;
  id_painel: number;
  tipo: string;
  titulo: string;
  texto: string;
  prioridade: number;
  expira_em: string;
  ativo: number;
  criado_em: string;
  criado_por: number;
  id_sessao_usuario: number;
  id_entidade: number;
}

export interface PainelMensagemCreate {
  tipo?: string;
  titulo?: string;
  texto?: string;
  expira_em?: string;
  ativo?: number;
  criado_em?: string;
  criado_por?: number;
}

export interface PainelMensagemUpdate {
  tipo?: string;
  titulo?: string;
  texto?: string;
  expira_em?: string;
  ativo?: number;
  criado_em?: string;
  criado_por?: number;
}
