import type { ReactNode } from 'react'

/**
 * Guest Guard
 *
 * Componente de proteção para rotas de usuário não autenticado.
 * Atualmente permite acesso livre (pass-through).
 *
 * @param props.children - Nós filhos para usuários não autenticados.
 * @returns Filhos sem restrição.
 *
 * @see {@link AuthGuard}
 */
export function GuestGuard({ children }: { children: ReactNode }) {
  return <>{children}</>
}
