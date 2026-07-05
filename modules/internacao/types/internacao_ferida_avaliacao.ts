export interface InternacaoFeridaAvaliacao {
  id_internacao_ferida_avaliacao: number;
  id_internacao: number;
  data_hora: string;
  tipo: string;
  local_anatomico: string;
  estagio_lpp: string;
  tamanho_cm: string;
  aspecto: string;
  exsudato: string;
  odor: string;
  dor: string;
  curativo: string;
  observacoes: string;
  id_documento: number;
  id_usuario_responsavel: number;
  id_sessao_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface InternacaoFeridaAvaliacaoCreate {
  data_hora?: string;
  tipo?: string;
  local_anatomico?: string;
  estagio_lpp?: string;
  tamanho_cm?: string;
  aspecto?: string;
  exsudato?: string;
  odor?: string;
  dor?: string;
  curativo?: string;
  observacoes?: string;
  criado_em?: string;
}

export interface InternacaoFeridaAvaliacaoUpdate {
  data_hora?: string;
  tipo?: string;
  local_anatomico?: string;
  estagio_lpp?: string;
  tamanho_cm?: string;
  aspecto?: string;
  exsudato?: string;
  odor?: string;
  dor?: string;
  curativo?: string;
  observacoes?: string;
  criado_em?: string;
}
