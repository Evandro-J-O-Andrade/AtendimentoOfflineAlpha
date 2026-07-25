import { createContext, useContext, useState, type ReactNode } from 'react'
import type { DomainConfig } from '../domains'

export type RouteName = 'login' | 'context' | 'portal' | 'domain'

export interface DomainRoute {
  type: 'domain'
  domain: DomainConfig
}

export type AppRoute = RouteName | DomainRoute

/**
 * Router Context Value
 *
 * Estrutura de dados exposta pelo contexto de roteamento do Portal.
 * Suporta rotas canônicas e rotas por domínio de negócio.
 */
interface RouterContextValue {
  route: AppRoute
  navigate: (route: AppRoute) => void
  currentDomain: DomainConfig | null
}

const RouterContext = createContext<RouterContextValue | null>(null)

/**
 * Router Provider
 *
 * Fornece contexto de roteamento simples para o Portal.
 * Gerencia a rota atual e função de navegação entre rotas.
 * Suporta domínios canônicos via DomainConfig.
 *
 * @param props.children - Nós filhos que consumirão o contexto de rota.
 *
 * @see {@link useRouter}
 * @see {@link DomainConfig}
 */
export function RouterProvider({ children }: { children?: ReactNode }) {
  const [route, setRoute] = useState<AppRoute>('login')

  const navigate = (next: AppRoute) => setRoute(next)

  const currentDomain: DomainConfig | null = typeof route === 'object' && route.type === 'domain'
    ? route.domain
    : null

  return (
    <RouterContext.Provider value={{ route, navigate, currentDomain }}>
      {children}
    </RouterContext.Provider>
  )
}

/**
 * Hook de Roteamento do Portal
 *
 * Hook para acessar rota atual e função de navegação.
 * Deve ser usado dentro de um RouterProvider.
 *
 * @returns Objeto com rota atual, função navigate e domínio atual.
 * @throws {Error} Se usado fora de RouterProvider.
 *
 * @see {@link RouterProvider}
 */
export function useRouter(): RouterContextValue {
  const ctx = useContext(RouterContext)
  if (!ctx) throw new Error('useRouter deve ser usado dentro de <RouterProvider>')
  return ctx
}

