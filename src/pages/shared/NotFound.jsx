import React from 'react'
import { Link } from 'react-router-dom'

export default function NotFound() {
  return (
    <div style={{ padding: 24 }}>
      <h1>404 — Página não encontrada</h1>
      <p>Não encontramos uma rota para este endereço.</p>
      <p>
        <Link to="/dashboard">Ir para Dashboard</Link> • <Link to="/login">Fazer login</Link>
      </p>
    </div>
  )
}
