export interface FfaItem {
  id_ffa_item: number;
  id_ffa: number;
  id_paciente: number;
  id_produto: number;
  dose_prescrita: number;
  unidade_prescrita: string;
  quantidade_autorizada: number;
  quantidade_dispensada: number;
  status: string;
  id_unidade: number;
  id_sessao_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface FfaItemCreate {
  dose_prescrita?: number;
  status?: string;
  criado_em?: string;
}

export interface FfaItemUpdate {
  dose_prescrita?: number;
  status?: string;
  criado_em?: string;
}
