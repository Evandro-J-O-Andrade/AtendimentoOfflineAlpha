export interface FaturamentoConvenios {
  id: number;
  nome_fantasia: string;
  registro_ans: string;
  id_tabela_precos: number;
  id_entidade: number;
}

export interface FaturamentoConveniosCreate {
  nome_fantasia?: string;
  registro_ans?: string;
}

export interface FaturamentoConveniosUpdate {
  nome_fantasia?: string;
  registro_ans?: string;
}
