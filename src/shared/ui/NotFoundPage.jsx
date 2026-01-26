import React from 'react'
import { Link } from 'react-router-dom'

export default function NotFoundPage() {
  return (
    <div className="container" style={{ maxWidth: 720 }}>
      <div className="card">
        <h2 style={{ marginTop: 0 }}>Página não encontrada</h2>
        <p style={{ opacity: 0.85 }}>A rota solicitada não existe.</p>
        <Link className="btn" to="/contexto">Voltar</Link>
      </div>
    </div>
  )
}
