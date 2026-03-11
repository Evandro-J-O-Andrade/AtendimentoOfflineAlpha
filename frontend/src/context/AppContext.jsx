import { createContext, useState, useEffect, useCallback, useContext } from "react";
import { 
  loginFull, 
  logoutFull, 
  getUserData,
  getToken 
} from "../services/loginService";

// Criar contexto global
const AppContext = createContext(null);

// Provider principal
export function AppProvider({ children }) {
  const [estado, setEstado] = useState({
    usuario: null,
    sessao: null,
    contexto: null,
    runtime: [],
    contextos: [],
    permissoes: [],
    dispositivo: null,
    isAuthenticated: false,
    loading: true
  });

  // Carregar dados do localStorage ao iniciar
  useEffect(() => {
    const inicializar = async () => {
      const token = localStorage.getItem("jwt_token");
      if (token) {
        const dados = getUserData();
        setEstado({
          usuario: dados.usuario,
          sessao: dados.sessao,
          contexto: dados.contexto,
          runtime: dados.runtime || [],
          contextos: dados.contextos || [],
          permissoes: dados.permissoes || [],
          dispositivo: dados.dispositivo,
          isAuthenticated: true,
          loading: false
        });
      } else {
        setEstado(prev => ({ ...prev, loading: false }));
      }
    };
    inicializar();
  }, []);

  // Função de login
  const login = useCallback(async (loginValue, senha, opcoes = {}) => {
    const resultado = await loginFull(loginValue, senha, opcoes);
    
    if (resultado.sucesso) {
      const dados = getUserData();
      setEstado({
        usuario: dados.usuario,
        sessao: dados.sessao,
        contexto: dados.contexto,
        runtime: dados.runtime || [],
        contextos: dados.contextos || [],
        permissoes: dados.permissoes || [],
        dispositivo: dados.dispositivo,
        isAuthenticated: true,
        loading: false
      });
      return { sucesso: true, ...resultado };
    }
    
    return { sucesso: false, erro: resultado.erro };
  }, []);

  // Função de logout
  const logout = useCallback(() => {
    logoutFull();
    setEstado({
      usuario: null,
      sessao: null,
      contexto: null,
      runtime: [],
      contextos: [],
      permissoes: [],
      dispositivo: null,
      isAuthenticated: false,
      loading: false
    });
  }, []);

  // Trocar contexto
  const trocarContexto = useCallback((novoContexto) => {
    setEstado(prev => ({ ...prev, contexto: novoContexto }));
    localStorage.setItem("contexto", JSON.stringify(novoContexto));
  }, []);

  // Verificar permissão
  const hasPermission = useCallback((permissao) => {
    return estado.permissoes.includes(permissao);
  }, [estado.permissoes]);

  // Verificar perfil
  const hasPerfil = useCallback((perfil) => {
    return estado.runtime.some(p => 
      p.perfil.toUpperCase().includes(perfil.toUpperCase())
    );
  }, [estado.runtime]);

  // Pegar perfis do usuário
  const getPerfis = useCallback(() => {
    return estado.runtime;
  }, [estado.runtime]);

  // Pegar contextos de um perfil específico
  const getContextosByPerfil = useCallback((perfilNome) => {
    const perfil = estado.runtime.find(p => 
      p.perfil.toUpperCase().includes(perfilNome.toUpperCase())
    );
    return perfil ? perfil.contextos : [];
  }, [estado.runtime]);

  // Valor do contexto
  const value = {
    // Estado (desestruturado para удобство)
    usuario: estado.usuario,
    sessao: estado.sessao,
    contexto: estado.contexto,
    runtime: estado.runtime,
    contextos: estado.contextos,
    permissoes: estado.permissoes,
    dispositivo: estado.dispositivo,
    isAuthenticated: estado.isAuthenticated,
    loading: estado.loading,
    
    // Funções
    login,
    logout,
    trocarContexto,
    hasPermission,
    hasPerfil,
    getPerfis,
    getContextosByPerfil,
    getToken
  };

  return (
    <AppContext.Provider value={value}>
      {children}
    </AppContext.Provider>
  );
}

export default AppContext;

// Hook para usar o contexto
export function useApp() {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error("useApp deve ser usado dentro de AppProvider");
  }
  return context;
}
