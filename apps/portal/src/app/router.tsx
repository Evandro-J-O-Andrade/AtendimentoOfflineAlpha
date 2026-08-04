import { createContext, useContext, useState, type ReactNode } from 'react'
import { DiagnosticPage } from '../pages/DiagnosticPage'
import { LoginPage } from '../pages/Login/LoginPage'
import { HelpPage } from '../pages/Help/HelpPage'
import { ContextSelectionPage } from '../pages/Context/ContextSelectionPage'
import { Fallback } from '../shared/Fallback'
import type { DomainConfig } from '../domains'

export type RouteName = 'login' | 'context' | 'portal' | 'help' | 'diagnostic' | 'not-found' | 'error' | 'offline' | 'dev' | 'domain'

export interface DomainRoute {
  type: 'domain'
  domain: DomainConfig
}

export type AppRoute = RouteName | DomainRoute

interface RouterContextValue {
  route: AppRoute
  navigate: (route: AppRoute) => void
  currentDomain: DomainConfig | null
  error: Error | null
  setError: (err: Error | null) => void
}

const RouterContext = createContext<RouterContextValue | null>(null)

export function RouterProvider({ children }: { children?: ReactNode }) {
  const [route, setRoute] = useState<AppRoute>('login')
  const [error, setError] = useState<Error | null>(null)

  const navigate = (next: AppRoute) => {
    setError(null)
    setRoute(next)
  }

  const currentDomain: DomainConfig | null = typeof route === 'object' && route.type === 'domain'
    ? route.domain
    : null

  return (
    <RouterContext.Provider value={{ route, navigate, currentDomain, error, setError }}>
      {children}
    </RouterContext.Provider>
  )
}

export function useRouter(): RouterContextValue {
  const ctx = useContext(RouterContext)
  if (!ctx) throw new Error('useRouter deve ser usado dentro de <RouterProvider>')
  return ctx
}

export function RouteRenderer({ route, navigate }: { route: AppRoute; navigate: (r: AppRoute) => void }) {
  if (route === 'login') {
    return <LoginPage />
  }
  if (route === 'context') {
    return <ContextSelectionPage />
  }
  if (route === 'diagnostic') {
    return <DiagnosticPage />
  }
  if (route === 'help') {
    return <HelpPage />
  }
  if (route === 'not-found') {
    return (
      <Fallback
        type="404"
        onRetry={() => navigate('portal')}
        onDiagnose={() => navigate('diagnostic')}
      />
    )
  }
  if (route === 'error') {
    return (
      <Fallback
        type="500"
        onRetry={() => navigate('portal')}
        onDiagnose={() => navigate('diagnostic')}
      />
    )
  }
  if (route === 'offline') {
    return (
      <Fallback
        type="offline"
        onRetry={() => window.location.reload()}
        onDiagnose={() => navigate('diagnostic')}
      />
    )
  }
  if (route === 'dev') {
    return (
      <Fallback
        type="em-desenvolvimento"
        onRetry={() => navigate('portal')}
      />
    )
  }
  return null
}
