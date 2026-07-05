export interface AdministracaoMedicacaoOrdem {
  id_administracao: number;
  id_item: number;
  quantidade: number;
  realizado_em: string;
  id_usuario: number;
  id_sessao_usuario: number;
  id_local_operacional: number;
  id_aprazamento: number;
  observacao: string;
  status: string;
  id_entidade: number;
}

export interface AdministracaoMedicacaoOrdemCreate {
  realizado_em?: string;
  observacao?: string;
  status?: string;
}

export interface AdministracaoMedicacaoOrdemUpdate {
  realizado_em?: string;
  observacao?: string;
  status?: string;
}
