export interface Usuario {
    id_usuario?: number;
    login?: string;
    nome?: string;
    [key: string]: unknown;
}

export interface Entidade {
    id_entidade: number;
    nome_fantasia?: string;
    razao_social?: string;
    logo_url?: string;
    cor_primaria?: string;
    cor_secundaria?: string;
}

export interface Sessao {
    id_sessao?: number;
    id_sessao_usuario?: number;
    id_usuario?: number;
    id_perfil?: number;
    id_unidade?: number;
    usuario?: Usuario;
    contexto_definido?: boolean;
    [key: string]: unknown;
}

export interface AuthContextValue {
    usuario: Usuario | null;
    menu: unknown[];
    loading: boolean;
    isAuthenticated: boolean;
    session: Sessao | null;
    sessao: Sessao | null;
    login: (loginData: { login?: string; usuario?: string; senha: string }) => Promise<{ sucesso: boolean; mensagem?: string }>;
    logout: () => Promise<void>;
    validarSessao: () => Promise<void>;
}