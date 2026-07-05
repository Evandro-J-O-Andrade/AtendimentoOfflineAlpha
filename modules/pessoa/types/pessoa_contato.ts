export interface PessoaContato {
  id: number;
  id_pessoa: number;
  tipo: string;
  valor: string;
  principal: number;
  id_entidade: number;
}

export interface PessoaContatoCreate {
  tipo?: string;
  valor?: string;
  principal?: number;
}

export interface PessoaContatoUpdate {
  tipo?: string;
  valor?: string;
  principal?: number;
}
