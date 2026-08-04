import { Component, type ReactNode, type ErrorInfo } from 'react'

interface Props {
  children: ReactNode
  fallback?: (error: Error, reset: () => void) => ReactNode
}

interface State {
  error: Error | null
}

export class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props)
    this.state = { error: null }
  }

  static getDerivedStateFromError(error: Error): State {
    return { error }
  }

  componentDidCatch(error: Error, info: ErrorInfo) {
    console.error('[ErrorBoundary]', error, info)
  }

  reset = () => {
    this.setState({ error: null })
  }

  render() {
    const { error } = this.state
    if (error) {
      if (this.props.fallback) {
        return <>{this.props.fallback(error, this.reset)}</>
      }
      return (
        <div
          style={{
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            justifyContent: 'center',
            minHeight: '100vh',
            padding: '2rem',
            textAlign: 'center',
            fontFamily: 'system-ui, -apple-system, sans-serif',
          }}
        >
          <h1 style={{ fontSize: '1.5rem', marginBottom: '0.5rem' }}>
            Algo deu errado.
          </h1>
          <p
            style={{
              color: '#666',
              marginBottom: '1.5rem',
              maxWidth: '400px',
              fontSize: '0.9rem',
            }}
          >
            Ocorreu um erro inesperado na interface. Os detalhes foram
            registrados no console.
          </p>
          <button
            onClick={this.reset}
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
        </div>
      )
    }
    return <>{this.props.children}</>
  }
}
