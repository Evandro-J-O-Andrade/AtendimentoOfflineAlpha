export interface Usuario {
  id_usuario: string;
  nome: string;
  email: string;
  login?: string;
  status: 'ATIVO' | 'BLOQUEADO' | 'SUSPENSO';
  tenants: string[];
  perfis_dinamicos: PerfilContexto[];
  preferencias?: Record<string, unknown>;
  dispositivos?: Dispositivo[];
}

export interface PerfilContexto {
  id_perfil: number;
  nome: string;
  escopo: 'GLOBAL' | 'TENANT' | 'UNIDADE' | 'LOCAL';
}

export interface Dispositivo {
  id_dispositivo: string;
  nome: string;
  tipo: 'MOBILE' | 'DESKTOP' | 'TABLET' | 'TOTEM';
  fingerprint: string;
  confiavel: boolean;
  ultimo_acesso: string;
}

export interface Sessao {
  id_sessao: string;
  id_usuario: string;
  id_tenant: number;
  id_unidade: number;
  id_local: number;
  id_perfil: number;
  device_fingerprint: string;
  ip: string;
  user_agent: string;
  refreshed_em?: string;
  expires_at: string;
  status: 'ATIVA' | 'REVOGADA' | 'EXPIRADA';
}

export interface TenantConfig {
  id_tenant: number;
  nome: string;
  codigo: string;
  cnpj?: string;
  email_contato?: string;
  plano: 'FREE' | 'PRO' | 'BUSINESS' | 'ENTERPRISE';
  status: 'ATIVO' | 'SUSPENSO' | 'CANCELADO' | 'TRIAL';
  dominio?: string;
  logo_url?: string;
  primary_color?: string;
  secondary_color?: string;
  tema: 'light' | 'dark';
  idioma: string;
  moeda: string;
  fuso_horario: string;
}

export interface Unidade {
  id_unidade: number;
  id_tenant: number;
  nome: string;
  codigo: string;
  endereco?: string;
  cidade?: string;
  uf?: string;
  cnes?: string;
  ativa: boolean;
}

export interface LocalOperacional {
  id_local: number;
  id_unidade: number;
  id_tenant: number;
  nome: string;
  tipo: 'RECEPCAO' | 'CONSULTORIO' | 'FARMACIA' | 'LABORATORIO' | 'ENFERMARIA' | 'SALA_PROCEDIMENTO' | 'CAIXA' | 'ADMINISTRATIVO' | 'OUTRO';
  capacidade?: number;
  ativo: boolean;
}

export interface Aplicacao {
  id_aplicacao: number;
  codigo: string;
  nome: string;
  descricao: string;
  icone: string;
  url_base?: string;
  requer_contexto: boolean;
  ativa: boolean;
  ordem: number;
}

export interface Permissao {
  id_permissao: number;
  codigo: string;
  nome: string;
  descricao: string;
  recurso: string;
  acao: string;
}

export interface PerfilPermissao {
  id_perfil: number;
  id_permissao: number;
  concedida: boolean;
}

export type TipoContexto = {
  id_tenant: number;
  id_unidade: number;
  id_local: number;
  id_perfil: number;
  tenant?: TenantConfig;
  unidade?: Unidade;
  local?: LocalOperacional;
  perfil?: PerfilContexto;
};

export type CodigoResultado =
  | 'SUCESSO'
  | 'ERRO_VALIDACAO'
  | 'ERRO_PERMISSAO'
  | 'ERRO_CONTEXTO'
  | 'ERRO_NEGOCIO'
  | 'ERRO_SISTEMA'
  | 'ERRO_BANCO';

export interface RespostaAPI<T = unknown> {
  sucesso: boolean;
  codigo: CodigoResultado;
  mensagem?: string;
  dados?: T;
  erro?: {
    codigo: string;
    detalhe: string;
    timestamp: string;
  };
}
