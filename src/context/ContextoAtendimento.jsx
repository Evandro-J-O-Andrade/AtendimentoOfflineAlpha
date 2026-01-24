import { createContext, useContext, useEffect, useState } from 'react';

const ContextoAtendimentoContext = createContext(null);

export function ContextoAtendimentoProvider({ children }) {
  const [contexto, setContexto] = useState(() => {
    try {
      const raw = localStorage.getItem("contexto_atendimento");
      return raw ? JSON.parse(raw) : null;
    } catch {
      return null;
    }
  });

  useEffect(() => {
    try {
      if (contexto) localStorage.setItem("contexto_atendimento", JSON.stringify(contexto));
      else localStorage.removeItem("contexto_atendimento");
    } catch {
      // noop
    }
  }, [contexto]);

  function definirContexto(dados) {
    setContexto({
      usuario: {
        id: dados.usuarioId,
        nome: dados.nomeUsuario,
      },
      perfil: dados.perfil, // MEDICO | ENFERMAGEM | RECEPCAO
      local: dados.local,   // SALA_01 | GUICHE_02 | TRIAGEM | MEDICACAO
      especialidade: dados.especialidade || null,
      iniciadoEm: dados.iniciadoEm || new Date().toISOString(),
      rotaInicial: dados.rotaInicial || null
    });
  }

  function limparContexto() {
    setContexto(null);
  }

  return (
    <ContextoAtendimentoContext.Provider value={{ contexto, definirContexto, limparContexto }}>
      {children}
    </ContextoAtendimentoContext.Provider>
  );
}

export function useContextoAtendimento() {
  const context = useContext(ContextoAtendimentoContext);
  if (!context) {
    throw new Error('useContextoAtendimento deve ser usado dentro do ContextoAtendimentoProvider');
  }
  return context;
}
