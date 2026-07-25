import { usePortalRuntime } from '../runtime/usePortalRuntime'
import type { ReactNode } from 'react'

/**
 * Context Guard
 *
 * Componente de proteção que renderiza children apenas se houver
 * contexto operacional selecionado no runtime do Portal.
 *
 * @param props.children - Nós filhos protegidos por contexto operacional.
 * @returns Conteúdo protegido ou null se contexto ausente.
 *
 * @see {@link AuthGuard}
 * @see {@link ContextSelectionPage}
 */
export function ContextGuard({ children }: { children: ReactNode }) {
  const rt = usePortalRuntime()
  const hasContext = Boolean(rt.context)
  if (!hasContext) {
    return null
  }
  return <>{children}</>
}
