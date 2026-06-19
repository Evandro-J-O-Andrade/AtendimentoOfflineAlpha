import api from "../api/api";
import spApi from "../api/spApi";
const { execute } = spApi;

// ============================================================
// FLUXO CANÔNICO DE AUTENTICAÇÃO
// LOGIN → CONTEXTO_GET → CONTEXTO_SET → ASSERT → SISTEMA
// ============================================================

function buildError(err) {
  return {
    erro: err?.response?.data?.erro || err?.response?.data?.error || "ERRO_DE_CONEXAO",
    sucesso: false,
  };
}

// ============================================================
// 1. LOGIN - Autentica usuário e cria sessão SEM contexto
// ============================================================
export async function loginFull(usuario, senha) {
  try {
    // Gerar token JWT temporário para validação
    // O backend vai validar a senha e gerar o token real
    const tempToken = `temp_${Date.now()}`;
    
    // Chamar sp_master_login via spApi
    // A senha será validada pelo backend
    const result = await execute({
      modulo: 'AUTH',
      acao: 'LOGIN',
      payload: {
        login: usuario,
        senha: senha,  // Usado pelo backend para validar
        token_jwt: tempToken,
        ip: '0.0.0.0',
        device: 'web'
      }
    });

    if (result.ok && result.data?.sessao) {
      // Salvar dados da sessão
      const sessao = result.data.sessao;
      localStorage.setItem('id_sessao', String(sessao.id_sessao_usuario));
      localStorage.setItem('token', sessao.token || '');
      localStorage.setItem('uuid_sessao', sessao.uuid_sessao || '');
      
      // Retornar indicando que contexto precisa ser definido
      return {
        sucesso: true,
        sessao: sessao,
        contexto_definido: sessao.contexto_definido || false,
       需要_selecionar_contexto: true
      };
    }

    return {
      sucesso: false,
      erro: result.erro || 'LOGIN_FALHOU'
    };
  } catch (err) {
    console.error("loginFull error:", err);
    return buildError(err);
  }
}

// ============================================================
// 2. CONTEXTO_GET - Lista opções disponíveis do usuário
// ============================================================
export async function getContextos() {
  const id_sessao = localStorage.getItem('id_sessao');
  
  if (!id_sessao) {
    return { sucesso: false, erro: 'SESSAO_NAO_ENCONTRADA' };
  }

  try {
    // Chamar sp_master_login com ação CONTEXTO_GET
    const result = await execute({
      modulo: 'AUTH',
      acao: 'CONTEXTO_GET',
      payload: {
        id_sessao: parseInt(id_sessao)
      }
    });

    if (result.ok && result.data) {
      return {
        sucesso: true,
        unidades: result.data.unidades || [],
        locais: result.data.locais || [],
        perfis: result.data.perfis || [],
        contexto_atual: result.data.contexto_atual
      };
    }

    return {
      sucesso: false,
      erro: result.erro || 'ERRO_AO_BUSCAR_CONTEXTOS'
    };
  } catch (err) {
    console.error("getContextos error:", err);
    return buildError(err);
  }
}

// ============================================================
// 3. CONTEXTO_SET - Define o contexto da sessão
// ============================================================
export async function setContexto(id_unidade, id_local, id_perfil) {
  const id_sessao = localStorage.getItem('id_sessao');
  
  if (!id_sessao) {
    return { sucesso: false, erro: 'SESSAO_NAO_ENCONTRADA' };
  }

  try {
    // Chamar sp_master_login com ação CONTEXTO_SET
    const result = await execute({
      modulo: 'AUTH',
      acao: 'CONTEXTO_SET',
      payload: {
        id_sessao: parseInt(id_sessao),
        id_unidade: id_unidade,
        id_local: id_local, // pode ser 0 ou null = sem sala
        id_perfil: id_perfil
      }
    });

    if (result.ok && result.data) {
      // Salvar contexto ativo
      const contexto = {
        id_unidade,
        id_local,
        id_perfil
      };
      localStorage.setItem('contexto_ativo', JSON.stringify(contexto));
      
      // Atualizar token se veio novo
      if (result.data.token) {
        localStorage.setItem('token', result.data.token);
      }
      
      return {
        sucesso: true,
        contexto_definido: true,
        id_unidade,
        id_local,
        id_perfil
      };
    }

    return {
      sucesso: false,
      erro: result.erro || 'ERRO_AO_DEFINIR_CONTEXTO'
    };
  } catch (err) {
    console.error("setContexto error:", err);
    return buildError(err);
  }
}

// ============================================================
// 4. ASSERT - Valida sessão e contexto antes de acessar
// ============================================================
export async function validarSessao() {
  const id_sessao = localStorage.getItem('id_sessao');
  
  if (!id_sessao) {
    return { sucesso: false, erro: 'SESSAO_NAO_ENCONTRADA' };
  }

  try {
    // Chamar sp_master_login com ação ASSERT
    const result = await execute({
      modulo: 'AUTH',
      acao: 'ASSERT',
      payload: {
        id_sessao: parseInt(id_sessao)
      }
    });

    return {
      sucesso: result.ok,
      erro: result.erro || (result.ok ? null : 'SESSAO_INVALIDA')
    };
  } catch (err) {
    console.error("validarSessao error:", err);
    return { sucesso: false, erro: 'ERRO_DE_CONEXAO' };
  }
}

// ============================================================
// LOGOUT - Encerra sessão
// ============================================================
export async function logoutFull() {
  const id_sessao = localStorage.getItem('id_sessao');
  
  if (id_sessao) {
    try {
      await execute({
        modulo: 'AUTH',
        acao: 'LOGOUT',
        payload: { id_sessao: parseInt(id_sessao) }
      });
    } catch (e) {
      console.warn("Logout SP failed:", e);
    }
  }
  
  // Limpar dados locais
  localStorage.removeItem("token_his");
  localStorage.removeItem("hispa_auth");
  localStorage.removeItem("id_sessao");
  localStorage.removeItem("contexto_ativo");
  localStorage.removeItem("token");
  localStorage.removeItem("uuid_sessao");
}

// ============================================================
// Verificações
// ============================================================
export function isLoggedIn() {
  const token = localStorage.getItem("token_his");
  const id_sessao = localStorage.getItem("id_sessao");
  return !!(token || id_sessao);
}

export function getUserData() {
  const data = localStorage.getItem("hispa_auth");
  if (!data) return null;
  try {
    return JSON.parse(data);
  } catch {
    return null;
  }
}

export function getToken() {
  return localStorage.getItem("token_his");
}

export function hasPermission(permissao) {
  const data = getUserData();
  if (!data || !data.permissoes) return false;
  return data.permissoes.some(
    (p) => p.codigo === permissao || p.acao_frontend === permissao
  );
}

export function hasPerfil(perfil) {
  const data = getUserData();
  if (!data || !data.runtime) return false;
  return data.runtime?.some(
    (p) => p?.perfil?.toUpperCase() === perfil.toUpperCase()
  );
}

// ============================================================
// Login Service Legacy (para compatibilidade)
// ============================================================
export const loginService = {
  login: async (credentials) => {
    const { usuario, senha } = credentials;
    return loginFull(usuario, senha);
  },
  
  assertContexto: async (idUnidade, idLocal, idPerfil) => {
    return setContexto(idUnidade, idLocal, idPerfil);
  },
  
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

  sync: async () => {
    const token = localStorage.getItem("token_his");
    if (!token) return { success: false, reason: "not_authenticated" };
    try {
      const response = await api.post(`/auth/sync`, {});
      if (response.data?.runtime) {
        let dadosAtuais = {};
        try {
          dadosAtuais = JSON.parse(localStorage.getItem("hispa_auth") || "{}");
        } catch {
          dadosAtuais = {};
        }
        const dadosMerge = { ...dadosAtuais, ...response.data };
        localStorage.setItem("hispa_auth", JSON.stringify(dadosMerge));
        return { success: true, data: response.data };
      }
      return { success: false, reason: "no_runtime" };
    } catch (err) {
      return { success: false, reason: err.message };
    }
  },

  logout: () => logoutFull(),

  isAuthenticated: () => isLoggedIn(),

  getUserData: () => getUserData(),

  getToken: () => getToken(),

  getRuntimeLocal: () => {
    const data = getUserData();
    return data?.runtime || [];
  },
};

export default loginService;
