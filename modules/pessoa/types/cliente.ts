export interface Cliente {
  id_cliente: number;
  nome: string;
  documento: string;
  telefone: string;
  email: string;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface ClienteCreate {
  nome?: string;
  documento?: string;
  telefone?: string;
  email?: string;
  ativo?: number;
  criado_em?: string;
}

export interface ClienteUpdate {
  nome?: string;
  documento?: string;
  telefone?: string;
  email?: string;
  ativo?: number;
  criado_em?: string;
}
