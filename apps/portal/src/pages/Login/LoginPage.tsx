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
import { useToast } from '../../shared/Toast';
import type {
  LoginRequestContract,
  AuthenticationState,
} from '@atendimentooffline/contracts';
import { FAQInteligente } from '../../shared/FAQInteligente';
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
  const [mfaCode, setMfaCode] = useState('');
  const [authState, setAuthState] =
    useState<AuthenticationState>('UNAUTHENTICATED');
  const [showFAQ, setShowFAQ] = useState(false);

  const darkMode = theme === 'dark';
  const toast = useToast();

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();

    const request: LoginRequestContract = {
      username,
      password,
      tenant: undefined,
      mfaCode: mfaCode || undefined,
    };

    try {
      const response = await login(request);
      setAuthState(response.state);

      if (response.state === 'AUTHENTICATED' || response.state === 'SESSION_READY' || response.state === 'PORTAL_READY') {
        toast.add({
          type: 'success',
          title: 'Login realizado',
          message: 'Redirecionando para o Portal...',
        });
      } else if (response.state === 'MFA_REQUIRED') {
        toast.add({
          type: 'info',
          title: 'Código MFA necessário',
          message: 'Digite o código de autenticação multifator.',
        });
      } else if (response.state === 'ERROR') {
        toast.add({
          type: 'error',
          title: 'Credenciais inválidas',
          message: response.message ?? 'Não foi possível autenticar.',
          action: { label: 'Ver FAQ', onClick: () => setShowFAQ(true) },
        });
      }
    } catch (err: any) {
      const message = err?.message ?? 'Erro de conexão';
      setAuthState('ERROR');

      if (!navigator.onLine || message.includes('fetch') || message.includes('ECONNREFUSED') || message.includes('timeout')) {
        toast.add({
          type: 'offline',
          title: 'Backend indisponível',
          message: 'Verifique sua conexão ou tente novamente mais tarde.',
          action: { label: 'Ver FAQ', onClick: () => setShowFAQ(true) },
        });
      } else {
        toast.add({
          type: 'error',
          title: 'Erro de conexão',
          message: message,
          action: { label: 'Ver FAQ', onClick: () => setShowFAQ(true) },
        });
      }
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
            error={null}
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
          error={null}
          onUsernameChange={setUsername}
          onPasswordChange={setPassword}
          onMfaCodeChange={setMfaCode}
          onRememberMeChange={setRememberMe}
          onShowPasswordChange={setShowPassword}
          onSubmit={handleSubmit}
        />
      </div>
      <LoginFooter darkMode={darkMode} />

      {showFAQ && (
        <div
          style={{
            position: 'fixed',
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            backgroundColor: 'rgba(0,0,0,0.5)',
            zIndex: 10000,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            overflow: 'auto',
          }}
          onClick={() => setShowFAQ(false)}
        >
          <div
            onClick={(e) => e.stopPropagation()}
            style={{
              backgroundColor: 'white',
              borderRadius: '8px',
              maxWidth: '600px',
              width: '90%',
              maxHeight: '80vh',
              overflow: 'auto',
            }}
          >
            <div style={{ padding: '1rem', borderBottom: '1px solid #e0e0e0', textAlign: 'right' }}>
              <button
                onClick={() => setShowFAQ(false)}
                style={{
                  border: 'none',
                  background: 'none',
                  fontSize: '1.5rem',
                  cursor: 'pointer',
                  color: '#666',
                }}
              >
                ✕
              </button>
            </div>
            <div style={{ padding: '1rem' }}>
              <FAQInteligente errorType="error" />
            </div>
          </div>
        </div>
      )}
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
