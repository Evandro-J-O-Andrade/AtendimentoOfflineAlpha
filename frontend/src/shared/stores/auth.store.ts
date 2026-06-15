import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface Usuario {
    id_usuario: number;
    login: string;
    nome: string;
}

interface Sessao {
    id_sessao_usuario: number;
    id_usuario: number;
    id_perfil: number;
    id_unidade: number;
}

interface AuthState {
    usuario: Usuario | null;
    sessao: Sessao | null;
    isAuthenticated: boolean;
    login: (usuario: Usuario, sessao: Sessao) => void;
    logout: () => void;
}

export const useAuthStore = create<AuthState>()(
    persist(
        (set) => ({
            usuario: null,
            sessao: null,
            isAuthenticated: false,
            login: (usuario, sessao) => set({ usuario, sessao, isAuthenticated: true }),
            logout: () => set({ usuario: null, sessao: null, isAuthenticated: false }),
        }),
        {
            name: 'auth-storage',
        }
    )
);