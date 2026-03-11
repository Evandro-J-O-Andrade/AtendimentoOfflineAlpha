import React, { createContext, useState, useContext, useEffect } from "react";

const AuthContext = createContext();

export function AuthProvider({ children }) {
  const [usuario, setUsuario] = useState(null);
  const [sessao, setSessao] = useState(null);
  const [runtime, setRuntime] = useState(null);
  const [contexto, setContexto] = useState(null);
  const [contextos, setContextos] = useState([]);
  const [permissoes, setPermissoes] = useState([]);
  const [fila, setFila] = useState(null);
  const [loading, setLoading] = useState(true);

  // Carregar dados do localStorage ao iniciar (offline-first)
  useEffect(() => {
    const storage = localStorage.getItem("hispa_auth");
    if (storage) {
      try {
        const dados = JSON.parse(storage);
        setUsuario(dados.usuario);
        setSessao(dados.sessao);
        setRuntime(dados.runtime);
        setContexto(dados.contexto);
        setContextos(dados.contextos || []);
        setPermissoes(dados.permissoes || []);
        setFila(dados.fila || null);
      } catch (e) {
        console.error("Erro ao carregar dados offline:", e);
      }
    }
    setLoading(false);
  }, []);

  const login = (dados) => {
    setUsuario(dados.usuario);
    setSessao(dados.sessao);
    setRuntime(dados.runtime);
    setContexto(dados.contexto);
    setContextos(dados.contextos || []);
    setPermissoes(dados.permissoes || []);
    setFila(dados.fila || null);

    // Salvar offline em uma única chave
    localStorage.setItem(
      "hispa_auth",
      JSON.stringify({
        usuario: dados.usuario,
        sessao: dados.sessao,
        runtime: dados.runtime,
        contexto: dados.contexto,
        contextos: dados.contextos || [],
        permissoes: dados.permissoes || [],
        fila: dados.fila || null
      })
    );
  };

  const logout = () => {
    setUsuario(null);
    setSessao(null);
    setRuntime(null);
    setContexto(null);
    setContextos([]);
    setPermissoes([]);
    setFila(null);
    localStorage.removeItem("hispa_auth");
  };

  // Trocar contexto operacional
  const trocarContexto = (novoContexto) => {
    setContexto(novoContexto);
    // Atualizar no localStorage
    const storage = localStorage.getItem("hispa_auth");
    if (storage) {
      const dados = JSON.parse(storage);
      dados.contexto = novoContexto;
      localStorage.setItem("hispa_auth", JSON.stringify(dados));
    }
  };

  // Verificar se tem permissão
  const hasPermission = (permissao) => {
    return permissoes.includes(permissao);
  };

  // Verificar se tem perfil
  const hasPerfil = (perfil) => {
    if (!runtime) return false;
    return runtime.some(p => 
      p.perfil.toUpperCase().includes(perfil.toUpperCase())
    );
  };

  // Pegar contextos de um perfil específico
  const getContextosByPerfil = (perfilNome) => {
    if (!runtime) return [];
    const perfil = runtime.find(p => 
      p.perfil.toUpperCase().includes(perfilNome.toUpperCase())
    );
    return perfil ? perfil.contextos : [];
  };

  // Pegar filas de um perfil específico
  const getFilasByPerfil = (perfilNome) => {
    if (!runtime) return [];
    const perfil = runtime.find(p => 
      p.perfil.toUpperCase().includes(perfilNome.toUpperCase())
    );
    return perfil ? perfil.filas : [];
  };

  // Pegar especialidades de um perfil específico
  const getEspecialidadesByPerfil = (perfilNome) => {
    if (!runtime) return [];
    const perfil = runtime.find(p => 
      p.perfil.toUpperCase().includes(perfilNome.toUpperCase())
    );
    return perfil ? perfil.especialidades : [];
  };

  return (
    <AuthContext.Provider value={{ 
      usuario, 
      sessao, 
      runtime, 
      contexto, 
      contextos, 
      permissoes,
      fila,
      loading,
      login, 
      logout,
      trocarContexto,
      hasPermission,
      hasPerfil,
      getContextosByPerfil,
      getFilasByPerfil,
      getEspecialidadesByPerfil
    }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);
