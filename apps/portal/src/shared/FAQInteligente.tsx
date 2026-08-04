import { useToast } from './Toast'
import type { ToastType } from './Toast'
import styles from './FAQInteligente.module.css'

interface FAQItem {
  id: string
  categoria: 'login' | 'rede' | 'sistema' | 'acesso' | 'dados'
  pergunta: string
  resposta: string
  causas: string[]
}

interface FAQProps {
  error?: Error
  errorType?: ToastType
  onClose?: () => void
}

const faqData: FAQItem[] = [
  {
    id: 'login-falha',
    categoria: 'login',
    pergunta: 'Por que não consigo entrar no sistema?',
    resposta: 'Verifique os possíveis motivos abaixo:',
    causas: [
      'Senha digitada incorretamente',
      'Usuário inexistente ou inativo',
      'Conta bloqueada por tentativas erradas',
      'Necessário redefinir senha',
    ],
  },
  {
    id: 'backend-offline',
    categoria: 'rede',
    pergunta: 'Por que o backend está offline?',
    resposta: 'Os principais motivos são:',
    causas: [
      'Servidor está em manutenção',
      'Problemas de conexão de rede',
      'Firewall bloqueando a porta',
      'Processo do backend travou',
    ],
  },
  {
    id: 'banco-indisponivel',
    categoria: 'sistema',
    pergunta: 'Banco de dados indisponível?',
    resposta: 'Possíveis causas:',
    causas: [
      'MySQL não está rodando',
      'Limite de conexões atingido',
      'Query lenta ou travada',
      'Correnteza em tabelas',
    ],
  },
  {
    id: 'sessao-expirada',
    categoria: 'acesso',
    pergunta: 'Sessão expirou ou inválida?',
    resposta: 'Causas comuns:',
    causas: [
      'Inatividade por mais de 30 minutos',
      'Login em outro dispositivo',
      'Reiniciar o browser',
      'Limpar cookies e cache',
    ],
  },
  {
    id: 'sem-permissao',
    categoria: 'acesso',
    pergunta: 'Permissão insuficiente?',
    resposta: 'Verifique:',
    causas: [
      'Perfil de usuário não tem acesso',
      'Unidade não associada ao usuário',
      'Permissão não concedida pelo admin',
      'Ticket pendente de liberação',
    ],
  },
  {
    id: 'erro-dispatcher',
    categoria: 'sistema',
    pergunta: 'Dispatcher retornou erro?',
    resposta: 'Possíveis motivos:',
    causas: [
      'Capability não mapeada na tabela permissao',
      'Procedure não encontrada',
      'Payload inválido',
      'Sessão inválida no momento da chamada',
    ],
  },
]

export function FAQInteligente({ error, errorType, onClose }: FAQProps) {
  const toast = useToast()

  const handleRetry = () => window.location.reload()
  const handleDiagnose = () => {
    window.open('/help?section=diagnostico', '_self')
  }

  const getCategoriaLabel = (cat: FAQItem['categoria']) => {
    const map: Record<FAQItem['categoria'], string> = {
      login: '🔐 Autenticação',
      rede: '🌐 Rede',
      sistema: '🖥️ Sistema',
      acesso: '🔑 Acesso',
      dados: '📊 Dados',
    }
    return map[cat]
  }

  const filteredFAQs = errorType
    ? faqData.filter((item) => {
        const typeMap: Record<NonNullable<ToastType>, FAQItem['categoria'][]> = {
          success: ['login', 'sistema'],
          error: ['login', 'rede', 'sistema'],
          warning: ['login', 'acesso'],
          info: ['login', 'sistema'],
          offline: ['rede', 'sistema'],
          unauthorized: ['login', 'acesso'],
          forbidden: ['acesso', 'sistema'],
          timeout: ['rede', 'sistema'],
        }
        return typeMap[errorType ?? 'error'].includes(item.categoria)
      })
    : faqData

  return (
    <div className={styles.container}>
      <h2 className={styles.title}>❓ Perguntas Frequentes</h2>
      {error && (
        <p className={styles.errorInfo}>
          Erro detectado: {error.message}
        </p>
      )}
      <p className={styles.subtitle}>
        Selecione uma questão para entender a causa e a solução:
      </p>

      <div className={styles.faqList}>
        {filteredFAQs.map((item) => (
          <details
            key={item.id}
            className={styles.faqItem}
          >
            <summary className={styles.faqSummary}>
              <span>{item.pergunta}</span>
              <span className={styles.faqCategory}>
                {getCategoriaLabel(item.categoria)}
              </span>
            </summary>
            <div className={styles.faqContent}>
              <p className={styles.faqAnswer}>{item.resposta}</p>
              <ul className={styles.faqCauses}>
                {item.causas.map((causa, i) => (
                  <li key={i} className={styles.faqCause}>
                    ✔ {causa}
                  </li>
                ))}
              </ul>
            </div>
          </details>
        ))}
      </div>

      <div className={styles.actions}>
        <button
          onClick={handleRetry}
          className={styles.retryButton}
        >
          🔄 Tentar novamente
        </button>
        <button
          onClick={handleDiagnose}
          className={styles.diagnoseButton}
        >
          🩺 Ver Diagnóstico
        </button>
        {onClose && (
          <button
            onClick={onClose}
            className={styles.closeButton}
          >
            ✕ Fechar
          </button>
        )}
      </div>
    </div>
  )
}
