export interface FluxoTransicaoMatriz {
  id_fluxo_transicao: number;
  dominio_fluxo: string;
  acao: string;
  estado_origem: string;
  estado_destino: string;
  id_perfil: number;
  tipo_local: string;
  prioridade: number;
  criado_em: string;
  id_entidade: number;
}

export interface FluxoTransicaoMatrizCreate {
  dominio_fluxo?: string;
  acao?: string;
  estado_origem?: string;
  estado_destino?: string;
  tipo_local?: string;
  criado_em?: string;
}

export interface FluxoTransicaoMatrizUpdate {
  dominio_fluxo?: string;
  acao?: string;
  estado_origem?: string;
  estado_destino?: string;
  tipo_local?: string;
  criado_em?: string;
}
