import { useState } from 'react'
import { useAuth } from '@atendimentooffline/auth'
import type { LoginRequestContract } from '@atendimentooffline/contracts'
import type { AuthenticationState } from '@atendimentooffline/contracts'

export function LoginPage() {
  const { login, loading, authenticated } = useAuth()
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [mfaCode, setMfaCode] = useState('')
  const [authState, setAuthState] = useState<AuthenticationState>('UNAUTHENTICATED')

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)

    const request: LoginRequestContract = {
      username,
      password,
      tenant: undefined,
      mfaCode: mfaCode || undefined
    }

    try {
      const response = await login(request)
      setAuthState(response.state)
      setError(response.message ?? null)
    } catch (err) {
      setError('Erro de conexão')
      setAuthState('ERROR')
    }
  }

  if (loading && authState === 'AUTHENTICATING') {
    return (
      <div>
        <h1>Autenticando...</h1>
      </div>
    )
  }

  if (authenticated) {
    return (
      <div>
        <h1>Redirecionando...</h1>
      </div>
    )
  }

  if (authState === 'MFA_REQUIRED') {
    return (
      <form onSubmit={handleSubmit}>
        <h1>MFA</h1>
        <input
          type="text"
          value={mfaCode}
          onChange={(e) => setMfaCode(e.target.value)}
          placeholder="Código MFA"
        />
        <button type="submit">Confirmar</button>
        {error && <p>{error}</p>}
      </form>
    )
  }

  return (
    <form onSubmit={handleSubmit}>
      <h1>Login</h1>
      <input
        type="text"
        value={username}
        onChange={(e) => setUsername(e.target.value)}
        placeholder="Usuário"
      />
      <input
        type="password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        placeholder="Senha"
      />
      <button type="submit" disabled={loading}>Entrar</button>
      {error && <p>{error}</p>}
    </form>
  )
}
