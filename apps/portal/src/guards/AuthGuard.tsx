import { useAuth } from '@atendimentooffline/auth'
import type { ReactNode } from 'react'

/**
 * Auth Guard
 *
 * Componente de proteção de rota que renderiza children apenas
 * se o usuário estiver autenticado.
 *
 * @param props.children - Nós filhos protegidos por autenticação.
 * @returns Conteúdo protegido ou null se não autenticado.
 *
 * @see {@link NavigationController}
 * @see {@link ContextGuard}
 */
export function AuthGuard({ children }: { children: ReactNode }) {
  const { authenticated } = useAuth()
  if (!authenticated) {
    return null
  }
  return <>{children}</>
}
