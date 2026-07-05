export interface ProntuarioEvolucao {
  id_evolucao: number;
  id_atendimento: number;
  id_usuario: number;
  status: string;
  criado_em: string;
  alterado_em: string;
  id_entidade: number;
}

export interface ProntuarioEvolucaoCreate {
  status?: string;
  criado_em?: string;
  alterado_em?: string;
}

export interface ProntuarioEvolucaoUpdate {
  status?: string;
  criado_em?: string;
  alterado_em?: string;
}
