import React from 'react'
import { AuthProvider, useAuth } from '@atendimentooffline/auth'
import { PortalRuntimeProvider, DEFAULT_RUNTIME } from '../shell/PortalRuntime'
import { EnterpriseShell } from '../shell/EnterpriseShell'
import { PortalRuntimeEngine } from '@atendimentooffline/runtime'
import { createApiClient } from '@atendimentooffline/api'
import { ApiDispatcherClient } from '../core/api/DispatcherClient'
import type { PortalRuntimeContract } from '@atendimentooffline/contracts'
import { RouterProvider, useRouter, type RouteName } from './router'
import { AuthGuard } from '../guards/AuthGuard'
import { ContextGuard } from '../guards/ContextGuard'
import { LoginPage } from '../pages/Login/LoginPage'
import { ContextSelectionPage } from '../pages/Context/ContextSelectionPage'
import { portalConfig } from './config'

const PORTAL_RUNTIME_API = createApiClient({ baseUrl: portalConfig.apiUrl })

/**
 * Navigation Controller
 *
 * Controla a navegação baseada no estado de autenticação e na rota atual.
 * Redireciona usuários não autenticados para login e usuários autenticados
 * para seleção de contexto ou portal.
 *
 * @param props.children - Nós filhos a serem renderizados na rota 'portal'.
 *
 * @see {@link RouterProvider}
 * @see {@link AuthGuard}
 * @see {@link ContextGuard}
 */
function NavigationController({ children }: { children?: React.ReactNode }) {
  const { authenticated } = useAuth()
  const { route, navigate } = useRouter()

  const isShellRoute =
    route === 'portal' || (typeof route === 'object' && route.type === 'domain')

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

  if (isShellRoute) {
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

/**
 * Portal Runtime Composer
 *
 * Compõe o runtime do Portal a partir da sessão autenticada e dos dados
 * carregados via API. Funde o runtime estático (compose) com o runtime
 * dinâmico (carregado do backend).
 *
 * Utiliza o Dispatcher Client canônico para carga única de runtime.
 *
 * @param props.children - Nós filhos que receberão o contexto de runtime.
 *
 * @see {@link PortalRuntimeProvider}
 * @see {@link ProviderStack}
 * @see {@link ApiDispatcherClient}
 */
function PortalRuntimeComposer({ children }: { children: React.ReactNode }) {
  const { session } = useAuth()
  const api = React.useMemo(() => PORTAL_RUNTIME_API, [])
  const engine = React.useMemo(() => new PortalRuntimeEngine(api), [api])

  const runtime = React.useMemo((): PortalRuntimeContract => {
    if (!session) {
      return DEFAULT_RUNTIME
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

    const dispatcher = new ApiDispatcherClient(portalConfig.apiUrl)

    dispatcher.send({
      modulo: 'PORTAL',
      acao: 'RUNTIME.LOAD',
      payload: {},
      idSessao: session.id_sessao_usuario
    })
      .then((response) => {
        if (!cancelled && response.sucesso && response.resultado) {
          setPortalRuntime(response.resultado as PortalRuntimeContract)
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
  }, [session?.id_sessao_usuario])

  const finalRuntime = portalRuntime ?? runtime

  return (
    <PortalRuntimeProvider value={finalRuntime}>
      {children}
    </PortalRuntimeProvider>
  )
}

/**
 * Provider Stack - Árvore de Contextos do Portal
 *
 * Orquestra todos os providers do Portal em ordem correta:
 * Autenticação → Runtime → Roteamento → Navegação.
 *
 * @returns Árvore de providers renderizada.
 *
 * @see {@link AuthProvider}
 * @see {@link PortalRuntimeProvider}
 * @see {@link RouterProvider}
 * @see {@link NavigationController}
 */
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
