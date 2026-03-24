import React, { createContext, useContext, useState, useEffect, useCallback } from "react";
import api, { setAccessToken } from "../services/api";

// Cria o Contexto de Auth
const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [usuario, setUsuario] = useState(null);
  const [contextos, setContextos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [session, setSession] = useState(null);

  // Login
  const login = async (loginData) => {
    try {
      // Envia login e senha (não usuario)
      const response = await api.post("/auth/login", {
        login: loginData.login || loginData.usuario,
        senha: loginData.senha
      });
      
      const data = response.data;

      if (data.sucesso) {
        const { token, refreshToken, usuario: user, contextos: ctx, sessao } = data;
        setAccessToken(token);
        localStorage.setItem("refreshToken", refreshToken);
        setUsuario(user);
        setContextos(ctx || []);
        setSession(sessao);
        setIsAuthenticated(true);
        // Retorna os contextos também para quem chamou
        return { sucesso: true, contextos: ctx || [], temContexto: (ctx || []).length > 1 };
      }

      return { sucesso: false, mensagem: data.mensagem || "Erro no login" };
    } catch (err) {
      console.error("Erro login:", err);
      return { sucesso: false, mensagem: err.response?.data?.mensagem || "Erro interno" };
    }
  };

  // Logout
  const logout = () => {
    setUsuario(null);
    setContextos([]);
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
        
        // Busca contextos
        try {
          const contextosResponse = await api.get("/auth/meus-contextos");
          if (contextosResponse.data.contextos) {
            setContextos(contextosResponse.data.contextos);
          }
        } catch (e) {
          console.warn("Erro ao buscar contextos:", e);
        }
        
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
  const getContexto = useCallback(async () => {
    try {
      const response = await api.get("/contexto");
      return response.data.resultado;
    } catch (err) {
      console.error("Erro getContexto:", err);
      throw err;
    }
  }, []);

  // Definir contexto selecionado
  const setContexto = useCallback(async (contextoData) => {
    try {
      const response = await api.post("/contexto", contextoData);
      
      if (response.data.sucesso) {
        // Atualiza a sessão com os dados do resultado
        const resultado = response.data.resultado || {};
        setSession({
          id_sessao_usuario: session?.id_sessao_usuario,
          id_unidade: resultado.id_unidade,
          id_local_operacional: resultado.id_local_operacional,
          id_perfil: resultado.id_perfil,
          id_sala: resultado.id_sala,
          contexto_definido: true
        });
        return response.data;
      }
      throw new Error(response.data.mensagem || response.data.erro || "Erro ao definir contexto");
    } catch (err) {
      console.error("Erro setContexto:", err);
      throw err;
    }
  }, [session]);

  // Inicializa ao montar
  useEffect(() => {
    validarSessao();
  }, [validarSessao]);

  return (
    <AuthContext.Provider
      value={{
        usuario,
        contextos,
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
