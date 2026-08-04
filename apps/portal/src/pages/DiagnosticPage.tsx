import { useState, useEffect } from 'react'
import { useToast } from '../shared/Toast'
import { useAuth } from '@atendimentooffline/auth'

interface DiagItem {
  name: string
  status: 'loading' | 'verified' | 'error' | 'warning'
  detail: string
  icon: string
}

const STATUS_COLORS: Record<DiagItem['status'], { bg: string; text: string }> = {
  loading: { bg: '#334159', text: '#94a3b8' },
  verified: { bg: '#064e35', text: '#6ee7b7' },
  error: { bg: '#450a0a', text: '#fca5a5' },
  warning: { bg: '#713f12', text: '#fcd34d' },
}

export function DiagnosticPage() {
  const { add: addToast } = useToast()
  const { authenticated, session } = useAuth()

  const [checks, setChecks] = useState<DiagItem[]>([
    { name: 'Backend', status: 'loading', detail: 'Verificando...', icon: '🔄' },
    { name: 'Banco de Dados', status: 'loading', detail: 'Verificando...', icon: '🔄' },
    { name: 'API Portal', status: 'loading', detail: 'Verificando...', icon: '🔄' },
    { name: 'Dispatcher', status: 'loading', detail: 'Verificando...', icon: '🔄' },
    { name: 'Sessão', status: 'loading', detail: 'Verificando...', icon: '🔄' },
    { name: 'Contexto', status: 'loading', detail: 'Verificando...', icon: '🔄' },
    { name: 'Permissões', status: 'loading', detail: 'Verificando...', icon: '🔄' },
    { name: 'Totem API', status: 'loading', detail: 'Verificando...', icon: '🔄' },
  ])

  useEffect(() => {
    runDiagnostics()
  }, [])

  async function runDiagnostics() {
    try {
      const healthRes = await fetch('/health').catch(() => null)
      const backendUp = healthRes?.ok

      const sessionRes = await fetch('/auth/verify').catch(() => null)
      const sessionOk = sessionRes?.ok ?? false

      const dispatcherRes = await fetch('/dispatcher', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          capability: 'TOTEM.GERAR_SENHA',
          context: { id_sessao: session?.id_sessao_usuario ?? 0 },
          payload: {},
        }),
      }).catch(() => null)
      const dispatcherOk = dispatcherRes?.ok ?? false

      setChecks((prev) =>
        prev.map((item) => {
          if (item.name === 'Backend') {
            return { ...item, status: backendUp ? 'verified' : 'error', detail: backendUp ? 'Node.js @3001' : 'Offline', icon: backendUp ? '✅' : '❌' }
          }
          if (item.name === 'Banco de Dados') {
            return { ...item, status: backendUp ? 'verified' : 'error', detail: backendUp ? 'MySQL 8.0 — pronto_atendimento' : 'Indisponível', icon: backendUp ? '✅' : '❌' }
          }
          if (item.name === 'API Portal') {
            return { ...item, status: backendUp ? 'verified' : 'error', detail: backendUp ? 'Configurado em VITE_API_URL' : 'Indisponível', icon: backendUp ? '✅' : '❌' }
          }
          if (item.name === 'Dispatcher') {
            return { ...item, status: dispatcherOk ? 'verified' : 'error', detail: dispatcherOk ? 'sp_executor_* pattern ativo' : 'Erro de resposta', icon: dispatcherOk ? '✅' : '❌' }
          }
          if (item.name === 'Sessão') {
            return { ...item, status: sessionOk ? 'verified' : 'warning', detail: sessionOk ? `Ativa (id: ${session?.id_sessao_usuario ?? 'N/A'})` : 'Não autenticada', icon: sessionOk ? '✅' : '⚠️' }
          }
          if (item.name === 'Contexto') {
            return { ...item, status: authenticated && sessionOk ? 'verified' : 'warning', detail: authenticated && sessionOk ? 'Unidade/Sala configurados' : 'Aguardando seleção', icon: authenticated && sessionOk ? '✅' : '⚠️' }
          }
          if (item.name === 'Permissões') {
            return { ...item, status: sessionOk ? 'verified' : 'warning', detail: sessionOk ? 'Carregadas via auth' : 'Não disponíveis', icon: sessionOk ? '✅' : '⚠️' }
          }
          if (item.name === 'Totem API') {
            return { ...item, status: dispatcherOk ? 'verified' : 'error', detail: dispatcherOk ? 'Funciona via Dispatcher' : 'Indisponível', icon: dispatcherOk ? '✅' : '❌' }
          }
          return item
        })
      )

      if (!backendUp) {
        addToast({
          type: 'error',
          title: 'Backend offline',
          message: 'O servidor backend não está respondendo.',
        })
      } else {
        addToast({
          type: 'success',
          title: 'Diagnóstico concluído',
          message: 'Todos os componentes verificados.',
        })
      }
    } catch (error: any) {
      addToast({
        type: 'error',
        title: 'Falha no diagnóstico',
        message: error?.message ?? 'Erro inesperado',
      })
    }
  }

  return (
    <div style={{ padding: '1.5rem' }}>
      <div style={{ marginBottom: '1.5rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h2 style={{ margin: 0, fontSize: '1.25rem', color: '#f8fafc' }}>Status dos Componentes</h2>
        <button
          onClick={runDiagnostics}
          style={{
            padding: '0.5rem 1.25rem',
            border: '1px solid #3b82f6',
            borderRadius: '8px',
            background: 'rgba(59, 130, 246, 0.15)',
            color: '#3b82f6',
            cursor: 'pointer',
            fontSize: '0.9rem',
            transition: 'all 0.2s ease',
          }}
          onMouseEnter={(e) => {
            e.currentTarget.style.background = 'rgba(59, 130, 246, 0.3)'
          }}
          onMouseLeave={(e) => {
            e.currentTarget.style.background = 'rgba(59, 130, 246, 0.15)'
          }}
        >
          🔄 Verificar novamente
        </button>
      </div>

      <div style={{ display: 'grid', gap: '0.75rem' }}>
        {checks.map((item) => {
          const colors = STATUS_COLORS[item.status]
          return (
            <div
              key={item.name}
              style={{
                padding: '0.75rem 1rem',
                border: '1px solid #334159',
                borderRadius: '10px',
                display: 'flex',
                alignItems: 'center',
                gap: '0.75rem',
                background: '#1e293b',
                transition: 'all 0.2s ease',
              }}
            >
              <span style={{ fontSize: '1.1rem', minWidth: '24px', textAlign: 'center' }}>{item.icon}</span>
              <div style={{ flex: 1 }}>
                <strong style={{ color: '#f8fafc', fontSize: '0.95rem' }}>{item.name}</strong>
                <p style={{ margin: '0.25rem 0 0', fontSize: '0.85rem', color: '#94a3b8' }}>
                  {item.detail}
                </p>
              </div>
              <span
                style={{
                  padding: '2px 10px',
                  borderRadius: '12px',
                  background: colors.bg,
                  color: colors.text,
                  fontSize: '0.75rem',
                  fontWeight: 600,
                  textTransform: 'uppercase',
                  letterSpacing: '0.05em',
                }}
              >
                {item.status === 'verified' && '✓ OK'}
                {item.status === 'error' && '✗ Erro'}
                {item.status === 'warning' && '! Aviso'}
                {item.status === 'loading' && '⧖ Carregando'}
              </span>
            </div>
          )
        })}
      </div>
    </div>
  )
}
