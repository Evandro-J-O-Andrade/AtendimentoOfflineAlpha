/* eslint-disable react-refresh/only-export-components */
import { createContext, useContext, useState } from "react";
import { jwtDecode } from "jwt-decode";

const RuntimeAuthContext = createContext();

const REQUIRED_CONTEXT_FIELDS = [
    "id_usuario",
    "id_sessao_usuario",
    "id_sistema",
    "id_unidade",
    "id_local_operacional"
];

function hasOperationalContext(user) {
    if (!user || typeof user !== "object") return false;
    return REQUIRED_CONTEXT_FIELDS.every((field) => user[field] !== undefined && user[field] !== null);
}

function normalizeTokenPayload(user) {
    if (!user || typeof user !== "object") return user;

    return {
        ...user,
        // Compatibilidade com tokens legados que usam nomes alternativos.
        id_sessao_usuario: user.id_sessao_usuario ?? user.id_sessao ?? null,
        id_local_operacional: user.id_local_operacional ?? user.id_local ?? null
    };
}

function buildSessionFromToken(token) {
    if (!token) return null;

    try {
        const decoded = jwtDecode(token);
        const user = normalizeTokenPayload(decoded);
        return {
            token,
            user,
            hasContext: hasOperationalContext(user)
        };
    } catch {
        return {
            token,
            user: null,
            hasContext: false
        };
    }
}

export function RuntimeAuthProvider({ children }) {

    const [session, setSession] = useState(() => {
        const token = localStorage.getItem("runtime_token");
        if (token) {
            const builtSession = buildSessionFromToken(token);
            if (builtSession?.hasContext) {
                return builtSession;
            }
            localStorage.removeItem("runtime_token");
        }
        return null;
    });
    const [loading] = useState(false);

    // helper to login by setting token
    function loginWithToken(token) {
        localStorage.setItem("runtime_token", token);
        const builtSession = buildSessionFromToken(token);

        if (!builtSession?.hasContext) {
            localStorage.removeItem("runtime_token");
            setSession(null);
            return false;
        }

        setSession(builtSession);
        return true;
    }

    function logout() {
        localStorage.removeItem("runtime_token");
        setSession(null);
    }

    async function authFetch(input, init = {}) {
        const token = session?.token || localStorage.getItem("runtime_token");
        const headers = new Headers(init.headers || {});

        if (token) {
            headers.set("Authorization", `Bearer ${token}`);
        }

        const response = await fetch(input, { ...init, headers });

        if (response.status === 401) {
            logout();
        }

        return response;
    }

    return (
        <RuntimeAuthContext.Provider value={{
            session,
            setSession: loginWithToken,
            logout,
            loading,
            hasOperationalContext: Boolean(session?.hasContext),
            authFetch
        }}>
            {children}
        </RuntimeAuthContext.Provider>
    );
}

export function useRuntimeAuth() {
    return useContext(RuntimeAuthContext);
}

export default RuntimeAuthContext;
