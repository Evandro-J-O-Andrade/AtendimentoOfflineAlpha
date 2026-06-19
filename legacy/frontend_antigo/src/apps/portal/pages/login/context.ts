/**
 * NEW WAVE ENTERPRISE - Tipos de Contexto Operacional
 * Define ONDE o usuário está trabalhando no momento.
 */

export interface ContextoOperacional {
  unidade_id: number;
  unidade_nome: string;
  local_id: number;
  local_nome: string;
  setor_id?: number;
  guiche_id?: number;
}
