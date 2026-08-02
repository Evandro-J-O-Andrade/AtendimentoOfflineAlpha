import { useState } from 'react'
import { createApiClient, createAuthApi } from '@atendimentooffline/api'
import type { LoginResponseContract } from '@atendimentooffline/contracts'

export interface UseTotemAuthReturn {
  loading: boolean
  erro: string
  sessao: LoginResponseContract['session'] | null
  login: (username: string, password: string) => Promise<void>
  logout: () => Promise<void>
}

export function useTotemAuth(config: { apiUrl: string }): UseTotemAuthReturn {
  const [loading, setLoading] = useState(false)
  const [erro, setErro] = useState('')
  const [sessao, setSessao] = useState<LoginResponseContract['session'] | null>(null)

  const api = useState(() => createApiClient({ baseUrl: config.apiUrl }))[0]
  const authApi = useState(() => createAuthApi(api))[0]

  async function login(username: string, password: string) {
    setLoading(true)
    setErro('')

    try {
      const response = await authApi.login({ username, password })

      if (!response.authenticated || !response.session) {
        setErro(response.message ?? 'Falha na autenticacao.')
        return
      }

      setSessao(response.session)
    } catch {
      setErro('Erro de comunicacao com o servidor.')
    } finally {
      setLoading(false)
    }
  }

  async function logout() {
    try {
      await authApi.logout()
    } catch {
      // silencioso
    } finally {
      setSessao(null)
    }
  }

  return {
    loading,
    erro,
    sessao,
    login,
    logout
  }
}
