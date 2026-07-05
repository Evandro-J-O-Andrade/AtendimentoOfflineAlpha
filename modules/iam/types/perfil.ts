export interface Perfil {
  id_perfil: number;
  codigo: string;
  nome: string;
  descricao: string;
  contexto: string;
  criado_em: string;
  id_entidade: number;
}

export interface PerfilCreate {
  codigo?: string;
  nome?: string;
  descricao?: string;
  contexto?: string;
  criado_em?: string;
}

export interface PerfilUpdate {
  codigo?: string;
  nome?: string;
  descricao?: string;
  contexto?: string;
  criado_em?: string;
}
