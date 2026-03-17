import { createContext, useState, useEffect, useCallback, useContext } from "react";
import { loginService, logoutFull, getUserData, getToken } from "../services/loginService";
import { fetchSession } from "../services/sessionService";

const AppContext = createContext(null);

const normalizePermissoes = (perms) =>
  (perms || []).map((p) =>
    typeof p === "string"
      ? {
          codigo: p,
          acao_frontend: p.toLowerCase(),
          nome: p,
          grupo_menu: "Geral",
          ativo: 1,
        }
      : p
  );

export function AppProvider({ children }) {
  const [estado, setEstado] = useState({
    usuario: null,
    sessao: null,
    contexto: null,
    contextosDisponiveis: [],
    permissoes: [],
    isAuthenticated: false,
    loading: true,
  });

  useEffect(() => {
    const inicializar = async () => {
      const token = getToken();
      if (!token) {
        setEstado((prev) => ({ ...prev, loading: false }));
        return;
      }
      const sessaoApi = await fetchSession().catch(() => null);
      if (sessaoApi) {
        setEstado((prev) => ({
          ...prev,
          usuario: sessaoApi.usuario,
          contexto: sessaoApi.contexto,
          contextosDisponiveis: sessaoApi.contextos || [],
          sessao: sessaoApi.contexto?.id_sessao_usuario || null,
          permissoes: normalizePermissoes(sessaoApi.permissoes),
          isAuthenticated: true,
          loading: false,
        }));
        return;
      }
      const dados = getUserData() || {};
      setEstado((prev) => ({
        ...prev,
        usuario: dados.usuario,
        sessao: dados.sessao || dados.contexto?.id_sessao_usuario || null,
        contexto: dados.contexto,
        contextosDisponiveis: dados.contextos || [],
        permissoes: normalizePermissoes(dados.permissoes),
        isAuthenticated: !!dados.token,
        loading: false,
      }));
    };
    inicializar();
  }, []);

  const hydrateSession = useCallback((sessao) => {
    if (!sessao) return;
    setEstado((prev) => ({
      ...prev,
      usuario: sessao.usuario,
      sessao: sessao.contexto?.id_sessao_usuario || sessao.sessao,
      contexto: sessao.contexto,
      contextosDisponiveis: sessao.contextos || prev.contextosDisponiveis,
      permissoes: normalizePermissoes(sessao.permissoes),
      isAuthenticated: true,
      loading: false,
    }));
  }, []);

  const login = useCallback(async (loginValue, senha, opcoes = {}) => {
    const resultado = await loginService.login({ usuario: loginValue, senha, ...opcoes });

    // Caso precise selecionar contexto
    if (!resultado.sucesso && resultado.erro === "SELECIONE_CONTEXTO") {
      sessionStorage.setItem("pending_context", JSON.stringify({
        usuario: loginValue,
        senha,
        contextos: resultado.contextos || []
      }));
      return { sucesso: false, erro: "SELECIONE_CONTEXTO", contextos: resultado.contextos || [] };
    }

    if (resultado.sucesso) {
      const sessaoApi = await fetchSession().catch(() => null);
      hydrateSession(sessaoApi || resultado);
      return { sucesso: true, ...resultado };
    }
    return { sucesso: false, erro: resultado.erro };
  }, [hydrateSession]);

  const logout = useCallback(() => {
    logoutFull();
    sessionStorage.removeItem("pending_context");
    setEstado({
      usuario: null,
      sessao: null,
      contexto: null,
      contextosDisponiveis: [],
      permissoes: [],
      isAuthenticated: false,
      loading: false,
    });
  }, []);

  const selecionarContexto = useCallback((ctx) => {
    setEstado((prev) => ({
      ...prev,
      contexto: ctx,
      permissoes: ctx?.permissoes || [],
      contextosDisponiveis: prev.contextosDisponiveis,
      isAuthenticated: true,
    }));
  }, []);

  const hasPermission = useCallback(
    (permissao) => estado.permissoes.some(
      (p) => p.codigo === permissao || p.acao_frontend === permissao
    ),
    [estado.permissoes]
  );

  const value = {
    usuario: estado.usuario,
    sessao: estado.sessao,
    contexto: estado.contexto,
    contextosDisponiveis: estado.contextosDisponiveis,
    permissoes: estado.permissoes,
    isAuthenticated: estado.isAuthenticated,
    loading: estado.loading,

    login,
    hydrateSession,
    logout,
    selecionarContexto,
    setContextosDisponiveis: (ctxs) => setEstado((prev) => ({ ...prev, contextosDisponiveis: ctxs || [] })),
    setPermissoes: (perms) => setEstado((prev) => ({ ...prev, permissoes: normalizePermissoes(perms || []) })),
    hasPermission,
    getToken,
  };

  return <AppContext.Provider value={value}>{children}</AppContext.Provider>;
}

export default AppContext;

export function useApp() {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error("useApp deve ser usado dentro de AppProvider");
  }
  return context;
}
