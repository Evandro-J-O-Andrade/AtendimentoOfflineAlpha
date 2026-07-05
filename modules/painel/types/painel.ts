export interface Painel {
  id_painel: number;
  codigo: string;
  tipo: string;
  nome: string;
  descricao: string;
  id_unidade: number;
  id_local_operacional: number;
  tts_habilitado: number;
  piscada_seg: number;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  intervalo_segundos: number;
  id_sistema: number;
  id_entidade: number;
}

export interface PainelCreate {
  codigo?: string;
  tipo?: string;
  nome?: string;
  descricao?: string;
  tts_habilitado?: number;
  piscada_seg?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
  intervalo_segundos?: number;
}

export interface PainelUpdate {
  codigo?: string;
  tipo?: string;
  nome?: string;
  descricao?: string;
  tts_habilitado?: number;
  piscada_seg?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
  intervalo_segundos?: number;
}
