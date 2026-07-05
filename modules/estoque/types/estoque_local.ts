export interface EstoqueLocal {
  id_estoque_local: number;
  codigo: string;
  tipo: string;
  ala: string;
  nome: string;
  id_unidade: number;
  id_sistema: number;
  id_local_operacional: number;
  ativo: number;
  id_sessao_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface EstoqueLocalCreate {
  codigo?: string;
  tipo?: string;
  ala?: string;
  nome?: string;
  ativo?: number;
  criado_em?: string;
}

export interface EstoqueLocalUpdate {
  codigo?: string;
  tipo?: string;
  ala?: string;
  nome?: string;
  ativo?: number;
  criado_em?: string;
}
