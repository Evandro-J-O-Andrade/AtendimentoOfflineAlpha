import styles from './LoginPage.module.css'

interface LoginFooterProps {
  darkMode: boolean
}

export function LoginFooter({ darkMode }: LoginFooterProps) {
  return (
    <footer className={styles.footer}>
      <div className={styles.footerLeft}>
        <img src="/assets/branding/logoSaaS.png" alt="Logo" className={styles.miniLogo} />
        <span className={styles.brandName}>New Wave Enterprise</span>
        <span className={styles.dividerPipe}>|</span>
        <span className={styles.version}>v1.0.0</span>
        <span className={styles.copyright}>© 2026 New Wave Sistemas Digitais. Todos os direitos reservados.</span>
      </div>
      <div className={styles.footerRight}>
        <span>Desenvolvido por <strong>New Wave Sistemas Digitais</strong></span>
        <span>Fundador e CEO: <a href="#ceo" className={styles.ceoLink}>Evandro Andrade</a></span>
      </div>
    </footer>
  )
}
