import { useState, useEffect } from 'react'
import { useRouter } from '../../app/router'
import { useAuth } from '@atendimentooffline/auth'
import type { ContextContract } from '@atendimentooffline/contracts'

export function ContextSelectionPage() {
  const { navigate } = useRouter()
  const { session, selectContext, loading } = useAuth()
  const [contexts, setContexts] = useState<ContextContract[]>([])
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (!session?.id_sessao_usuario) {
      return
    }

    fetch(`/auth/context/${session.id_sessao_usuario}`)
      .then((res) => {
        if (!res.ok) {
          throw new Error('FALHA_CARREGAR_CONTEXTO')
        }
        return res.json()
      })
      .then((data) => {
        const mapped = (data.unidades ?? []).map((u: any) => ({
          id: String(u.id_unidade),
          tenantId: session?.id_entidade ?? null,
          name: u.nome_unidade,
          kind: 'UNIT' as const,
          parentId: null
        }))
        setContexts(mapped)
      })
      .catch(() => {
        setError('Erro ao carregar contextos')
      })
  }, [session?.id_sessao_usuario, session?.id_entidade])

  async function handleSelect(context: ContextContract) {
    setSelectedId(context.id)
    setError(null)

    try {
      await selectContext(Number(context.id), 1, 0)
      navigate('portal')
    } catch {
      setError('Erro ao selecionar contexto')
      setSelectedId(null)
    }
  }

  if (loading) {
    return (
      <div>
        <h1>Carregando contexto...</h1>
      </div>
    )
  }

  if (error) {
    return (
      <div>
        <h1>Erro</h1>
        <p>{error}</p>
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
      <ul>
        {contexts.map((context) => (
          <li key={context.id}>
            <button
              type="button"
              onClick={() => handleSelect(context)}
              disabled={Boolean(selectedId)}
            >
              {context.name}
            </button>
          </li>
        ))}
      </ul>
      {selectedId && <p>Contexto selecionado. Entrando no Portal...</p>}
    </div>
  )
}
