import axios from "axios";

const API_BASE = "http://localhost:3001/api"; // Backend HIS/PA

// Função exportada para compatibilidade (alias para loginService.login)
export async function loginFull(login, senha, contexto = {}) {
  return loginService.login({ login, senha, ...contexto });
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
  return data.permissoes.includes(permissao);
}

export function hasPerfil(perfil) {
  const data = loginService.getUserData();
  if (!data || !data.runtime) return false;
  return data.runtime.some(p => 
    p.perfil.toUpperCase().includes(perfil.toUpperCase())
  );
}

export const loginService = {
  /**
   * Login completo com credenciais
   * Retorna token JWT, runtime, contextos, permissoes
   */
  login: async (credentials) => {
    try {
      const response = await axios.post(`${API_BASE}/auth/login`, credentials);
      
      if (response.data?.token) {
        // Salvar token no storage local
        localStorage.setItem("token_his", response.data.token);
        localStorage.setItem("hispa_auth", JSON.stringify(response.data));
        
        return response.data;
      }
      
      return { error: "Erro ao logar", sucesso: false };
    } catch (err) {
      console.error("loginService error:", err);
      return { 
        error: err.response?.data?.error || "Erro de conexão",
        sucesso: false 
      };
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
      const response = await axios.get(`${API_BASE}/auth/runtime`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      return response.data;
    } catch (err) {
      console.error("getRuntime error:", err);
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
      const response = await axios.post(
        `${API_BASE}/auth/sync`,
        {},
        { headers: { Authorization: `Bearer ${token}` } }
      );
      
      if (response.data?.runtime) {
        // Atualizar cache local
        const dadosAtuais = JSON.parse(localStorage.getItem("hispa_auth") || "{}");
        const dadosMerge = {
          ...dadosAtuais,
          runtime: response.data.runtime,
          contexto: response.data.contexto,
          contextos: response.data.contextos,
          permissoes: response.data.permissoes
        };
        localStorage.setItem("hispa_auth", JSON.stringify(dadosMerge));
        return { success: true, data: response.data };
      }
      
      return { success: false, reason: "no_runtime" };
    } catch (err) {
      console.error("sync error:", err);
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
    return !!localStorage.getItem("token_his");
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
  }
};

export default loginService;
