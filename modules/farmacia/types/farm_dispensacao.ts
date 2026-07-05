export interface FarmDispensacao {
  id_dispensacao: number;
  id_receita: number;
  tipo: string;
  id_usuario_primeira_baixa: number;
  primeira_baixa_em: string;
  id_usuario_segunda_baixa: number;
  segunda_baixa_em: string;
  status: string;
  criado_em: string;
  id_entidade: number;
}

export interface FarmDispensacaoCreate {
  tipo?: string;
  primeira_baixa_em?: string;
  segunda_baixa_em?: string;
  status?: string;
  criado_em?: string;
}

export interface FarmDispensacaoUpdate {
  tipo?: string;
  primeira_baixa_em?: string;
  segunda_baixa_em?: string;
  status?: string;
  criado_em?: string;
}
