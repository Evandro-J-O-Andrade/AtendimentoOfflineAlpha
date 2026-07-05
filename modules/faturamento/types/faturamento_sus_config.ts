export interface FaturamentoSusConfig {
  id: number;
  id_unidade: number;
  cnes_unidade: string;
  gestao_municipal_estadual: string;
  id_entidade: number;
}

export interface FaturamentoSusConfigCreate {
  gestao_municipal_estadual?: string;
}

export interface FaturamentoSusConfigUpdate {
  gestao_municipal_estadual?: string;
}
