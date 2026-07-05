export interface FaturamentoItem {
  id_item: number;
  origem: string;
  id_origem: number;
  descricao: string;
  quantidade: number;
  valor_unitario: number;
  valor_total: number;
  id_ffa: number;
  id_internacao: number;
  criado_em: string;
  criado_por: number;
  status: string;
  id_conta: number;
  id_codigo: number;
  sistema_codigo: string;
  codigo: string;
  tipo: string;
  desconto: number;
  total_linha: number;
  atualizado_em: string;
  id_entidade: number;
}

export interface FaturamentoItemCreate {
  origem?: string;
  descricao?: string;
  valor_unitario?: number;
  valor_total?: number;
  criado_em?: string;
  criado_por?: number;
  status?: string;
  sistema_codigo?: string;
  codigo?: string;
  tipo?: string;
  desconto?: number;
  total_linha?: number;
  atualizado_em?: string;
}

export interface FaturamentoItemUpdate {
  origem?: string;
  descricao?: string;
  valor_unitario?: number;
  valor_total?: number;
  criado_em?: string;
  criado_por?: number;
  status?: string;
  sistema_codigo?: string;
  codigo?: string;
  tipo?: string;
  desconto?: number;
  total_linha?: number;
  atualizado_em?: string;
}
