export interface AlertaRegra {
  id_alerta_regra: number;
  codigo: string;
  id_sistema_destino: number;
  id_perfil_destino: number;
  id_unidade: number;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface AlertaRegraCreate {
  codigo?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface AlertaRegraUpdate {
  codigo?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
