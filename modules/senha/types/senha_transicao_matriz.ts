export interface SenhaTransicaoMatriz {
  id_senha_transicao: number;
  id_status_origem: number;
  id_status_destino: number;
  permite_retorno: number;
  ativo: number;
  id_entidade: number;
}

export interface SenhaTransicaoMatrizCreate {
  permite_retorno?: number;
  ativo?: number;
}

export interface SenhaTransicaoMatrizUpdate {
  permite_retorno?: number;
  ativo?: number;
}
