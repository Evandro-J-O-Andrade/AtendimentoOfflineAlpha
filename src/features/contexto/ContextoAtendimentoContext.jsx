import React, { createContext, useContext, useEffect, useMemo, useState } from 'react'
import { abrirSessao, encerrarSessao, listarContextos } from './contextoApi.js'
import { apiErrorMessage } from '../../shared/api/http.js'

const Ctx = createContext(null)
const STORAGE_KEY = 'alpha:contexto'

export function ContextoProvider({ children }) {
  const [contexto, setContexto] = useState(null)
  const [contextosDisponiveis, setContextosDisponiveis] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (raw) {
      try {
        const parsed = JSON.parse(raw)
        if (parsed) setContexto(parsed)
      } catch {
        localStorage.removeItem(STORAGE_KEY)
      }
    }
    setLoading(false)
  }, [])

  async function refreshContextos() {
    setError(null)
    const list = await listarContextos()
    setContextosDisponiveis(Array.isArray(list) ? list : [])
    return list
  }

  async function selecionarContexto(c) {
    setError(null)
    // abre sessão no backend (auditoria amarrada)
    const res = await abrirSessao({
      id_sistema: c.id_sistema,
      id_unidade: c.id_unidade,
      id_local: c.id_local
    })

    const ctx = res.contexto || {
      id_sistema: c.id_sistema,
      id_unidade: c.id_unidade,
      id_local: c.id_local,
      sistema: c.sistema,
      unidade: c.unidade,
      local: c.local,
      perfil: c.perfil,
      sessao_id: res.sessao_id
    }

    setContexto(ctx)
    localStorage.setItem(STORAGE_KEY, JSON.stringify(ctx))
    return ctx
  }

  async function limparContexto() {
    try {
      await encerrarSessao()
    } catch {
      // não impede limpeza local
    }
    localStorage.removeItem(STORAGE_KEY)
    setContexto(null)
  }

  const value = useMemo(
    () => ({
      contexto,
      contextosDisponiveis,
      loading,
      error,
      errorMessage: error ? apiErrorMessage(error) : null,
      refreshContextos,
      selecionarContexto,
      limparContexto
    }),
    [contexto, contextosDisponiveis, loading, error]
  )

  return <Ctx.Provider value={value}>{children}</Ctx.Provider>
}

export function useContextoAtendimento() {
  const ctx = useContext(Ctx)
  if (!ctx) throw new Error('useContextoAtendimento deve ser usado dentro de ContextoProvider')
  return ctx
}
