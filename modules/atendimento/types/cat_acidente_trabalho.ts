export interface CatAcidenteTrabalho {
  id: number;
  id_atendimento: number;
  id_pessoa_trabalhador: number;
  data_acidente: string;
  tipo_acidente: string;
  descricao_acidente: string;
  agente_causador: string;
  parte_corpo: string;
  cid10_relacionado: string;
  status_cat: string;
  numero_cat: string;
  id_sessao_usuario: number;
  id_usuario_criador: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface CatAcidenteTrabalhoCreate {
  agente_causador?: string;
  parte_corpo?: string;
  status_cat?: string;
  numero_cat?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface CatAcidenteTrabalhoUpdate {
  agente_causador?: string;
  parte_corpo?: string;
  status_cat?: string;
  numero_cat?: string;
  criado_em?: string;
  atualizado_em?: string;
}
