import { useState, useContext, createContext, type ReactNode } from 'react'
import type { TotemRoute } from './routes'

interface RouterContextValue {
  route: TotemRoute
  navigate: (route: TotemRoute) => void
}

const RouterContext = createContext<RouterContextValue | null>(null)

export function TotemRouter({ children }: { children: ReactNode }) {
  const [route, setRoute] = useState<TotemRoute>('senha')

  return (
    <RouterContext.Provider value={{ route, navigate: setRoute }}>
      {children}
    </RouterContext.Provider>
  )
}

export function useTotemRouter(): RouterContextValue {
  const ctx = useContext(RouterContext)
  if (!ctx) throw new Error('useTotemRouter deve ser usado dentro de <TotemRouter>')
  return ctx
}
