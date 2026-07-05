export interface ErroCatalogo {
  id_erro_catalogo: number;
  codigo: string;
  dominio: string;
  descricao: string;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface ErroCatalogoCreate {
  codigo?: string;
  dominio?: string;
  descricao?: string;
  ativo?: number;
  criado_em?: string;
}

export interface ErroCatalogoUpdate {
  codigo?: string;
  dominio?: string;
  descricao?: string;
  ativo?: number;
  criado_em?: string;
}
