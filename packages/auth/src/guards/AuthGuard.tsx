/**
 * AuthGuard
 *
 * Componente de guarda de rota para proteção de conteúdo autenticado.
 * Renderiza `fallback` quando o usuário não está autenticado ou
 * enquanto a autenticação está sendo verificada; caso contrário,
 * renderiza os filhos.
 *
 * @module auth
 * @see useAuth
 * @see AuthProvider
 */

import type { ReactNode } from 'react'
import { useAuth } from '../hooks/useAuth'

/**
 * Propriedades aceitas pelo AuthGuard.
 */
export interface AuthGuardProps {
  children: ReactNode
  fallback?: ReactNode
}

/**
 * Guarda de autenticação.
 *
 * @param props - Propriedades do componente.
 * @returns Componente React condicional baseado no estado de autenticação.
 */
export function AuthGuard({ children, fallback = null }: AuthGuardProps) {
  const { authenticated, loading } = useAuth()
  if (loading) return null
  if (!authenticated) return <>{fallback}</>
  return <>{children}</>
}
