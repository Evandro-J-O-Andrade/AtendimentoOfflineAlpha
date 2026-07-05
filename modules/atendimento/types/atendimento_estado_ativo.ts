export interface AtendimentoEstadoAtivo {
  id_ffa: number;
  id_local_atual: number;
  id_leito: number;
  tipo_estado: string;
  id_sessao_ultimo_movimento: number;
  id_atendimento: number;
  id_entidade: number;
}

export interface AtendimentoEstadoAtivoCreate {
  tipo_estado?: string;
}

export interface AtendimentoEstadoAtivoUpdate {
  tipo_estado?: string;
}
