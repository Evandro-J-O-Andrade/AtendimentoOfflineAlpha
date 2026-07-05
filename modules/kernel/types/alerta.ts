export interface Alerta {
  id_alerta: number;
  codigo: string;
  titulo: string;
  mensagem: string;
  gpat: string;
  id_ffa: number;
  id_paciente: number;
  id_unidade: number;
  id_local_operacional: number;
  severidade: string;
  status: string;
  entidade_origem: string;
  id_origem: number;
  id_sessao_usuario_origem: number;
  id_usuario_origem: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface AlertaCreate {
  codigo?: string;
  titulo?: string;
  mensagem?: string;
  gpat?: string;
  status?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface AlertaUpdate {
  codigo?: string;
  titulo?: string;
  mensagem?: string;
  gpat?: string;
  status?: string;
  criado_em?: string;
  atualizado_em?: string;
}
