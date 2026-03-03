import { createContext, useContext, useState, useEffect } from "react";
import * as jwtDecodeLib from "jwt-decode";
const jwtDecode = jwtDecodeLib.default || jwtDecodeLib;

const RuntimeAuthContext = createContext();

export function RuntimeAuthProvider({ children }) {

    const [session, setSession] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const token = localStorage.getItem("runtime_token");
        if (token) {
            try {
                const decoded = jwtDecode(token);
                setSession({ token, user: decoded });
            } catch {
                setSession({ token });
            }
        }
        setLoading(false);
    }, []);

    // helper to login by setting token
    function loginWithToken(token) {
        localStorage.setItem("runtime_token", token);
        try {
            const decoded = jwtDecode(token);
            setSession({ token, user: decoded });
        } catch {
            setSession({ token });
        }
    }

    function logout() {
        localStorage.removeItem("runtime_token");
        setSession(null);
    }

    return (
        <RuntimeAuthContext.Provider value={{
            session,
            setSession: loginWithToken,
            logout,
            loading
        }}>
            {children}
        </RuntimeAuthContext.Provider>
    );
}

export function useRuntimeAuth() {
    return useContext(RuntimeAuthContext);
}

export default RuntimeAuthContext;