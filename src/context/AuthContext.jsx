import React, { createContext, useContext, useState, useEffect } from 'react';
import api from '@/services/api';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [token, setToken] = useState(localStorage.getItem('token') || '');
  const [loading, setLoading] = useState(true);
  const [contextoLocal, setContextoLocal] = useState(null);

  // inicializa usuário se já houver token
  useEffect(() => {
    if (!token) return setLoading(false);

    const fetchUser = async () => {
      try {
        const res = await api.get('/auth_validate.php'); 
        setUser(res.data.usuario);
      } catch (err) {
        setToken('');
        localStorage.removeItem('token');
        setUser(null);
      } finally {
        setLoading(false);
      }
    };

    fetchUser();
  }, [token]);

  function signIn(newToken, usuario) {
    localStorage.setItem('token', newToken);
    setToken(newToken);
    setUser(usuario);
  }

  function signOut() {
    localStorage.removeItem('token');
    setToken('');
    setUser(null);
    setContextoLocal(null);
  }

  function setAuthLocal(local) {
    setContextoLocal(local);
  }

  function isAdmin() {
    return user?.perfis?.includes('ADMIN_MASTER');
  }

  function hasPerfil(perfil) {
    return user?.perfis?.includes(perfil);
  }

  return (
    <AuthContext.Provider
      value={{
        user,
        token,
        loading,
        contextoLocal,
        signIn,
        signOut,
        setAuthLocal,
        isAdmin,
        hasPerfil
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}
