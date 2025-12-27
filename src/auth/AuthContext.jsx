import { createContext, useState, useEffect, useContext, useRef } from "react";
import api from "../api/api";
import axios from "axios";

export const AuthContext = createContext(null);

function parseJwt(token) {
  if (!token) return null;
  try {
    const payload = token.split('.')[1];
    const decoded = JSON.parse(atob(payload));
    return decoded;
  } catch (e) {
    return null;
  }
}

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(JSON.parse(localStorage.getItem('user')) || null);
  const [token, setToken] = useState(localStorage.getItem("token"));
  const [tokenPayload, setTokenPayload] = useState(() => parseJwt(localStorage.getItem('token')));
  const [loading, setLoading] = useState(true);
  const [localAtual, setLocalAtual] = useState(() => {
    try {
      const s = localStorage.getItem('local_atendimento')
      return s ? JSON.parse(s) : null
    } catch (e) {
      return null
    }
  });
  const refreshTimeoutRef = useRef(null);

  const scheduleRefresh = (accessToken) => {
    if (!accessToken) return;
    const payload = parseJwt(accessToken);
    if (!payload?.exp) return;
    const expiresAt = payload.exp * 1000; // ms
    const now = Date.now();
    const msBefore = expiresAt - now - 60 * 1000; // renovar 60s antes
    if (msBefore <= 0) return; // já perto/expirado

    if (refreshTimeoutRef.current) {
      clearTimeout(refreshTimeoutRef.current);
    }
    refreshTimeoutRef.current = setTimeout(() => {
      refreshAccessToken();
    }, msBefore);
  };

  // Valida token no backend ao iniciar a aplicação (tenta refresh se necessário)
  useEffect(() => {
    const init = async () => {
      const storedToken = localStorage.getItem("token");

      if (!storedToken) {
        setLoading(false);
        return;
      }

      try {
        const res = await api.get("/auth/me.php");
        setUser(res.data);
        setToken(storedToken);
        setTokenPayload(parseJwt(storedToken));
        localStorage.setItem("user", JSON.stringify(res.data));
        scheduleRefresh(storedToken);
      } catch (err) {
        // tenta refresh via cookie (server lerá cookie HttpOnly) e depois revalidar
        const ok = await refreshAccessToken();
        if (ok) {
          try {
            const newTok = localStorage.getItem('token');
            setToken(newTok);
            setTokenPayload(parseJwt(newTok));
            const res2 = await api.get('/auth/me.php');
            setUser(res2.data);
            localStorage.setItem('user', JSON.stringify(res2.data));
          } catch (e) {
            signOut();
          }
        } else {
          signOut();
        }
      } finally {
        setLoading(false);
      }
    };

    init();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // Login
  const signIn = (tokenValue, userData) => {
    localStorage.setItem("token", tokenValue);
    localStorage.setItem("user", JSON.stringify(userData));
    setToken(tokenValue);
    setTokenPayload(parseJwt(tokenValue));
    setUser(userData);
    scheduleRefresh(tokenValue);

    // se não existe local selecionado, manter nulo — o Footer abrirá o seletor automaticamente
  };

  // Refresh (cookie-based)
  const refreshAccessToken = async () => {
    try {
      const resp = await axios.post('/api/auth/refresh.php', {}, { withCredentials: true });
      const { token: newToken } = resp.data;
      if (newToken) {
        localStorage.setItem('token', newToken);
        setToken(newToken);
        setTokenPayload(parseJwt(newToken));
        scheduleRefresh(newToken);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  };

  // Logout (revoga refresh cookie no servidor)
  const signOut = async () => {
    try {
      await axios.post('/api/auth/logout.php', {}, { withCredentials: true });
    } catch (e) {
      // ignore errors on logout
    }

    localStorage.removeItem("token");
    localStorage.removeItem("user");
    localStorage.removeItem('local_atendimento');
    setToken(null);
    setTokenPayload(null);
    setUser(null);
    setLocalAtual(null);
    if (refreshTimeoutRef.current) {
      clearTimeout(refreshTimeoutRef.current);
    }
    window.location.href = "/login";
  };

  // ======= HELPERS DE PERFIL =======
  const hasPerfil = perfil => user?.perfis?.includes(perfil);

  const isAdmin = () => hasPerfil("ADMIN");
  const isMedico = () => hasPerfil("MEDICO");
  const isRecepcao = () => hasPerfil("RECEPCAO");

  const setLocal = (local) => {
    setLocalAtual(local);
    if (local) {
      try { localStorage.setItem('local_atendimento', JSON.stringify(local)) } catch (e) {}
    } else {
      localStorage.removeItem('local_atendimento')
    }
  }

  const value = {
    user,
    token,
    tokenPayload,
    loading,
    localAtual,
    setLocal,
    isAuthenticated: !!user,
    signIn,
    signOut,
    refreshAccessToken,
    hasPerfil,
    isAdmin,
    isMedico,
    isRecepcao,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

// Hook de conveniência
export const useAuth = () => useContext(AuthContext);
