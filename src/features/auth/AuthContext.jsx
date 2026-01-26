import React, { createContext, useContext, useEffect, useMemo, useState } from 'react'
import { apiErrorMessage, setAuthToken } from '../../shared/api/http.js'
import { loginRequest, meRequest } from './authApi.js'

const AuthCtx = createContext(null)

const STORAGE_KEY = 'alpha:auth'

export function AuthProvider({ children }) {
  const [token, setToken] = useState(null)
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (!raw) {
      setLoading(false)
      return
    }

    try {
      const parsed = JSON.parse(raw)
      if (parsed?.token) {
        setToken(parsed.token)
        setAuthToken(parsed.token)
        // tenta carregar /me para ter perfis e permissões
        meRequest()
          .then((res) => setUser(res.user || res))
          .catch(() => {
            // token inválido, limpa
            localStorage.removeItem(STORAGE_KEY)
            setToken(null)
            setUser(null)
            setAuthToken(null)
          })
          .finally(() => setLoading(false))
      } else {
        setLoading(false)
      }
    } catch {
      localStorage.removeItem(STORAGE_KEY)
      setLoading(false)
    }
  }, [])

  async function login(login, senha) {
    setError(null)
    const res = await loginRequest(login, senha)
    const newToken = res.token || res.access_token
    if (!newToken) throw new Error('Token não retornado pelo backend')

    setToken(newToken)
    setAuthToken(newToken)

    const u = res.user || res.usuario || null
    setUser(u)

    localStorage.setItem(STORAGE_KEY, JSON.stringify({ token: newToken }))
    return { token: newToken, user: u }
  }

  function logout() {
    localStorage.removeItem(STORAGE_KEY)
    setToken(null)
    setUser(null)
    setAuthToken(null)
  }

  const value = useMemo(
    () => ({
      token,
      user,
      loading,
      error,
      setError,
      login,
      logout,
      setUser
    }),
    [token, user, loading, error]
  )

  return <AuthCtx.Provider value={value}>{children}</AuthCtx.Provider>
}

export function useAuth() {
  const ctx = useContext(AuthCtx)
  if (!ctx) throw new Error('useAuth deve ser usado dentro de AuthProvider')
  return ctx
}

export function useAuthErrorMessage() {
  const { error } = useAuth()
  return error ? apiErrorMessage(error) : null
}
