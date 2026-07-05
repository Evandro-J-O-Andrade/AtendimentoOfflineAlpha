export interface RegAuditoriaAcessoSensivel {
  id_acesso: number;
  ocorrido_em: string;
  id_sessao_usuario: number;
  id_usuario: number;
  entidade_ref: string;
  id_ref: number;
  acao: string;
  motivo: string;
  ip_origem: string;
  user_agent: string;
  id_entidade: number;
}

export interface RegAuditoriaAcessoSensivelCreate {
  acao?: string;
  motivo?: string;
  ip_origem?: string;
  user_agent?: string;
}

export interface RegAuditoriaAcessoSensivelUpdate {
  acao?: string;
  motivo?: string;
  ip_origem?: string;
  user_agent?: string;
}
