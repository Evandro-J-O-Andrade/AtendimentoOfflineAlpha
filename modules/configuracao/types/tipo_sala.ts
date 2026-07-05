export interface TipoSala {
  id_tipo_sala: number;
  codigo: string;
  nome: string;
  gera_chamada_painel: number;
  usa_tts: number;
  tipo_fila: string;
  id_entidade: number;
}

export interface TipoSalaCreate {
  codigo?: string;
  nome?: string;
  gera_chamada_painel?: number;
  usa_tts?: number;
  tipo_fila?: string;
}

export interface TipoSalaUpdate {
  codigo?: string;
  nome?: string;
  gera_chamada_painel?: number;
  usa_tts?: number;
  tipo_fila?: string;
}
