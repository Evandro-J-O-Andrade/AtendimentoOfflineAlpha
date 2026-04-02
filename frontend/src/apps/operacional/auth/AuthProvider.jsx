import React, { createContext, useContext, useState, useEffect, useCallback } from "react";
import api, { setAccessToken } from "../services/api";

// Cria o Contexto de Auth
const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [usuario, setUsuario] = useState(null);
  const [contexto, setContextoState] = useState(null); // {unidades, perfis, salas/locais, especialidades, contextoAtual}
  const [menu, setMenu] = useState([]);
  const [loading, setLoading] = useState(true);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [session, setSession] = useState(null);

  // Login
  const login = async (loginData) => {
    try {
      const response = await api.post("/auth/login", {
        login: loginData.login || loginData.usuario,
        senha: loginData.senha,
      });

      const data = response.data;

      if (!data?.sucesso) {
        return { sucesso: false, mensagem: data?.mensagem || "Erro no login" };
      }

      const { token, refreshToken, usuario: user, sessao } = data;
      setAccessToken(token);
      localStorage.setItem("refreshToken", refreshToken);
      setUsuario(user);
      setSession(sessao);
      setIsAuthenticated(true);

      // Carrega contexto depois do login (menu só após contexto definido)
      await carregarContexto();

      return { sucesso: true };
    } catch (err) {
      console.error("Erro login:", err);
      return { sucesso: false, mensagem: err.response?.data?.mensagem || "Erro interno" };
    }
  };

  // Logout
  const logout = () => {
    setUsuario(null);
    setContextoState(null);
    setSession(null);
    setAccessToken(null);
    setIsAuthenticated(false);
    localStorage.removeItem("refreshToken");
  };

  // Validar sessão / refresh token
  const validarSessao = useCallback(async () => {
    const refreshToken = localStorage.getItem("refreshToken");
    if (!refreshToken) {
      setLoading(false);
      return;
    }

    try {
      const response = await api.post("/auth/refresh", { refreshToken });
      const data = response.data;

      if (data.sucesso) {
        const { token } = data;
        setAccessToken(token);
        
        // Após refresh, busca dados do usuário
        try {
          const userResponse = await api.get("/auth/me");
          if (userResponse.data.sucesso) {
            setUsuario(userResponse.data.usuario);
          }
        } catch (e) {
          console.warn("Erro ao buscar dados do usuário:", e);
        }
        
        await carregarContexto();
        
        setIsAuthenticated(true);
      } else {
        logout();
      }
    } catch (err) {
      console.error("Erro refresh token:", err);
      logout();
    } finally {
      setLoading(false);
    }
  }, []);

  // Buscar contexto/disponíveis
  // Busca contexto (unidades, perfis, salas, contextoAtual) via SPs novas
  const getContexto = useCallback(async () => {
    try {
      // Rota real montada em app.js: /api/contexto
      const { data } = await api.get("/contexto");
      // backend responde {sucesso, resultado:{unidades, locais, perfis, salas, especialidades}}
      if (data?.resultado) return data.resultado;
      return data;
    } catch (err) {
      console.error("Erro getContexto:", err);
      throw err;
    }
  }, []);

  // Definir contexto selecionado
  const setContexto = useCallback(async (contextoData) => {
    try {
      // contextoData esperado: { id_unidade, id_perfil, id_local }
      const { data } = await api.post("/contexto", contextoData);

      if (!data?.sucesso) {
        throw new Error(data?.mensagem || data?.erro || "Erro ao definir contexto");
      }

      // Atualiza sessão local com o que foi enviado
      setSession((prev) => ({
        ...(prev || {}),
        id_unidade: contextoData.id_unidade,
        id_local: contextoData.id_local || contextoData.id_sala || null,
        id_perfil: contextoData.id_perfil,
        contexto_definido: true,
      }));

      // Recarrega contexto após set
      await carregarContexto();
      await carregarMenu(true);
      return data;
    } catch (err) {
      console.error("Erro setContexto:", err);
      throw err;
    }
  }, []);

  const carregarMenu = useCallback(async (force = false) => {
    try {
      const ctxAtual = contexto?.contextoAtual;
      if (!force && (!ctxAtual || !ctxAtual.id_unidade || !ctxAtual.id_local_operacional || !ctxAtual.id_perfil)) {
        setMenu([]);
        return;
      }
      const { data } = await api.get("/auth/menu");
      if (data?.sucesso) {
        setMenu(data.resultado?.modulos || []);
      } else {
        setMenu([]);
      }
    } catch (e) {
      console.warn("Não foi possível carregar menu:", e?.message);
      setMenu([]);
    }
  }, []);

  const carregarContexto = useCallback(async () => {
    try {
      const resultado = await getContexto();
      // Normaliza nomes conforme backend
      setContextoState({
        unidades: resultado?.unidades || [],
        perfis: resultado?.perfis || [],
        salas: resultado?.salas || resultado?.locais || [],
        especialidades: resultado?.especialidades || [],
        contextoAtual: resultado?.contextoAtual || null,
      });
    } catch (e) {
      console.warn("Não foi possível carregar contexto:", e?.message);
    }
  }, [getContexto]);

  // Inicializa ao montar
  useEffect(() => {
    validarSessao();
  }, [validarSessao]);

  return (
    <AuthContext.Provider
      value={{
        usuario,
        contexto,
        menu,
        loading,
        isAuthenticated,
        session,
        login,
        logout,
        validarSessao,
        getContexto,
        setContexto,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

// Hook de conveniência
export const useAuth = () => useContext(AuthContext);
