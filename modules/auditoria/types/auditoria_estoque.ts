export interface AuditoriaEstoque {
  id_log: number;
  id_produto: number;
  id_local: number;
  acao: string;
  quantidade: number;
  id_usuario: number;
  data_hora: string;
  id_entidade: number;
}

export interface AuditoriaEstoqueCreate {
  acao?: string;
  data_hora?: string;
}

export interface AuditoriaEstoqueUpdate {
  acao?: string;
  data_hora?: string;
}
