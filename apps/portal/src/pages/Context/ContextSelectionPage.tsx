/**
 * Context Selection Page
 *
 * Página de seleção de contexto operacional para usuários autenticados.
 * Carrega unidades de negócio disponíveis e permite ao usuário
 * selecionar o contexto (tenant/unidade) antes de acessar o Portal.
 *
 * @see {@link NavigationController}
 * @see {@link ContextGuard}
 * @see {@link MD-124-Context-First-Architecture}
 */
import { useState, useMemo, useEffect } from 'react'
import { useRouter } from '../../app/router'
import { useAuth } from '@atendimentooffline/auth'
import type { ContextContract } from '@atendimentooffline/contracts'

/**
 * Context Selection Page Component
 *
 * Orquestra o carregamento de contextos e a seleção pelo usuário.
 * Em caso de sucesso, navega para a rota 'portal'.
 *
 * @returns Interface de seleção de contexto.
 */
export function ContextSelectionPage() {
  const { navigate, route } = useRouter()
  const { session, selectContext, context, contextLoading, authState, markPortalReady } = useAuth()
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)

  const contexts = useMemo<ContextContract[]>(() => {
    return (context?.unidades ?? []).map((u) => ({
      id: String(u.id_unidade),
      tenantId: session?.id_entidade ? String(session.id_entidade) : '',
      name: u.nome_unidade,
      kind: 'UNIT' as const,
      parentId: null
    }))
  }, [context, session?.id_entidade])

  async function handleSelect(context: ContextContract) {
    setSelectedId(context.id)
    setError(null)
    try {
      await selectContext(Number(context.id), 1, 0)
      markPortalReady()
    } catch {
      setSelectedId(null)
      setError('Falha ao selecionar contexto.')
    }
  }

  useEffect(() => {
    if (authState === 'SESSION_READY' && route === 'context') {
      navigate('portal')
    }
  }, [authState, route, navigate])

  if (contextLoading) {
    return (
      <div>
        <h1>Carregando contexto...</h1>
      </div>
    )
  }

  if (!context) {
    return (
      <div>
        <h1>Erro</h1>
        <p>Erro ao carregar contextos</p>
      </div>
    )
  }

  if (contexts.length === 0) {
    return (
      <div>
        <h1>Contexto</h1>
        <p>Nenhum contexto disponível.</p>
      </div>
    )
  }

  return (
    <div>
      <h1>Selecione o Contexto</h1>
      {error && <p style={{ color: 'red' }}>{error}</p>}
      <ul>
        {contexts.map((ctx) => (
          <li key={ctx.id}>
            <button
              type="button"
              onClick={() => handleSelect(ctx)}
              disabled={Boolean(selectedId)}
            >
              {ctx.name}
            </button>
          </li>
        ))}
      </ul>
      {selectedId && <p>Contexto selecionado. Entrando no Portal...</p>}
    </div>
  )
}
