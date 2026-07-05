export interface ConselhoProfissional {
  id_conselho: number;
  sigla: string;
  nome: string;
  uf: string;
  id_entidade: number;
}

export interface ConselhoProfissionalCreate {
  sigla?: string;
  nome?: string;
  uf?: string;
}

export interface ConselhoProfissionalUpdate {
  sigla?: string;
  nome?: string;
  uf?: string;
}
