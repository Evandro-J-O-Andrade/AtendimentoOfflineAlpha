import React, { useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { useAuth } from './AuthContext.jsx'
import { apiErrorMessage } from '../../shared/api/http.js'

export default function LoginPage() {
  const [login, setLogin] = useState('')
  const [senha, setSenha] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState(null)
  const { login: doLogin } = useAuth()
  const navigate = useNavigate()
  const location = useLocation()

  async function handleSubmit(e) {
    e.preventDefault()
    setError(null)
    setSubmitting(true)
    try {
      await doLogin(login.trim(), senha)
      const dest = location.state?.from || '/contexto'
      navigate(dest, { replace: true })
    } catch (err) {
      setError(err)
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="container" style={{ maxWidth: 520 }}>
      <div className="card">
        <h2 style={{ marginTop: 0 }}>Acesso</h2>
        <p style={{ opacity: 0.85, marginTop: 0 }}>
          Entre e selecione o contexto operacional (sistema, unidade e local).
        </p>

        {error ? <div className="alert" style={{ marginBottom: 12 }}>{apiErrorMessage(error)}</div> : null}

        <form className="grid" onSubmit={handleSubmit}>
          <div className="grid">
            <label>
              Login
              <input className="input" value={login} onChange={(e) => setLogin(e.target.value)} autoComplete="username" />
            </label>
          </div>

          <div className="grid">
            <label>
              Senha
              <input className="input" type="password" value={senha} onChange={(e) => setSenha(e.target.value)} autoComplete="current-password" />
            </label>
          </div>

          <button className="btn" disabled={submitting || !login || !senha}>
            {submitting ? 'Entrando...' : 'Entrar'}
          </button>
        </form>
      </div>
    </div>
  )
}
