export interface PrescricaoKitMaster {
  id: number;
  nome_kit: string;
  descricao: string;
  ativo: number;
  id_entidade: number;
}

export interface PrescricaoKitMasterCreate {
  nome_kit?: string;
  descricao?: string;
  ativo?: number;
}

export interface PrescricaoKitMasterUpdate {
  nome_kit?: string;
  descricao?: string;
  ativo?: number;
}
