export interface PainelMonitoramentoEspecialidade {
  id_cfg: number;
  id_painel: number;
  id_especialidade: number;
  id_local_operacional: number;
  ordem: number;
  ativo: number;
  id_entidade: number;
}

export interface PainelMonitoramentoEspecialidadeCreate {
  ordem?: number;
  ativo?: number;
}

export interface PainelMonitoramentoEspecialidadeUpdate {
  ordem?: number;
  ativo?: number;
}
