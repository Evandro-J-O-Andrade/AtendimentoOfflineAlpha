import { createContext, useState, useEffect, useContext } from 'react';

export const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
    const [user, setUser] = useState(null);
    const [token, setToken] = useState(localStorage.getItem('token'));
    const [loading, setLoading] = useState(true);

   // AuthProvider - NOVO useEffect
useEffect(() => {
    // Esta função será executada apenas na montagem inicial do componente (uma vez)
    const storedToken = localStorage.getItem('token');
    const storedUser = localStorage.getItem('user');
    
    if (storedToken && storedUser) {
        setToken(storedToken);
        // Garante que o user seja carregado do localStorage
        setUser(JSON.parse(storedUser));
    }

    setLoading(false);
}, []); // Array de dependências vazio

    const signIn = (newToken, userData) => {
        setToken(newToken);
        setUser(userData);
        localStorage.setItem('token', newToken);
        localStorage.setItem('user', JSON.stringify(userData));
    };

    const signOut = () => {
        setToken(null);
        setUser(null);
        localStorage.removeItem('token');
        localStorage.removeItem('user');
    };

    // ======= HELPERS DE PERFIL =======
    const hasPerfil = (perfil) =>
        user?.perfis?.includes(perfil);

    const isAdmin = () =>
        hasPerfil('ADMIN');

   

    const isMedico = () =>
        hasPerfil('MEDICO');

    const isRecepcao = () =>
        hasPerfil('RECEPCAO');

    const authContextValue = {
        user,
        token,
        loading,
        isAuthenticated: !!token,
        signIn,
        signOut,
        hasPerfil,
        isAdmin,
        isMedico,
        isRecepcao
    };

    return (
        <AuthContext.Provider value={authContextValue}>
            {children}
        </AuthContext.Provider>
    );
};

// Hook de conveniência
export const useAuth = () => useContext(AuthContext);
