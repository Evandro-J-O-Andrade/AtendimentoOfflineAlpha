import { useState, useEffect } from 'react'
import { DiagnosticPage } from '../../pages/DiagnosticPage'
import { FAQInteligente } from '../../shared/FAQInteligente'
import styles from './HelpPage.module.css'

export function HelpPage() {
  const [activeSection, setActiveSection] = useState<'faq' | 'diagnostico'>('faq')

  useEffect(() => {
    document.title = 'Ajuda - Enterprise Portal'
    return () => {
      document.title = 'Enterprise Portal'
    }
  }, [])

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <h1 className={styles.title}>Central de Ajuda e Suporte</h1>
        <p className={styles.subtitle}>
          Soluções para problemas comuns e diagnóstico completo do sistema.
        </p>
      </div>

      <nav className={styles.nav}>
        <button
          className={`${styles.navButton} ${activeSection === 'faq' ? styles.navButtonActive : ''}`}
          onClick={() => setActiveSection('faq')}
        >
          Perguntas Frequentes
        </button>
        <button
          className={`${styles.navButton} ${activeSection === 'diagnostico' ? styles.navButtonActive : ''}`}
          onClick={() => setActiveSection('diagnostico')}
        >
          Diagnóstico do Sistema
        </button>
      </nav>

      <main className={styles.content}>
        {activeSection === 'faq' && (
          <section className={styles.section}>
            <h2 className={styles.sectionTitle}>
              <span className={styles.sectionIcon}>💡</span>
              Problemas Comuns
            </h2>
            <div className={styles.faqContainer}>
              <FAQInteligente errorType="error" />
            </div>
          </section>
        )}

        {activeSection === 'diagnostico' && (
          <section className={styles.section}>
            <h2 className={styles.sectionTitle}>
              <span className={styles.sectionIcon}>🩺</span>
              Verificação de Componentes
            </h2>
            <p className={styles.sectionDesc}>
              Clique no botão para executar uma verificação completa do ambiente.
            </p>
            <div className={styles.diagnosticoContainer}>
              <DiagnosticPage />
            </div>
          </section>
        )}
      </main>

      <footer className={styles.footer}>
        <a href="/" className={styles.backLink}>Voltar ao Portal</a>
      </footer>
    </div>
  )
}
