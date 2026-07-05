export interface Exame {
  id_exame: number;
  codigo: string;
  descricao: string;
  tipo: string;
  id_entidade: number;
}

export interface ExameCreate {
  codigo?: string;
  descricao?: string;
  tipo?: string;
}

export interface ExameUpdate {
  codigo?: string;
  descricao?: string;
  tipo?: string;
}
