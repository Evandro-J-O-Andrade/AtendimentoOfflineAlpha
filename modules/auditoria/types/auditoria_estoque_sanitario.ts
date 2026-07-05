export interface AuditoriaEstoqueSanitario {
  id: number;
  id_farmaco: number;
  id_lote: number;
  id_local: number;
  quantidade: number;
  nivel_risco: string;
  criado_por: number;
  criado_em: string;
  id_entidade: number;
}

export interface AuditoriaEstoqueSanitarioCreate {
  nivel_risco?: string;
  criado_por?: number;
  criado_em?: string;
}

export interface AuditoriaEstoqueSanitarioUpdate {
  nivel_risco?: string;
  criado_por?: number;
  criado_em?: string;
}
