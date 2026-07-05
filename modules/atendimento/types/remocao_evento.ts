export interface RemocaoEvento {
  id_remocao_evento: number;
  id_remocao: number;
  evento: string;
  detalhe: string;
  id_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface RemocaoEventoCreate {
  evento?: string;
  detalhe?: string;
  criado_em?: string;
}

export interface RemocaoEventoUpdate {
  evento?: string;
  detalhe?: string;
  criado_em?: string;
}
