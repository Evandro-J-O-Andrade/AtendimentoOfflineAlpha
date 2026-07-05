export interface RuntimeContexto {
  id_runtime_contexto: number;
  id_sessao_usuario: number;
  id_unidade: number;
  id_local_operacional: number;
  id_paciente: number;
  id_ffa: number;
  contexto_clinico: string;
  estado_fluxo: string;
  iniciado_em: string;
  finalizado_em: string;
  ativo: number;
  id_entidade: number;
}

export interface RuntimeContextoCreate {
  contexto_clinico?: string;
  estado_fluxo?: string;
  iniciado_em?: string;
  finalizado_em?: string;
  ativo?: number;
}

export interface RuntimeContextoUpdate {
  contexto_clinico?: string;
  estado_fluxo?: string;
  iniciado_em?: string;
  finalizado_em?: string;
  ativo?: number;
}
