import { createContext, useContext, useState } from 'react'

const ContextoAtendimentoContext = createContext(null)

export function ContextoAtendimentoProvider({ children }) {
  const [contexto, setContexto] = useState(null)

  function definirContexto(dados) {
    setContexto({
      // QUEM
      usuario: {
        id: dados.usuarioId,
        nome: dados.nomeUsuario,
      },

      // FUNÇÃO ATIVA
      perfil: dados.perfil, // MEDICO | ENFERMAGEM | TECNICO | RECEPCAO

      // ONDE
      local: dados.local, // SALA_01 | GUICHE_02 | TRIAGEM | MEDICACAO

      // DETALHES
      especialidade: dados.especialidade || null,

      // CONTROLE
      iniciadoEm: dados.iniciadoEm || new Date().toISOString(),

      // UX / NAVEGAÇÃO
      rotaInicial: dados.rotaInicial || null
    })
  }

  function limparContexto() {
    setContexto(null)
  }

  return (
    <ContextoAtendimentoContext.Provider
      value={{
        contexto,
        definirContexto,
        limparContexto
      }}
    >
      {children}
    </ContextoAtendimentoContext.Provider>
  )
}

export function useContextoAtendimento() {
  const context = useContext(ContextoAtendimentoContext)
  if (!context) {
    throw new Error(
      'useContextoAtendimento deve ser usado dentro do ContextoAtendimentoProvider'
    )
  }
  return context
}
