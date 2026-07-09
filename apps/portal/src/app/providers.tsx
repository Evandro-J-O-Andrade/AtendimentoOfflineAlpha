import React from 'react'
import { AuthProvider, useAuth } from '@atendimentooffline/auth'
import { PortalRuntimeProvider } from '../shell/PortalRuntime'
import { EnterpriseShell } from '../shell/EnterpriseShell'
import { PortalRuntimeEngine } from '@atendimentooffline/runtime'
import { createApiClient, createPortalApi } from '@atendimentooffline/api'
import { portalConfig } from './config'
import type { PortalRuntimeContract } from '@atendimentooffline/contracts'
import { RouterProvider, useRouter, type RouteName } from './router'
import { AuthGuard } from '../guards/AuthGuard'
import { ContextGuard } from '../guards/ContextGuard'
import { LoginPage } from '../pages/Login/LoginPage'
import { ContextSelectionPage } from '../pages/Context/ContextSelectionPage'

function NavigationController({ children }: { children?: React.ReactNode }) {
  const { authenticated } = useAuth()
  const { route, navigate } = useRouter()

  React.useEffect(() => {
    if (!authenticated) {
      if (route !== 'login') {
        navigate('login')
      }
      return
    }

    if (route === 'login') {
      navigate('context')
    } else if (route === 'context') {
      navigate('portal')
    }
  }, [authenticated, route, navigate])

  if (!authenticated) {
    return <LoginPage />
  }

  if (route === 'context') {
    return (
      <AuthGuard>
        <ContextSelectionPage />
      </AuthGuard>
    )
  }

  if (route === 'portal') {
    return (
      <AuthGuard>
        <ContextGuard>
          <EnterpriseShell>{children}</EnterpriseShell>
        </ContextGuard>
      </AuthGuard>
    )
  }

  return <LoginPage />
}

function PortalRuntimeComposer({ children }: { children: React.ReactNode }) {
  const { session } = useAuth()
  const api = React.useMemo(() => createApiClient({ baseUrl: portalConfig.apiUrl }), [])
  const engine = React.useMemo(() => new PortalRuntimeEngine(api), [api])
  const portalApi = React.useMemo(() => createPortalApi(api), [api])

  const runtime = React.useMemo((): PortalRuntimeContract => {
    if (!session) {
      return {
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
    }

    return engine.compose({
      session,
      tenant: null,
      context: null,
      applications: [],
      widgets: [],
      navigation: [],
      dashboard: null,
      notifications: [],
      management: { enabled: false, containers: [] },
      permissions: []
    })
  }, [engine, session])

  const [portalRuntime, setPortalRuntime] = React.useState<PortalRuntimeContract | null>(null)
  const [loadingPortal, setLoadingPortal] = React.useState(false)
  const [errorPortal, setErrorPortal] = React.useState<string | null>(null)

  React.useEffect(() => {
    if (!session?.id_sessao_usuario) {
      setPortalRuntime(null)
      return
    }

    let cancelled = false
    setLoadingPortal(true)
    setErrorPortal(null)

    portalApi.runtime(session.id_sessao_usuario)
      .then((data) => {
        if (!cancelled) {
          setPortalRuntime(data as PortalRuntimeContract)
        }
      })
      .catch((error) => {
        if (!cancelled) {
          setErrorPortal(error instanceof Error ? error.message : 'Falha ao carregar portal')
        }
      })
      .finally(() => {
        if (!cancelled) {
          setLoadingPortal(false)
        }
      })

    return () => {
      cancelled = true
    }
  }, [portalApi, session?.id_sessao_usuario])

  const finalRuntime = portalRuntime ?? runtime

  return (
    <PortalRuntimeProvider value={finalRuntime}>
      {children}
    </PortalRuntimeProvider>
  )
}

export function ProviderStack() {
  return (
    <AuthProvider baseUrl={portalConfig.apiUrl}>
      <PortalRuntimeComposer>
        <RouterProvider>
          <NavigationController />
        </RouterProvider>
      </PortalRuntimeComposer>
    </AuthProvider>
  )
}
