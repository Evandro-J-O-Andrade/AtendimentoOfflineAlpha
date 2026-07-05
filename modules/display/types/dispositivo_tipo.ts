export interface DispositivoTipo {
  id_dispositivo_tipo: number;
  nome: string;
  descricao: string;
  permite_login_usuario: number;
  requer_autenticacao: number;
  usa_tts: number;
  exibe_painel: number;
  criado_em: string;
  id_entidade: number;
}

export interface DispositivoTipoCreate {
  nome?: string;
  descricao?: string;
  permite_login_usuario?: number;
  requer_autenticacao?: number;
  usa_tts?: number;
  exibe_painel?: number;
  criado_em?: string;
}

export interface DispositivoTipoUpdate {
  nome?: string;
  descricao?: string;
  permite_login_usuario?: number;
  requer_autenticacao?: number;
  usa_tts?: number;
  exibe_painel?: number;
  criado_em?: string;
}
