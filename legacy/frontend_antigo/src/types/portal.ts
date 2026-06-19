export interface PortalModule {
    id: string;
    nome: string;
    descricao: string;
    icone: string;
    rota: string;
    requerContexto: boolean;
}

export interface Unidade {
    id_unidade: number;
    nome: string;
}

export interface Local {
    id_local: number;
    nome: string;
    id_unidade: number;
}

export interface Sala {
    id_sala: number;
    nome: string;
    id_local: number;
}

export interface ContextoState {
    unidade: Unidade | null;
    local: Local | null;
    sala: Sala | null;
    loading: boolean;
    sessao: any;
}

export interface ContextoSelecao {
    unidades: Unidade[];
    unidade?: Unidade;
    local?: Local;
    sala?: Sala;
}