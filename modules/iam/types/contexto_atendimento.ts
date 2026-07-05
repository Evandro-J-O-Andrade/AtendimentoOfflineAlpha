export interface ContextoAtendimento {
  id_contexto: number;
  id_sistema: number;
  nome: string;
  tipo: string;
  usa_fila: number;
  usa_chamada: number;
  ativo: number;
  id_entidade: number;
}

export interface ContextoAtendimentoCreate {
  nome?: string;
  tipo?: string;
  usa_fila?: number;
  usa_chamada?: number;
  ativo?: number;
}

export interface ContextoAtendimentoUpdate {
  nome?: string;
  tipo?: string;
  usa_fila?: number;
  usa_chamada?: number;
  ativo?: number;
}
