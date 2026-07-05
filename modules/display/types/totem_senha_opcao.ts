export interface TotemSenhaOpcao {
  id_opcao: number;
  id_painel: number;
  codigo: string;
  label: string;
  lane: string;
  tipo_atendimento: string;
  prefixo: string;
  ordem: number;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface TotemSenhaOpcaoCreate {
  codigo?: string;
  label?: string;
  lane?: string;
  tipo_atendimento?: string;
  prefixo?: string;
  ordem?: number;
  ativo?: number;
  criado_em?: string;
}

export interface TotemSenhaOpcaoUpdate {
  codigo?: string;
  label?: string;
  lane?: string;
  tipo_atendimento?: string;
  prefixo?: string;
  ordem?: number;
  ativo?: number;
  criado_em?: string;
}
