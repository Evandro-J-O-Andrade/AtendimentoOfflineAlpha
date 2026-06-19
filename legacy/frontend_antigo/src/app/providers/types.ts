export interface Runtime {
    id_saas_entidade: number | null;
    id_unidade: number | null;
    id_local_operacional: number | null;
    id_perfil: number | null;
    contexto_selecionado: boolean;
    versao?: string;
    entidade?: { id: number; nome: string } | null;
    sistema?: { id: number; nome: string; codigo: string } | null;
    unidade?: { id: number; nome: string } | null;
    local?: { id: number; nome: string } | null;
    sessao?: { id: number; codigo: string } | null;
}

export interface RuntimeContextType {
    runtime: Runtime;
    setRuntime: (runtime: Partial<Runtime>) => void;
}

export interface TenantConfig {
    name: string;
    logo: string;
    logoUrl?: string;
    productName?: string;
    primaryColor: string;
    theme: 'light' | 'dark';
}