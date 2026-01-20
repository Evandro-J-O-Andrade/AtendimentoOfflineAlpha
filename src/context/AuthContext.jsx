import React, { createContext, useContext, useState, useEffect } from "react";
import api from "@/services/api";

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [token, setToken] = useState(localStorage.getItem("token") || "");
  const [loading, setLoading] = useState(true);
  const [local, setLocalState] = useState(null);

  // Inicializa usuário se já houver token
  useEffect(() => {
    if (!token) {
      setLoading(false);
      return;
    }

    const fetchUser = async () => {
      try {
        // Endpoint real: retorna usuário/perfis se token for válido
        const res = await api.get("/auth/me.php");

        // Seu me.php atualmente retorna o próprio usuário (array). Se você embrulhar em {usuario: ...}, ajuste aqui.
        const usuario = res.data?.usuario ?? res.data;
        setUser(usuario);
      } catch (err) {
        setToken("");
        localStorage.removeItem("token");
        setUser(null);
      } finally {
        setLoading(false);
      }
    };

    fetchUser();
  }, [token]);

  function signIn(newToken, usuario) {
    localStorage.setItem("token", newToken);
    setToken(newToken);
    setUser(usuario);
  }

  function signOut() {
    localStorage.removeItem("token");
    setToken("");
    setUser(null);
    setLocalState(null);
  }

  // PADRÃO: setLocal (não setAuthLocal)
  function setLocal(localSelecionado) {
    setLocalState(localSelecionado);
  }

  function isAdmin() {
    const perfis = user?.perfis || [];
    return perfis.includes("ADMIN_MASTER") || perfis.includes("MASTER");
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
        local,
        signIn,
        signOut,
        setLocal,
        isAdmin,
        hasPerfil,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}

