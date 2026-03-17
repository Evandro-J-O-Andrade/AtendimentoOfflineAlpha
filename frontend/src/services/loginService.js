import api from "../api/api";

// Função exportada para compatibilidade (alias para loginService.login)
export async function loginFull(usuario, senha, contexto = {}) {
  return loginService.login({ usuario, senha, ...contexto });
}

export async function logoutFull() {
  loginService.logout();
}

export async function isLoggedIn() {
  return loginService.isAuthenticated();
}

export function getUserData() {
  return loginService.getUserData();
}

export function getToken() {
  return loginService.getToken();
}

export function hasPermission(permissao) {
  const data = loginService.getUserData();
  if (!data || !data.permissoes) return false;
  return data.permissoes.some(
    (p) => p.codigo === permissao || p.acao_frontend === permissao
  );
}

export function hasPerfil(perfil) {
  const data = loginService.getUserData();
  if (!data || !data.runtime) return false;
  return data.runtime?.some(
    (p) => p?.perfil?.toUpperCase() === perfil.toUpperCase()
  );
}

function persistAuth(data) {
  if (!data?.token) return;
  localStorage.setItem("token_his", data.token);
  localStorage.setItem("hispa_auth", JSON.stringify(data));
}

function buildError(err) {
  return {
    erro: err?.response?.data?.erro || err?.response?.data?.error || "ERRO_DE_CONEXAO",
    sucesso: false,
  };
}

export const loginService = {
  /**
   * Login completo com credenciais
   * Retorna token JWT, runtime, contextos, permissoes
   */
  login: async (credentials) => {
    const payload = { ...credentials };
    if (credentials.login && !credentials.usuario) {
      payload.usuario = credentials.login;
    }

    try {
      const response = await api.post(`/auth/login`, payload);
      const data = response.data || {};

      if (data.sucesso && data.token) {
        persistAuth(data);
        return data;
      }

      return data.sucesso === false
        ? data
        : { sucesso: false, erro: "ERRO_DE_CONEXAO" };
    } catch (err) {
      console.error("loginService error:", err?.message || err);
      return buildError(err);
    }
  },

  /**
   * Busca runtime completo do backend
   * Usado para sincronização online
   */
  getRuntime: async () => {
    const token = localStorage.getItem("token_his");
    if (!token) return null;
    try {
      const response = await api.get(`/auth/runtime`);
      return response.data;
    } catch (err) {
      console.error("getRuntime error:", err?.message || err);
      return null;
    }
  },

  /**
   * Sincroniza runtime com backend
   * Usado para manter dados atualizados online
   */
  sync: async () => {
    const token = localStorage.getItem("token_his");
    if (!token) return { success: false, reason: "not_authenticated" };

    try {
      const response = await api.post(`/auth/sync`, {});

      if (response.data?.runtime) {
        // Atualizar cache local com tolerância a JSON corrompido
        let dadosAtuais = {};
        try {
          dadosAtuais = JSON.parse(localStorage.getItem("hispa_auth") || "{}");
        } catch {}

        const dadosMerge = {
          ...dadosAtuais,
          runtime: response.data.runtime,
          contexto: response.data.contexto,
          contextos: response.data.contextos,
          permissoes: response.data.permissoes,
        };
        localStorage.setItem("hispa_auth", JSON.stringify(dadosMerge));
        return { success: true, data: response.data };
      }

      return { success: false, reason: "no_runtime" };
    } catch (err) {
      console.error("sync error:", err?.message || err);
      return { success: false, reason: err.message };
    }
  },

  /**
   * Logout - limpa tokens e dados locais
   */
  logout: () => {
    localStorage.removeItem("token_his");
    localStorage.removeItem("hispa_auth");
  },

  /**
   * Verifica se está autenticado
   */
  isAuthenticated: () => {
    const token = localStorage.getItem("token_his");
    if (!token) return false;
    try {
      const payload = JSON.parse(atob(token.split(".")[1]));
      return payload?.exp * 1000 > Date.now();
    } catch {
      return true; // token mockado não tem exp
    }
  },

  /**
   * Pega dados do usuário do cache local
   */
  getUserData: () => {
    const data = localStorage.getItem("hispa_auth");
    if (!data) return null;
    try {
      return JSON.parse(data);
    } catch {
      return null;
    }
  },

  /**
   * Pega token atual
   */
  getToken: () => {
    return localStorage.getItem("token_his");
  },

  /**
   * Runtime local (offline-first)
   */
  getRuntimeLocal: () => {
    const data = loginService.getUserData();
    return data?.runtime || [];
  },
};

export default loginService;
