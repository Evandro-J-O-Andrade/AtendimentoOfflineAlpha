/**
 * NEW WAVE ENTERPRISE - Tipos Canônicos de Identidade
 * Define QUEM é o usuário e a QUAL empresa ele pertence.
 */

export interface Usuario {
  id: number;
  login: string;
  nome: string;
  perfil_nome: string;
  permissoes: string[]; // Ex: ['OP_RECEPCAO', 'ADM_SISTEMA']
}

export interface Tenant {
  id: number;
  nome_fantasia: string;
  slug: string;
  configuracoes_white_label: {
    logo_url?: string;
    cor_primaria?: string;
    tema_padrao?: 'light' | 'dark';
  };
}
