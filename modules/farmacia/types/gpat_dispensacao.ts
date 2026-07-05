export interface GpatDispensacao {
  id_gpat_dispensacao: number;
  id_gpat_item: number;
  id_lote: number;
  quantidade: number;
  id_local_estoque: number;
  id_usuario: number;
  id_sessao_usuario: number;
  status: string;
  observacao: string;
  entregue_em: string;
  estornado_em: string;
  id_entidade: number;
}

export interface GpatDispensacaoCreate {
  status?: string;
  observacao?: string;
  entregue_em?: string;
  estornado_em?: string;
}

export interface GpatDispensacaoUpdate {
  status?: string;
  observacao?: string;
  entregue_em?: string;
  estornado_em?: string;
}
