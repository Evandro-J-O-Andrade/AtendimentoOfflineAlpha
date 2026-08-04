interface FallbackProps {
  error?: Error
  type?:
    | 'loading'
    | 'login'
    | 'portal'
    | 'widget'
    | 'dispatcher'
    | 'backend'
    | 'generic'
    | 'offline'
    | 'timeout'
    | 'network'
    | 'api'
    | 'no-context'
    | 'no-permission'
    | 'unauthorized'
    | 'forbidden'
    | '404'
    | '500'
    | 'em-desenvolvimento'
  onRetry?: () => void
  onDiagnose?: () => void
  onOpenFAQ?: () => void
}

const messages: Record<string, { title: string; desc: string; actions?: boolean }> = {
  loading: {
    title: 'Carregando...',
    desc: 'Aguarde enquanto carregamos o conteúdo.',
  },
  login: {
    title: 'Falha no Login',
    desc: 'Não foi possível autenticar. Verifique suas credenciais e conexão.',
    actions: true,
  },
  portal: {
    title: 'Portal Indisponível',
    desc: 'Não foi possível carregar o portal. Tente novamente.',
    actions: true,
  },
  widget: {
    title: 'Widget com Erro',
    desc: 'Este widget não pôde ser carregado.',
  },
  dispatcher: {
    title: 'Dispatcher Indisponível',
    desc: 'O serviço de execução está temporariamente indisponível.',
    actions: true,
  },
  backend: {
    title: 'Backend Offline',
    desc: 'O servidor não está respondendo. Verifique sua conexão.',
    actions: true,
  },
  generic: {
    title: 'Algo deu errado',
    desc: 'Ocorreu um erro inesperado. Tente novamente.',
    actions: true,
  },
  offline: {
    title: 'Sem Conexão',
    desc: 'Você está offline. Verifique sua conexão e tente novamente.',
    actions: true,
  },
  timeout: {
    title: 'Tempo Esgotado',
    desc: 'A requisição demorou muito. Tente novamente.',
    actions: true,
  },
  network: {
    title: 'Erro de Rede',
    desc: 'Não foi possível conectar ao servidor. Verifique sua conexão.',
    actions: true,
  },
  api: {
    title: 'Erro na API',
    desc: 'O servidor retornou um erro. Tente novamente.',
    actions: true,
  },
  'no-context': {
    title: 'Contexto Necessário',
    desc: 'Selecione um contexto para continuar.',
    actions: true,
  },
  'no-permission': {
    title: 'Permissão Insuficiente',
    desc: 'Você não tem permissão para acessar este recurso.',
  },
  unauthorized: {
    title: 'Não Autorizado',
    desc: 'Sua sessão expirou. Faça login novamente.',
    actions: true,
  },
  forbidden: {
    title: 'Acesso Negado',
    desc: 'Você não tem permissão para este recurso.',
  },
  '404': {
    title: 'Página Não Encontrada',
    desc: 'A página que você procura não existe.',
  },
  '500': {
    title: 'Erro Interno',
    desc: 'O servidor encontrou um erro. Tente novamente mais tarde.',
    actions: true,
  },
  'em-desenvolvimento': {
    title: 'Em Desenvolvimento',
    desc: 'Esta funcionalidade ainda não está disponível.',
  },
}

export function Fallback({
  error,
  type = 'generic',
  onRetry,
  onDiagnose,
  onOpenFAQ,
}: FallbackProps) {
  const msg = messages[type] ?? messages.generic
  if (!msg) {
    return null
  }
  return (
    <div
      style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '2rem',
        textAlign: 'center',
        minHeight: '200px',
        fontFamily: 'system-ui, -apple-system, sans-serif',
      }}
    >
      <h2 style={{ fontSize: '1.25rem', marginBottom: '0.5rem' }}>
        {msg.title}
      </h2>
      <p
        style={{
          color: '#666',
          marginBottom: onRetry ? '1rem' : '0',
          maxWidth: '400px',
          fontSize: '0.9rem',
        }}
      >
        {msg.desc}
      </p>
      {error && (
        <details
          style={{
            marginTop: '0.5rem',
            padding: '0.5rem',
            background: '#f8f9fa',
            borderRadius: '4px',
            fontSize: '0.75rem',
            color: '#999',
            maxWidth: '400px',
            width: '100%',
          }}
        >
          <summary style={{ cursor: 'pointer' }}>Detalhes técnicos</summary>
          <pre style={{ marginTop: '0.5rem', whiteSpace: 'pre-wrap' }}>
            {error.message}
          </pre>
        </details>
      )}
      {msg.actions && (onRetry || onDiagnose || onOpenFAQ) && (
        <div style={{ display: 'flex', gap: '0.5rem', marginTop: '1rem' }}>
          {onRetry && (
            <button
              onClick={onRetry}
              style={{
                padding: '0.5rem 1.25rem',
                border: '1px solid #007bff',
                borderRadius: '4px',
                backgroundColor: '#007bff',
                color: 'white',
                cursor: 'pointer',
                fontSize: '0.9rem',
              }}
            >
              Tentar novamente
            </button>
          )}
          {onDiagnose && (
            <button
              onClick={onDiagnose}
              style={{
                padding: '0.5rem 1.25rem',
                border: '1px solid #28a745',
                borderRadius: '4px',
                backgroundColor: '#28a745',
                color: 'white',
                cursor: 'pointer',
                fontSize: '0.9rem',
              }}
            >
              Diagnóstico
            </button>
          )}
          {onOpenFAQ && (
            <button
              onClick={onOpenFAQ}
              style={{
                padding: '0.5rem 1.25rem',
                border: '1px solid #ffc107',
                borderRadius: '4px',
                backgroundColor: '#ffc107',
                color: '#333',
                cursor: 'pointer',
                fontSize: '0.9rem',
              }}
            >
              Ajuda
            </button>
          )}
        </div>
      )}
    </div>
  )
}
