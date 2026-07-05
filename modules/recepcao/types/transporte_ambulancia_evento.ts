export interface TransporteAmbulanciaEvento {
  id_evento: number;
  id_transporte: number;
  evento: string;
  detalhe: string;
  id_usuario: number;
  id_sessao_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface TransporteAmbulanciaEventoCreate {
  evento?: string;
  detalhe?: string;
  criado_em?: string;
}

export interface TransporteAmbulanciaEventoUpdate {
  evento?: string;
  detalhe?: string;
  criado_em?: string;
}
