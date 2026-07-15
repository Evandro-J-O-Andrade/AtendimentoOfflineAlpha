import styles from './LoginPage.module.css'

export function LoginHero() {
  return (
    <section
      className={styles.leftPanel}
      style={{ backgroundImage: `url('/assets/login/pagsaas.png')` }}
    >
      <div className={styles.leftOverlay} />
      <div className={styles.leftContent}>
        <img
          src="/assets/branding/logoSaaS.png"
          alt="New Wave Enterprise Logo"
          className={styles.leftLogo}
        />
        <h2 className={styles.leftTitle}>
          New Wave <span>Enterprise</span>
        </h2>
        <p className={styles.leftText}>
          Plataforma SaaS Corporativa de Gestão e Inteligência Analítica
        </p>
      </div>
    </section>
  )
}
