export interface Unidade {
    id_unidade: number;
    nome: string;
}

export interface Local {
    id_local: number;
    nome: string;
    id_unidade?: number;
}

export interface Sala {
    id_sala: number;
    nome: string;
    id_local?: number;
}

export interface Setor {
    id_setor: number;
    nome: string;
}

export interface Especialidade {
    id_especialidade: number;
    nome: string;
}

export interface Guichê {
    id_guiche: number;
    nome: string;
    id_local?: number;
}

export interface Equipe {
    id_equipe: number;
    nome: string;
}

export interface Projeto {
    id_projeto: number;
    nome: string;
}

export interface ContextoSelecao {
    unidade?: Unidade;
    local?: Local;
    sala?: Sala;
    setor?: Setor;
    especialidade?: Especialidade;
    guiche?: Guichê;
    equipe?: Equipe;
    projeto?: Projeto;
}

export interface ContextoState extends ContextoSelecao {
    loading: boolean;
}