/**
 * Portal Runtime
 *
 * Contexto e utilitários para o runtime do Portal.
 * Prove o runtime padrão e hooks de acesso.
 *
 * @module PortalRuntime
 *
 * @see {@link PortalRuntimeProvider}
 * @see {@link usePortalRuntime}
 * @see {@link DEFAULT_RUNTIME}
 */
import { createContext, useContext, type ReactNode } from 'react'
import type { PortalRuntimeContract } from '@atendimentooffline/contracts'

/**
 * Default Runtime Contract
 *
 * Runtime padrão do Portal quando não há sessão ativa ou dados carregados.
 * Contém valores vazios/nulos seguros para todas as propriedades.
 */
export const DEFAULT_RUNTIME: PortalRuntimeContract = {
  user: null,
  tenant: null,
  context: null,
  applications: [],
  navigation: [],
  widgets: [],
  branding: { name: 'Enterprise Portal' },
  notifications: [],
  management: { enabled: false, containers: [] },
  permissions: []
}

const PortalRuntimeContext = createContext<PortalRuntimeContract>(DEFAULT_RUNTIME)

/**
 * Portal Runtime Provider
 *
 * Provider do contexto de runtime do Portal.
 * Disponibiliza o runtime atual para componentes filhos.
 *
 * @param props.value - Runtime opcional. Usa DEFAULT_RUNTIME se omitido.
 * @param props.children - Nós filhos que consumirão o runtime.
 * @returns Provider de runtime do Portal.
 *
 * @see {@link DEFAULT_RUNTIME}
 * @see {@link usePortalRuntime}
 */
export function PortalRuntimeProvider({
  value,
  children
}: {
  value?: PortalRuntimeContract
  children: ReactNode
}) {
  return (
    <PortalRuntimeContext.Provider value={value ?? DEFAULT_RUNTIME}>
      {children}
    </PortalRuntimeContext.Provider>
  )
}

/**
 * Hook de Runtime do Portal
 *
 * Hook para acessar o runtime atual do Portal.
 * Retorna DEFAULT_RUNTIME se usado fora do provider.
 *
 * @returns Runtime atual do Portal.
 *
 * @see {@link PortalRuntimeProvider}
 * @see {@link DEFAULT_RUNTIME}
 */
export function usePortalRuntime(): PortalRuntimeContract {
  return useContext(PortalRuntimeContext)
}
