export interface SessaoAtiva {
  id_usuario: number;
  token_sessao: string;
  ip_origem: string;
  ultimo_clique: string;
  id_entidade: number;
}

export interface SessaoAtivaCreate {
  token_sessao?: string;
  ip_origem?: string;
  ultimo_clique?: string;
}

export interface SessaoAtivaUpdate {
  token_sessao?: string;
  ip_origem?: string;
  ultimo_clique?: string;
}
