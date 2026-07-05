export interface SincronizacaoFederadaEvento {
  id_sync: number;
  id_ffa: number;
  evento: string;
  estado_origem: string;
  estado_destino: string;
  id_sessao_usuario: number;
  sincronizado: number;
  versao_logica: number;
  criado_em: string;
  id_entidade: number;
}

export interface SincronizacaoFederadaEventoCreate {
  evento?: string;
  estado_origem?: string;
  estado_destino?: string;
  sincronizado?: number;
  versao_logica?: number;
  criado_em?: string;
}

export interface SincronizacaoFederadaEventoUpdate {
  evento?: string;
  estado_origem?: string;
  estado_destino?: string;
  sincronizado?: number;
  versao_logica?: number;
  criado_em?: string;
}
