export interface PrescritorExterno {
  id_prescritor_externo: number;
  nome: string;
  conselho: string;
  numero_conselho: string;
  uf: string;
  documento: string;
  telefone: string;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface PrescritorExternoCreate {
  nome?: string;
  conselho?: string;
  numero_conselho?: string;
  uf?: string;
  documento?: string;
  telefone?: string;
  ativo?: number;
  criado_em?: string;
}

export interface PrescritorExternoUpdate {
  nome?: string;
  conselho?: string;
  numero_conselho?: string;
  uf?: string;
  documento?: string;
  telefone?: string;
  ativo?: number;
  criado_em?: string;
}
