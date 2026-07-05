export interface FilaPainelRuntime {
  id: number;
  id_unidade: number;
  id_local: number;
  id_senha: number;
  codigo_visual: string;
  status: string;
  prioridade: number;
  atualizado_em: string;
  id_entidade: number;
}

export interface FilaPainelRuntimeCreate {
  codigo_visual?: string;
  status?: string;
  atualizado_em?: string;
}

export interface FilaPainelRuntimeUpdate {
  codigo_visual?: string;
  status?: string;
  atualizado_em?: string;
}
