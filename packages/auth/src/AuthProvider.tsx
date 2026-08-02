/**
 * AuthProvider
 *
 * Provedor de autenticação global da aplicação. Gerencia sessão,
 * login, refresh, logout e seleção de contexto (unidade/perfil/sala).
 * Disponibiliza o contexto de autenticação via React Context API.
 *
 * Fluxo canônico:
 *   Login → sp_master_login
 *     ↓
 *   sp_auth_contexto_get
 *     ↓
 *   ContextSelectionPage (usuário escolhe)
 *     ↓
 *   sp_auth_contexto_set
 *     ↓
 *   sp_sessao_contexto_get
 *     ↓
 *   Sessão completa → Portal
 *
 * @module auth
 * @see AuthContextValue
 * @see useAuth
 */

import { createContext, useState, useCallback, useEffect, type ReactNode } from 'react'
import type { ApiClient } from '@atendimentooffline/api'
import { createApiClient, createAuthApi, type ContextResponse } from '@atendimentooffline/api'
import type { AuthSessionContract, LoginRequestContract, LoginResponseContract, AuthenticationState } from '@atendimentooffline/contracts'
import { resolveSession } from './SessionResolver'

export interface AuthContextValue {
  session: AuthSessionContract | null
  loading: boolean
  authenticated: boolean
  authState: AuthenticationState
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
  markPortalReady: () => void
}

export const AuthContext = createContext<AuthContextValue | null>(null)

export interface AuthProviderProps {
  children: ReactNode
  apiClient?: ApiClient
  baseUrl?: string
}

export function AuthProvider({ children, apiClient, baseUrl = '' }: AuthProviderProps) {
  const api = apiClient ?? createApiClient({ baseUrl })
  const authApi = createAuthApi(api)
  const [session, setSession] = useState<AuthSessionContract | null>(null)
  const [loading, setLoading] = useState<boolean>(true)
  const [authState, setAuthState] = useState<AuthenticationState>('UNAUTHENTICATED')
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
          if (authState !== 'SESSION_READY' && authState !== 'PORTAL_READY') {
            setAuthState('CONTEXT_REQUIRED')
          }
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
  }, [api, authApi, session, authState])

  const login = useCallback(async (request: LoginRequestContract) => {
    setLoading(true)
    setAuthState('AUTHENTICATING')
    try {
      const response = await authApi.login(request)
      if (response.authenticated && response.session) {
        setSession(response.session)
        setAuthState('AUTHENTICATED')
      } else {
        setAuthState('ERROR')
      }
      return response
    } catch {
      setAuthState('ERROR')
      return { authenticated: false, state: 'ERROR' as const, message: 'ERRO_CONEXAO' }
    } finally {
      setLoading(false)
    }
  }, [authApi])

  const refresh = useCallback(async () => {
    setLoading(true)
    try {
      const next = await resolveSession(api)
      setSession(next)
      setAuthState('SESSION_RESTORED')
    } finally {
      setLoading(false)
    }
  }, [api])

  const logout = useCallback(async () => {
    await authApi.logout()
    setSession(null)
    setContext(null)
    setAuthState('UNAUTHENTICATED')
  }, [authApi])

  const validateSessionCompleteness = useCallback((sessao: AuthSessionContract): boolean => {
    return Boolean(
      sessao.id_sessao_usuario &&
      sessao.id_usuario &&
      sessao.id_entidade &&
      sessao.id_unidade &&
      sessao.id_local &&
      sessao.id_perfil
    )
  }, [])

  const selectContext = useCallback(async (idUnidade: number, idPerfil: number, idLocal?: number) => {
    if (!session?.id_sessao_usuario) {
      return
    }

    setLoading(true)
    try {
      const response = await authApi.selectContext(session.id_sessao_usuario, idUnidade, idPerfil, idLocal)
      
      if (response.session) {
        const fullSession = await authApi.session(session.id_sessao_usuario)
        
        if (!validateSessionCompleteness(fullSession)) {
          throw new Error('Sessão operacional incompleta após contexto.')
        }
        
        setSession(fullSession)
        setAuthState('SESSION_READY')
      }
    } catch (error) {
      console.error('Erro ao selecionar contexto:', error)
      throw error
    } finally {
      setLoading(false)
    }
  }, [authApi, session, validateSessionCompleteness])

  const markPortalReady = useCallback(() => {
    setAuthState('PORTAL_READY')
  }, [])

  return (
    <AuthContext.Provider
      value={{
        session,
        loading,
        authenticated: Boolean(session?.authenticated),
        authState,
        login,
        refresh,
        logout,
        selectContext,
        context: context ?? null,
        contextLoading,
        markPortalReady
      }}
    >
      {children}
    </AuthContext.Provider>
  )
}
