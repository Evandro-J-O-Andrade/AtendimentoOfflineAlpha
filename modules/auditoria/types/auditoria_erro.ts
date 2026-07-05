export interface AuditoriaErro {
  id_auditoria_erro: number;
  id_sessao_usuario: number;
  rotina: string;
  sqlstate: string;
  errno: number;
  mensagem: string;
  contexto: string;
  criado_em: string;
  id_entidade: number;
}

export interface AuditoriaErroCreate {
  rotina?: string;
  sqlstate?: string;
  errno?: number;
  mensagem?: string;
  contexto?: string;
  criado_em?: string;
}

export interface AuditoriaErroUpdate {
  rotina?: string;
  sqlstate?: string;
  errno?: number;
  mensagem?: string;
  contexto?: string;
  criado_em?: string;
}
