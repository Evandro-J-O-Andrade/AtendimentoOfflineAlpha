/**
 * NEW WAVE ENTERPRISE - Tipos Canônicos de Identidade
 * Conforme definido em docs/canonical/
 */

export interface Usuario {
    id: number;
    login: string;
    nome: string;
    perfil_id: number;
    perfil_nome: string;
}

export interface Tenant {
    id: number;
    nome_fantasia: string;
    slug: string;
    configuracoes_white_label: {
        logo_url?: string;
        tema_cor_primaria?: string;
    };
}

export interface SessaoUsuario {
    id_sessao: number;
    token: string;
    refresh_token: string;
    usuario: Usuario;
    tenant: Tenant;
    sistemas_autorizados: string[]; // ['HIS', 'FARMACIA', 'BI']
}