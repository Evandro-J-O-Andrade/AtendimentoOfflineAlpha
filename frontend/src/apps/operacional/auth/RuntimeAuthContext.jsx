import { createContext, useContext, useState } from "react";

const RuntimeAuthContext = createContext();

export function RuntimeAuthProvider({ children }) {

    const [session, setSession] = useState(null);
    const [loading, setLoading] = useState(true);

    return (
        <RuntimeAuthContext.Provider value={{
            session,
            setSession,
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