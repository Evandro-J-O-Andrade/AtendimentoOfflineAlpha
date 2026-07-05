export interface PessoaAlergias {
  id: number;
  id_pessoa: number;
  substancia: string;
  gravidade: string;
  registrado_por: number;
  data_registro: string;
  id_entidade: number;
}

export interface PessoaAlergiasCreate {
  substancia?: string;
  registrado_por?: number;
  data_registro?: string;
}

export interface PessoaAlergiasUpdate {
  substancia?: string;
  registrado_por?: number;
  data_registro?: string;
}
