import { usePortalRuntime } from '../runtime/usePortalRuntime'
import type { ReactNode } from 'react'

export function ContextGuard({ children }: { children: ReactNode }) {
  const rt = usePortalRuntime()
  const hasContext = Boolean(rt.context)
  if (!hasContext) {
    return null
  }
  return <>{children}</>
}
