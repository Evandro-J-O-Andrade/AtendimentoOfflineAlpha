import { createContext, useContext, type ReactNode } from 'react'
import type { PortalRuntimeContract } from '@atendimentooffline/contracts'

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

export function usePortalRuntime(): PortalRuntimeContract {
  return useContext(PortalRuntimeContext)
}
