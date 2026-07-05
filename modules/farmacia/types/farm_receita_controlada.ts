export interface FarmReceitaControlada {
  id_receita: number;
  id_operacao: number;
  origem: string;
  id_prescricao_medicacao: number;
  id_atendimento_ext: number;
  paciente_nome: string;
  paciente_documento: string;
  id_medico: number;
  id_prescritor_externo: number;
  numero_receita: string;
  status: string;
  recebido_em: string;
  id_usuario_recebimento: number;
  id_usuario_baixa_final: number;
  baixa_final_em: string;
  criado_em: string;
  id_entidade: number;
}

export interface FarmReceitaControladaCreate {
  origem?: string;
  paciente_nome?: string;
  paciente_documento?: string;
  numero_receita?: string;
  status?: string;
  baixa_final_em?: string;
  criado_em?: string;
}

export interface FarmReceitaControladaUpdate {
  origem?: string;
  paciente_nome?: string;
  paciente_documento?: string;
  numero_receita?: string;
  status?: string;
  baixa_final_em?: string;
  criado_em?: string;
}
