import React from 'react'
import { Navigate, useLocation } from 'react-router-dom'
import { useContextoAtendimento } from '../../features/contexto/ContextoAtendimentoContext.jsx'

export default function RequireContexto({ children }) {
  const { contexto, loading } = useContextoAtendimento()
  const location = useLocation()

  if (loading) return <div className="container"><div className="alert">Carregando contexto...</div></div>
  if (!contexto) return <Navigate to="/contexto" replace state={{ from: location.pathname }} />
  return children
}
