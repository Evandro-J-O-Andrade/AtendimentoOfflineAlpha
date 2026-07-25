/**
 * Login Page
 *
 * Página de autenticação do Portal Enterprise.
 * Gerencia o fluxo de login, incluindo estados de carregamento,
 * MFA e feedback de erro.
 *
 * @see {@link ThemeProvider}
 * @see {@link LoginHero}
 * @see {@link LoginCard}
 * @see {@link LoginFooter}
 * @see {@link NavigationController}
 */
import { useState, type FormEvent } from 'react';
import { useAuth } from '@atendimentooffline/auth';
import type {
  LoginRequestContract,
  AuthenticationState,
} from '@atendimentooffline/contracts';
import { ThemeProvider, useTheme } from './ThemeProvider';
import { LoginHero } from './LoginHero';
import { LoginCard } from './LoginCard';
import { LoginFooter } from './LoginFooter';
import styles from './LoginPage.module.css';

/**
 * Login Page Inner Component
 *
 * Componente interno que gerencia estado e lógica de autenticação.
 * Envolvido por ThemeProvider para gerenciamento de tema.
 *
 * @returns Layout da página de login com hero, formulário e footer.
 */
function LoginPageInner() {
  const { login, loading, authenticated } = useAuth();
  const { theme, toggle: toggleTheme } = useTheme();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [rememberMe, setRememberMe] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [mfaCode, setMfaCode] = useState('');
  const [authState, setAuthState] =
    useState<AuthenticationState>('UNAUTHENTICATED');

  const darkMode = theme === 'dark';

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setError(null);

    const request: LoginRequestContract = {
      username,
      password,
      tenant: undefined,
      mfaCode: mfaCode || undefined,
    };

    try {
      const response = await login(request);
      setAuthState(response.state);
      setError(response.message ?? null);
    } catch {
      setError('Erro de conexão');
      setAuthState('ERROR');
    }
  }

  if (loading && authState === 'AUTHENTICATING') {
    return (
      <div className={styles.pageLayout}>
        <div className={styles.status}>Autenticando...</div>
      </div>
    );
  }

  if (authenticated) {
    return (
      <div className={styles.pageLayout}>
        <div className={styles.status}>Redirecionando...</div>
      </div>
    );
  }

  if (authState === 'MFA_REQUIRED') {
    return (
      <div
        className={`${styles.pageLayout} ${darkMode ? styles.themeDark : styles.themeLight}`}
      >
        <div className={styles.mainContent}>
          <LoginHero darkMode={darkMode} />
          <LoginCard
            darkMode={darkMode}
            onToggleTheme={toggleTheme}
            mode="mfa"
            username={username}
            password={password}
            mfaCode={mfaCode}
            rememberMe={rememberMe}
            showPassword={showPassword}
            loading={loading}
            error={error}
            onUsernameChange={setUsername}
            onPasswordChange={setPassword}
            onMfaCodeChange={setMfaCode}
            onRememberMeChange={setRememberMe}
            onShowPasswordChange={setShowPassword}
            onSubmit={handleSubmit}
          />
        </div>
        <LoginFooter darkMode={darkMode} />
      </div>
    );
  }

  return (
    <div
      className={`${styles.pageLayout} ${darkMode ? styles.themeDark : styles.themeLight}`}
    >
      <div className={styles.mainContent}>
        <LoginHero darkMode={darkMode} />
        <LoginCard
          darkMode={darkMode}
          onToggleTheme={toggleTheme}
          mode="login"
          username={username}
          password={password}
          mfaCode={mfaCode}
          rememberMe={rememberMe}
          showPassword={showPassword}
          loading={loading}
          error={error}
          onUsernameChange={setUsername}
          onPasswordChange={setPassword}
          onMfaCodeChange={setMfaCode}
          onRememberMeChange={setRememberMe}
          onShowPasswordChange={setShowPassword}
          onSubmit={handleSubmit}
        />
      </div>
      <LoginFooter darkMode={darkMode} />
    </div>
  );
}

/**
 * Login Page Export
 *
 * Componente exportado que envolve LoginPageInner com ThemeProvider.
 * Entry point público da página de login.
 *
 * @returns Página de login com tema aplicado.
 * @see {@link LoginPageInner}
 * @see {@link ThemeProvider}
 */
export function LoginPage() {
  return (
    <ThemeProvider>
      <LoginPageInner />
    </ThemeProvider>
  );
}
