export interface SenhaSequencia {
  id_sistema: number;
  id_unidade: number;
  data_ref: string;
  prefixo: string;
  ultimo_numero: number;
  id_entidade: number;
}

export interface SenhaSequenciaCreate {
  data_ref?: string;
  prefixo?: string;
  ultimo_numero?: number;
}

export interface SenhaSequenciaUpdate {
  data_ref?: string;
  prefixo?: string;
  ultimo_numero?: number;
}
