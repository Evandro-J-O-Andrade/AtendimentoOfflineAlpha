import type { ReactNode } from 'react'
import { useAuth } from '../hooks/useAuth'

export interface AuthGuardProps {
  children: ReactNode
  fallback?: ReactNode
}

export function AuthGuard({ children, fallback = null }: AuthGuardProps) {
  const { authenticated, loading } = useAuth()
  if (loading) return null
  if (!authenticated) return <>{fallback}</>
  return <>{children}</>
}
