export interface MdSigpatMedicamento {
  competencia: string;
  codigo: string;
  descricao: string;
  apresentacao: string;
  forma_farmaceutica: string;
  concentracao: string;
  unidade_medida: string;
  via_administracao: string;
  ativo: number;
  atualizado_em: string;
  id_entidade: number;
}

export interface MdSigpatMedicamentoCreate {
  competencia?: string;
  codigo?: string;
  descricao?: string;
  apresentacao?: string;
  forma_farmaceutica?: string;
  concentracao?: string;
  via_administracao?: string;
  ativo?: number;
  atualizado_em?: string;
}

export interface MdSigpatMedicamentoUpdate {
  competencia?: string;
  codigo?: string;
  descricao?: string;
  apresentacao?: string;
  forma_farmaceutica?: string;
  concentracao?: string;
  via_administracao?: string;
  ativo?: number;
  atualizado_em?: string;
}
