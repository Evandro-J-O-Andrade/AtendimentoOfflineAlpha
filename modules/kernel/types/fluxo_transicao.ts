export interface FluxoTransicao {
  id_fluxo_transicao: number;
  id_contrato: number;
  id_status_origem: number;
  id_status_destino: number;
  id_perfil_requerido: number;
  obriga_justificativa: number;
  bloqueia_retrocesso: number;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface FluxoTransicaoCreate {
  obriga_justificativa?: number;
  bloqueia_retrocesso?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface FluxoTransicaoUpdate {
  obriga_justificativa?: number;
  bloqueia_retrocesso?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
