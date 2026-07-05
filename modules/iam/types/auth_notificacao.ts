export interface AuthNotificacao {
  id_notificacao: number;
  id_usuario: number;
  tipo_notificacao: string;
  titulo: string;
  mensagem: string;
  lido: number;
  lido_em: string;
  dados_extras: Record<string, unknown>;
  criado_em: string;
  id_entidade: number;
}

export interface AuthNotificacaoCreate {
  tipo_notificacao?: string;
  titulo?: string;
  mensagem?: string;
  dados_extras?: Record<string, unknown>;
  criado_em?: string;
}

export interface AuthNotificacaoUpdate {
  tipo_notificacao?: string;
  titulo?: string;
  mensagem?: string;
  dados_extras?: Record<string, unknown>;
  criado_em?: string;
}
