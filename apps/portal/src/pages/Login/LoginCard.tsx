/**
 * Login Card
 *
 * Componente de formulário de autenticação do Portal.
 * Suporta modos 'login' (credenciais) e 'mfa' (código multifator).
 *
 * @param props.darkMode - Indica se o tema escuro está ativo.
 * @param props.onToggleTheme - Callback para alternar tema.
 * @param props.mode - Modo do formulário: 'login' ou 'mfa'.
 * @param props.username - Valor do campo usuário.
 * @param props.password - Valor do campo senha.
 * @param props.mfaCode - Valor do código MFA.
 * @param props.rememberMe - Estado do checkbox 'Lembrar de mim'.
 * @param props.showPassword - Indica se a senha está visível.
 * @param props.loading - Indica estado de carregamento.
 * @param props.error - Mensagem de erro ou null.
 * @param props.onUsernameChange - Callback para alteração de usuário.
 * @param props.onPasswordChange - Callback para alteração de senha.
 * @param props.onMfaCodeChange - Callback para alteração de MFA.
 * @param props.onRememberMeChange - Callback para alteração do checkbox.
 * @param props.onShowPasswordChange - Callback para alternar visibilidade da senha.
 * @param props.onSubmit - Callback de submissão do formulário.
 *
 * @see {@link LoginPage}
 * @see {@link ThemeProvider}
 */
import { type FormEvent } from 'react'
import styles from './LoginPage.module.css'

/**
 * Props do Login Card
 */
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
                src="/assets/branding/logoSaaSFormulario.png"
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
                  <div className={styles.inputWrapper}>
                    <IconUser />
                    <input
                      className={styles.input}
                      type="text"
                      value={username}
                      onChange={(e) => onUsernameChange(e.target.value)}
                      placeholder=" "
                      required
                    />
                    <label className={styles.floatingLabel}>Usuário</label>
                  </div>
                </div>

                <div className={styles.fieldGroup}>
                  <div className={styles.inputWrapper}>
                    <IconLock />
                    <input
                      className={styles.input}
                      type={showPassword ? 'text' : 'password'}
                      value={password}
                      onChange={(e) => onPasswordChange(e.target.value)}
                      placeholder=" "
                      required
                    />
                    <label className={styles.floatingLabel}>Senha</label>
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
                  {loading ? (
                    <>
                      <span className={styles.spinner} />
                      Entrando...
                    </>
                  ) : (
                    'Entrar'
                  )}
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
                    placeholder=" "
                  />
                  <label className={styles.floatingLabel}>Código MFA</label>
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
      <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <circle cx="12" cy="7" r="4" stroke="currentColor" strokeWidth="1.5" fill="none" />
    </svg>
  )
}

function IconLock() {
  return (
    <svg viewBox="0 0 24 24" className={styles.fieldIcon} aria-hidden="true">
      <rect x="5" y="11" width="14" height="10" rx="2" stroke="currentColor" strokeWidth="1.5" fill="none" />
      <path d="M8 11V7a4 4 0 0 1 8 0v4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <circle cx="12" cy="16" r="1" fill="currentColor" />
    </svg>
  )
}

function IconEye() {
  return (
    <svg viewBox="0 0 24 24" className={styles.fieldIcon} aria-hidden="true">
      <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7z" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <circle cx="12" cy="12" r="3" stroke="currentColor" strokeWidth="1.5" fill="none" />
    </svg>
  )
}

function IconEyeOff() {
  return (
    <svg viewBox="0 0 24 24" className={styles.fieldIcon} aria-hidden="true">
      <path d="M3 3l18 18" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <path d="M9 9c-1.5 1.5-2.5 3.5-2.5 5.5 0 2.5 1.5 4.5 3.5 4.5 1 0 2-.5 3-1" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <path d="M14.5 14.5c1 1 2.5 1.5 3.5 1.5 2.5 0 4.5-1.5 4.5-4.5 0-1-.5-2-1.5-3" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
    </svg>
  )
}

function IconMoon() {
  return (
    <svg viewBox="0 0 24 24" className={styles.themeIcon} aria-hidden="true">
      <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
    </svg>
  )
}

function IconSun() {
  return (
    <svg viewBox="0 0 24 24" className={styles.themeIcon} aria-hidden="true">
      <circle cx="12" cy="12" r="5" stroke="currentColor" strokeWidth="1.5" fill="none" />
      <path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" fill="none" />
    </svg>
  )
}

function IconShieldCheck() {
  return (
    <svg viewBox="0 0 24 24" className={styles.badgeIcon} aria-hidden="true">
      <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <path d="M9 12l2 2 4-4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
    </svg>
  )
}

function IconCloud() {
  return (
    <svg viewBox="0 0 24 24" className={styles.badgeIcon} aria-hidden="true">
      <path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
    </svg>
  )
}

function IconLockKeyhole() {
  return (
    <svg viewBox="0 0 24 24" className={styles.badgeIcon} aria-hidden="true">
      <rect x="5" y="11" width="14" height="10" rx="2" stroke="currentColor" strokeWidth="1.5" fill="none" />
      <path d="M8 11V7a4 4 0 0 1 8 0v4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <circle cx="12" cy="16" r="1" fill="currentColor" />
    </svg>
  )
}
