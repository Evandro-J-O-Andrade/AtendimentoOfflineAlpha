export interface PessoaConselhoRegistro {
  id_pessoa_conselho: number;
  id_pessoa: number;
  id_conselho: number;
  uf_registro: string;
  registro: string;
  eh_principal: number;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface PessoaConselhoRegistroCreate {
  uf_registro?: string;
  registro?: string;
  eh_principal?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface PessoaConselhoRegistroUpdate {
  uf_registro?: string;
  registro?: string;
  eh_principal?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
