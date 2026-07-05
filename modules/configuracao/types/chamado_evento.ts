export interface ChamadoEvento {
  id_chamado_evento: number;
  id_chamado: number;
  evento: string;
  detalhe: string;
  id_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface ChamadoEventoCreate {
  evento?: string;
  detalhe?: string;
  criado_em?: string;
}

export interface ChamadoEventoUpdate {
  evento?: string;
  detalhe?: string;
  criado_em?: string;
}
