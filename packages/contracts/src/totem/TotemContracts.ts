export interface TotemOpcao {
  id_opcao: number;
  codigo: string;
  label: string;
  lane: string;
  tipo_atendimento: string;
  prefixo: string;
  ordem: number;
  ativo: number;
}

export interface TotemPlantaoItem {
  especialidade: string;
  medico_nome: string;
  crm: string;
}

export interface TotemSenhaRequest {
  id_opcao: number;
  id_unidade: number;
  id_local_operacional: number;
  id_paciente?: number | null;
}

export interface TotemSenhaResponse {
  id_senha: number;
  numero_senha: string;
  tipo_atendimento: string;
  prefixo: string;
  uuid_transacao: string;
  mensagem: string;
}

export interface TotemConfig {
  id_unidade: number;
  id_local_operacional: number;
}
