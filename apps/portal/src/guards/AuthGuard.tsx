import { useAuth } from '@atendimentooffline/auth'
import type { ReactNode } from 'react'

export function AuthGuard({ children }: { children: ReactNode }) {
  const { authenticated } = useAuth()
  if (!authenticated) {
    return null
  }
  return <>{children}</>
}
