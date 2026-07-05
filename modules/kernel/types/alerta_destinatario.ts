export interface AlertaDestinatario {
  id_alerta_destinatario: number;
  id_alerta: number;
  tipo_destino: string;
  codigo_destino: string;
  id_destino: number;
  status: string;
  lido_em: string;
  id_sessao_usuario_acao: number;
  id_usuario_acao: number;
  atualizado_em: string;
  criado_em: string;
  id_entidade: number;
}

export interface AlertaDestinatarioCreate {
  tipo_destino?: string;
  codigo_destino?: string;
  status?: string;
  atualizado_em?: string;
  criado_em?: string;
}

export interface AlertaDestinatarioUpdate {
  tipo_destino?: string;
  codigo_destino?: string;
  status?: string;
  atualizado_em?: string;
  criado_em?: string;
}
