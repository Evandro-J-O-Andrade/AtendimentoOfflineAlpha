import styles from './LoginPage.module.css'

function BrandIcon({ children }: { children: React.ReactNode }) {
  return (
    <div className={styles.brandIconItem}>
      {children}
    </div>
  )
}

function IconBarChart2() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M18 20V10M12 20V4M6 20v-6" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" fill="none" />
    </svg>
  )
}

function IconUsers() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <circle cx="9" cy="7" r="4" stroke="currentColor" strokeWidth="2" fill="none" />
      <path d="M22 21v-2a4 4 0 0 0-3-3.87" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" fill="none" />
    </svg>
  )
}

function IconFileText() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <path d="M14 2v6h6M16 13H8M16 17H8M10 9H8" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" fill="none" />
    </svg>
  )
}

function IconMessageSquare() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" fill="none" />
    </svg>
  )
}

function IconShield() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" fill="none" />
    </svg>
  )
}

function IconPieChart() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M21.21 15.89A10 10 0 1 1 8 2.83" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <path d="M22 12A10 10 0 0 0 12 2v10h10z" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" fill="none" />
    </svg>
  )
}

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

        <div className={styles.brandIcons}>
          <BrandIcon><IconBarChart2 /></BrandIcon>
          <BrandIcon><IconUsers /></BrandIcon>
          <BrandIcon><IconFileText /></BrandIcon>
          <BrandIcon><IconMessageSquare /></BrandIcon>
          <BrandIcon><IconShield /></BrandIcon>
          <BrandIcon><IconPieChart /></BrandIcon>
        </div>
      </div>
    </section>
  )
}
