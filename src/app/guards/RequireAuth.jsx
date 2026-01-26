import React from 'react'
import { Navigate, useLocation } from 'react-router-dom'
import { useAuth } from '../../features/auth/AuthContext.jsx'

export default function RequireAuth({ children }) {
  const { token, loading } = useAuth()
  const location = useLocation()

  if (loading) return <div className="container"><div className="alert">Carregando sessão...</div></div>
  if (!token) return <Navigate to="/login" replace state={{ from: location.pathname }} />

  return children
}
