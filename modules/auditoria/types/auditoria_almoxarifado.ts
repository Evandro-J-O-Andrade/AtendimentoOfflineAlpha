export interface AuditoriaAlmoxarifado {
  id_log: number;
  id_produto: number;
  id_local: number;
  acao: string;
  quantidade: number;
  id_usuario: number;
  data_hora: string;
  id_entidade: number;
}

export interface AuditoriaAlmoxarifadoCreate {
  acao?: string;
  data_hora?: string;
}

export interface AuditoriaAlmoxarifadoUpdate {
  acao?: string;
  data_hora?: string;
}
