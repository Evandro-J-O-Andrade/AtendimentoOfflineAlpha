export interface PdvCliente {
  id_cliente: number;
  nome: string;
  documento: string;
  telefone: string;
  email: string;
  criado_em: string;
  id_entidade: number;
}

export interface PdvClienteCreate {
  nome?: string;
  documento?: string;
  telefone?: string;
  email?: string;
  criado_em?: string;
}

export interface PdvClienteUpdate {
  nome?: string;
  documento?: string;
  telefone?: string;
  email?: string;
  criado_em?: string;
}
