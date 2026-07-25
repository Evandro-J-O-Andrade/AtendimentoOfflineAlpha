/**
 * AuthProvider
 *
 * Provedor de autenticação global da aplicação. Gerencia sessão,
 * login, refresh, logout e seleção de contexto (unidade/perfil/sala).
 * Disponibiliza o contexto de autenticação via React Context API.
 *
 * @module auth
 * @see AuthContextValue
 * @see useAuth
 */

import { createContext, useState, useCallback, useEffect, type ReactNode } from 'react'
import type { ApiClient } from '@atendimentooffline/api'
import { createApiClient, createAuthApi, type ContextResponse } from '@atendimentooffline/api'
import type { AuthSessionContract, LoginRequestContract, LoginResponseContract } from '@atendimentooffline/contracts'
import { resolveSession } from './SessionResolver'

/**
 * Valor exposto pelo AuthContext.
 */
export interface AuthContextValue {
  session: AuthSessionContract | null
  loading: boolean
  authenticated: boolean
  login: (request: LoginRequestContract) => Promise<LoginResponseContract>
  refresh: () => Promise<void>
  logout: () => Promise<void>
  selectContext: (idUnidade: number, idPerfil: number, idLocal?: number) => Promise<void>
  context: {
    unidades: Array<{ id_unidade: number; nome_unidade: string }>
    perfis: Array<{ id_perfil: number; nome_perfil: string; id_unidade: number }>
    salas: Array<{ id_sala: number; nome_sala: string; id_unidade: number }>
  } | null
  contextLoading: boolean
}

/**
 * Contexto de autenticação da aplicação.
 * @type {React.Context<AuthContextValue | null>}
 */
export const AuthContext = createContext<AuthContextValue | null>(null)

/**
 * Propriedades aceitas pelo AuthProvider.
 */
export interface AuthProviderProps {
  children: ReactNode
  apiClient?: ApiClient
  baseUrl?: string
}

/**
 * Provedor de autenticação.
 *
 * @param props - Propriedades do provedor.
 * @returns Elemento React com o provedor de contexto.
 */
export function AuthProvider({ children, apiClient, baseUrl = '' }: AuthProviderProps) {
  const api = apiClient ?? createApiClient({ baseUrl })
  const authApi = createAuthApi(api)
  const [session, setSession] = useState<AuthSessionContract | null>(null)
  const [loading, setLoading] = useState<boolean>(true)
  const [context, setContext] = useState<ContextResponse | null>(null)
  const [contextLoading, setContextLoading] = useState<boolean>(false)

  useEffect(() => {
    if (!session?.id_sessao_usuario) {
      setContext(null)
      return
    }
    let cancelled = false
    setContextLoading(true)
    authApi.context(session.id_sessao_usuario)
      .then((res) => {
        if (!cancelled) {
          setContext(res)
        }
      })
      .catch(() => {
        if (!cancelled) {
          setContext(null)
        }
      })
      .finally(() => {
        if (!cancelled) {
          setContextLoading(false)
        }
      })
    return () => {
      cancelled = true
    }
  }, [api, authApi, session])

  const login = useCallback(async (request: LoginRequestContract) => {
    setLoading(true)
    const response = await authApi.login(request)
    if (response.authenticated && response.session) {
      setSession(response.session)
    }
    return response
  }, [authApi])

  const refresh = useCallback(async () => {
    setLoading(true)
    try {
      const next = await resolveSession(api)
      setSession(next)
    } finally {
      setLoading(false)
    }
  }, [api])

  const logout = useCallback(async () => {
    await authApi.logout()
    setSession(null)
  }, [authApi])

  const selectContext = useCallback(async (idUnidade: number, idPerfil: number, idLocal?: number) => {
    if (!session?.id_sessao_usuario) {
      return
    }

    setLoading(true)
    try {
      const response = await authApi.selectContext(session.id_sessao_usuario, idUnidade, idPerfil, idLocal)
      if (response.session) {
        setSession(response.session)
      }
    } finally {
      setLoading(false)
    }
  }, [authApi, session])

  return (
    <AuthContext.Provider
      value={{ session, loading, authenticated: Boolean(session?.authenticated), login, refresh, logout, selectContext, context: context ?? null, contextLoading }}
    >
      {children}
    </AuthContext.Provider>
  )
}
