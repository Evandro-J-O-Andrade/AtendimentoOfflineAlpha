export interface HardeningSpExcecao {
  sp_nome: string;
  motivo: string;
  criado_em: string;
  id_entidade: number;
}

export interface HardeningSpExcecaoCreate {
  sp_nome?: string;
  motivo?: string;
  criado_em?: string;
}

export interface HardeningSpExcecaoUpdate {
  sp_nome?: string;
  motivo?: string;
  criado_em?: string;
}
