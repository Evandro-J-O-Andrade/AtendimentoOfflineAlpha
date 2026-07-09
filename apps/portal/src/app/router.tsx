import { createContext, useContext, useState, type ReactNode } from 'react'

export type RouteName = 'login' | 'context' | 'portal'

interface RouterContextValue {
  route: RouteName
  navigate: (route: RouteName) => void
}

const RouterContext = createContext<RouterContextValue | null>(null)

export function RouterProvider({ children }: { children?: ReactNode }) {
  const [route, setRoute] = useState<RouteName>('login')
  const navigate = (next: RouteName) => setRoute(next)

  return <RouterContext.Provider value={{ route, navigate }}>{children}</RouterContext.Provider>
}

export function useRouter(): RouterContextValue {
  const ctx = useContext(RouterContext)
  if (!ctx) throw new Error('useRouter deve ser usado dentro de <RouterProvider>')
  return ctx
}
