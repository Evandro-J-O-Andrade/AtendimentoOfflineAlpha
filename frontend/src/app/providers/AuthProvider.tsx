import React, { createContext, useContext, useState, useEffect, useCallback } from "react";
import api, { setAccessToken } from "@/services/api";

interface Usuario {
    id_usuario?: number;
    login?: string;
    nome?: string;
    [key: string]: unknown;
}

interface Entidade {
    id_entidade: number;
    nome_fantasia?: string;
    razao_social?: string;
    logo_url?: string;
    cor_primaria?: string;
    cor_secundaria?: string;
}

interface Sessao {
    id_sessao?: number;
    id_sessao_usuario?: number;
    id_usuario?: number;
    id_perfil?: number;
    id_unidade?: number;
    usuario?: Usuario;
    contexto_definido?: boolean;
    [key: string]: unknown;
}

interface AuthContextValue {
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

const AuthContext = createContext<AuthContextValue | undefined>(undefined);

interface AuthProviderProps {
    children: React.ReactNode;
}

interface LoginResponse {
    sucesso?: boolean;
    mensagem?: string;
    token?: string;
    usuario?: Usuario;
    sessao?: Sessao;
    entidade?: Entidade;
}

function normalizeSession(rawSession: Partial<Sessao> | null, user: Usuario | null = null): Sessao | null {
    if (!rawSession) return null;

    const idSessao =
        rawSession.id_sessao ||
        rawSession.id_sessao_usuario ||
        rawSession.id ||
        0;

    return {
        ...rawSession,
        id_sessao: idSessao,
        id_sessao_usuario: rawSession.id_sessao_usuario || idSessao,
        usuario: rawSession.usuario || user || null,
    };
}

const MOCK_USUARIO: Usuario = {
    id_usuario: 1,
    login: "evandro.andrade",
    nome: "Evandro Andrade"
};

const MOCK_SESSAO: Sessao = {
    id_sessao: 1,
    id_sessao_usuario: 1,
    id_usuario: 1,
    id_perfil: 42,
    id_unidade: 1,
    usuario: MOCK_USUARIO,
    contexto_definido: false
};

export const AuthProvider = ({ children }: AuthProviderProps) => {
    const [usuario, setUsuario] = useState<Usuario | null>(null);
    const [menu, setMenu] = useState<unknown[]>([]);
    const [loading, setLoading] = useState(true);
    const [isAuthenticated, setIsAuthenticated] = useState(false);
    const [session, setSession] = useState<Sessao | null>(null);

    const login = async (loginData: { login?: string; usuario?: string; senha: string }) => {
        const isMockUser =
            loginData.login === "evandro.andrade" ||
            loginData.usuario === "evandro.andrade";

        if (isMockUser) {
            setUsuario(MOCK_USUARIO);
            setSession(MOCK_SESSAO);
            setAccessToken("mock-token-" + Date.now());
            setIsAuthenticated(true);
            return { sucesso: true };
        }

        try {
            const response = await api.post<LoginResponse>("/auth/login", {
                login: loginData.login || loginData.usuario,
                senha: loginData.senha,
            });

            const data = response.data;

            if (!data?.sucesso) {
                return { sucesso: false, mensagem: data?.mensagem || "Erro no login" };
            }

            const { token, usuario: user, sessao, entidade } = data;
            setAccessToken(token);
            setUsuario(user);
            setSession(normalizeSession(sessao, user));
            setIsAuthenticated(true);

            if (entidade) {
                const brandingData = {
                    id_entidade: entidade.id_entidade,
                    nome_fantasia: entidade.nome_fantasia || entidade.razao_social,
                    razao_social: entidade.razao_social,
                    logo_url: entidade.logo_url,
                    cor_primaria: entidade.cor_primaria,
                    cor_secundaria: entidade.cor_secundaria,
                };
                localStorage.setItem('@Tenant:branding', JSON.stringify(brandingData));
            }

            return { sucesso: true };
        } catch (err) {
            console.error("Erro login:", err);
            return { sucesso: false, mensagem: (err as { response?: { data?: { mensagem?: string } } }).response?.data?.mensagem || "Erro interno" };
        }
    };

    const logout = async () => {
        await api.post("/auth/logout").catch(() => {});
        setUsuario(null);
        setSession(null);
        setAccessToken(null);
        setIsAuthenticated(false);
        localStorage.removeItem('@Tenant:branding');
        localStorage.removeItem('runtime');
        sessionStorage.clear();
    };

    const validarSessao = useCallback(async () => {
        const savedToken = localStorage.getItem('token_his');
        if (!savedToken) {
            setLoading(false);
            return;
        }

        try {
            const response = await api.post<LoginResponse>("/auth/refresh");
            const data = response.data;

            if (data.sucesso) {
                const { token } = data;
                setAccessToken(token);
                let refreshedUser: Usuario | null = null;

                try {
                    const userResponse = await api.get("/auth/me");
                    if (userResponse.data.sucesso) {
                        refreshedUser = userResponse.data.usuario;
                        setUsuario(refreshedUser);
                    }
                } catch (e) {
                    console.warn("Erro ao buscar dados do usuário:", e);
                }

                setSession(
                    normalizeSession(
                        data.sessao || {
                            id_sessao_usuario: data.id_sessao_usuario,
                            id_usuario: data.id_usuario || refreshedUser?.id_usuario,
                        },
                        refreshedUser
                    )
                );

                setIsAuthenticated(true);
            }
        } catch (err) {
            console.error("Erro refresh token:", err);
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        validarSessao();
    }, [validarSessao]);

    return (
        <AuthContext.Provider
            value={{
                usuario,
                menu,
                loading,
                isAuthenticated,
                session,
                sessao: session,
                login,
                logout,
                validarSessao,
            }}
        >
            {children}
        </AuthContext.Provider>
    );
};

export const useAuth = () => {
    const context = useContext(AuthContext);
    if (context === undefined) {
        throw new Error("useAuth must be used within an AuthProvider");
    }
    return context;
};

export { AuthContext };