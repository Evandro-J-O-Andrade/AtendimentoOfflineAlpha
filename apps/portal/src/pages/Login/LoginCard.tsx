import { type FormEvent } from 'react'
import styles from './LoginPage.module.css'

interface LoginCardProps {
  darkMode: boolean
  onToggleTheme: () => void
  mode: 'login' | 'mfa'
  username: string
  password: string
  mfaCode: string
  rememberMe: boolean
  showPassword: boolean
  loading: boolean
  error: string | null
  onUsernameChange: (value: string) => void
  onPasswordChange: (value: string) => void
  onMfaCodeChange: (value: string) => void
  onRememberMeChange: (checked: boolean) => void
  onShowPasswordChange: (show: boolean) => void
  onSubmit: (e: FormEvent) => void
}

export function LoginCard({
  darkMode,
  onToggleTheme,
  mode,
  username,
  password,
  mfaCode,
  rememberMe,
  showPassword,
  loading,
  error,
  onUsernameChange,
  onPasswordChange,
  onMfaCodeChange,
  onRememberMeChange,
  onShowPasswordChange,
  onSubmit
}: LoginCardProps) {
  return (
    <section className={styles.rightPanel}>
      <div className={styles.wavesLeft} />

      <div className={styles.formContainer}>
        <div className={styles.cardForm}>
          <div className={styles.cardThemeToggle}>
            <button
              type="button"
              className={`${styles.themeToggle} ${darkMode ? '' : styles.themeToggleActive}`}
              onClick={onToggleTheme}
            >
              {darkMode ? <IconMoon /> : <IconSun />}
              <span>{darkMode ? 'Modo escuro' : 'Modo claro'}</span>
            </button>
          </div>

          {mode === 'login' && (
            <>
              <img
                src="/assets/branding/logoSaaS.png"
                alt="New Wave Enterprise Logo"
                className={styles.formLogo}
              />
              <h1 className={styles.cardTitle}>
                Bem-vindo ao <br />
                <span>New Wave Enterprise</span>
              </h1>
              <p className={styles.cardSubtitle}>
                Acesse sua conta para continuar gerenciando sua empresa com eficiência e inteligência.
              </p>

              <form onSubmit={onSubmit}>
                <div className={styles.fieldGroup}>
                  <label className={styles.label}>Usuário</label>
                  <div className={styles.inputWrapper}>
                    <IconUser />
                    <input
                      className={styles.input}
                      type="text"
                      value={username}
                      onChange={(e) => onUsernameChange(e.target.value)}
                      placeholder="Digite seu usuário"
                      required
                    />
                  </div>
                </div>

                <div className={styles.fieldGroup}>
                  <label className={styles.label}>Senha</label>
                  <div className={styles.inputWrapper}>
                    <IconLock />
                    <input
                      className={styles.input}
                      type={showPassword ? 'text' : 'password'}
                      value={password}
                      onChange={(e) => onPasswordChange(e.target.value)}
                      placeholder="Digite sua senha"
                      required
                    />
                    <button
                      type="button"
                      className={styles.toggleVisibility}
                      onClick={() => onShowPasswordChange(!showPassword)}
                    >
                      {showPassword ? <IconEyeOff /> : <IconEye />}
                    </button>
                  </div>
                </div>

                <div className={styles.formRow}>
                  <label className={styles.checkboxLabel}>
                    <input
                      type="checkbox"
                      checked={rememberMe}
                      onChange={(e) => onRememberMeChange(e.target.checked)}
                    />
                    <span>Lembrar de mim</span>
                  </label>
                  <a href="#esqueceu" className={styles.forgotLink}>
                    Esqueceu sua senha?
                  </a>
                </div>

                <button className={styles.button} type="submit" disabled={loading}>
                  Entrar
                </button>

                {error && <p className={styles.error}>{error}</p>}
              </form>

              <div className={styles.divider}>
                <span>Plataforma segura e confiável</span>
              </div>

              <div className={styles.securityBadges}>
                <div className={styles.badge}>
                  <IconShieldCheck />
                  <div>
                    <strong>Segurança</strong>
                    <span>Avançada</span>
                  </div>
                </div>
                <div className={styles.badge}>
                  <IconCloud />
                  <div>
                    <strong>Alta</strong>
                    <span>Disponibilidade</span>
                  </div>
                </div>
                <div className={styles.badge}>
                  <IconLockKeyhole />
                  <div>
                    <strong>Conformidade</strong>
                    <span>LGPD</span>
                  </div>
                </div>
              </div>
            </>
          )}

          {mode === 'mfa' && (
            <>
              <h1 className={styles.cardTitle}>Código MFA</h1>
              <div className={styles.fieldGroup}>
                <div className={styles.inputWrapper}>
                  <input
                    className={styles.input}
                    type="text"
                    value={mfaCode}
                    onChange={(e) => onMfaCodeChange(e.target.value)}
                    placeholder="Digite o código MFA"
                  />
                </div>
              </div>
              <button className={styles.button} type="submit" disabled={loading}>
                Confirmar
              </button>
              {error && <p className={styles.error}>{error}</p>}
            </>
          )}
        </div>
      </div>
    </section>
  )
}

function IconUser() {
  return (
    <svg viewBox="0 0 24 24" className={styles.fieldIcon} aria-hidden="true">
      <path d="M12 12a4 4 0 1 0-4-4 4 4 0 0 0 4 4Zm0 2c-3.31 0-6 1.79-6 4v1h12v-1c0-2.21-2.69-4-6-4Z" fill="none" stroke="currentColor" strokeWidth="1.5" />
    </svg>
  )
}

function IconLock() {
  return (
    <svg viewBox="0 0 24 24" className={styles.fieldIcon} aria-hidden="true">
      <path d="M7 10V8a5 5 0 0 1 10 0v2h1a1 1 0 0 1 1 1v8a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2v-8a1 1 0 0 1 1-1Zm2 0h6V8a3 3 0 0 0-6 0Z" fill="none" stroke="currentColor" strokeWidth="1.5" />
    </svg>
  )
}

function IconEye() {
  return (
    <svg viewBox="0 0 24 24" className={styles.fieldIcon} aria-hidden="true">
      <path d="M12 5c-5.15 0-9.4 3.2-10.8 7.8a1 1 0 0 0 0 .8C2.6 15.8 6.85 19 12 19s9.4-3.2 10.8-7.8a1 1 0 0 0 0-.8C21.4 8.2 17.15 5 12 5Zm0 12a5 5 0 1 1 5-5 5 5 0 0 1-5 5Zm0-8a3 3 0 1 0 3 3 3 3 0 0 0-3-3Z" fill="none" stroke="currentColor" strokeWidth="1.5" />
    </svg>
  )
}

function IconEyeOff() {
  return (
    <svg viewBox="0 0 24 24" className={styles.fieldIcon} aria-hidden="true">
      <path d="M3 3l18 18m-2.3-2.3A11.22 11.22 0 0 1 12 19c-5.15 0-9.4-3.2-10.8-7.8a1.18 1.18 0 0 1 0-.8 10.95 10.95 0 0 1 3.8-4.9M9.4 9.4A3 3 0 0 1 15 15l-2.9-2.9a3 3 0 0 1-2.7-2.7Z" fill="none" stroke="currentColor" strokeWidth="1.5" />
    </svg>
  )
}

function IconMoon() {
  return (
    <svg viewBox="0 0 24 24" className={styles.themeIcon} aria-hidden="true">
      <path d="M21 13.5A8.5 8.5 0 1 1 10.5 3a7 7 0 1 0 10.5 10.5Z" fill="none" stroke="currentColor" strokeWidth="1.5" />
    </svg>
  )
}

function IconSun() {
  return (
    <svg viewBox="0 0 24 24" className={styles.themeIcon} aria-hidden="true">
      <path d="M12 18a6 6 0 1 1 0-12 6 6 0 0 1 0 12Zm0-2a4 4 0 1 0 0-8 4 4 0 0 0 0 8ZM11 1h2v3h-2V1Zm0 19h2v3h-2v-3ZM1 11h3v2H1v-2Zm19 0h3v2h-3v-2Z" fill="none" stroke="currentColor" strokeWidth="1.5" />
    </svg>
  )
}

function IconShieldCheck() {
  return (
    <svg viewBox="0 0 24 24" className={styles.badgeIcon} aria-hidden="true">
      <path d="M12 2 4 5v6c0 5 3.4 8.9 8 11 4.6-2.1 8-6 8-11V5Zm-1 12 4-4-1.4-1.4-2.6 2.6-1.2-1.2L7.4 10Z" fill="none" stroke="currentColor" strokeWidth="1.5" />
    </svg>
  )
}

function IconCloud() {
  return (
    <svg viewBox="0 0 24 24" className={styles.badgeIcon} aria-hidden="true">
      <path d="M7 18a4 4 0 0 1-1.7-7.6A5 5 0 0 1 18.6 9a4.5 4.5 0 0 1 .9 8.8Z" fill="none" stroke="currentColor" strokeWidth="1.5" />
    </svg>
  )
}

function IconLockKeyhole() {
  return (
    <svg viewBox="0 0 24 24" className={styles.badgeIcon} aria-hidden="true">
      <path d="M8 10V8a4 4 0 1 1 8 0v2h1a1 1 0 0 1 1 1v8a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2v-8a1 1 0 0 1 1-1Zm2 0h4V8a2 2 0 0 0-4 0Zm-1 2v4h6v-4Z" fill="none" stroke="currentColor" strokeWidth="1.5" />
    </svg>
  )
}
