import { useState, type FormEvent } from 'react';
import { useAuth } from '@atendimentooffline/auth';
import type { LoginRequestContract } from '@atendimentooffline/contracts';
import type { AuthenticationState } from '@atendimentooffline/contracts';
import styles from './LoginPage.module.css';

export function LoginPage() {
  const { login, loading, authenticated } = useAuth();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [mfaCode, setMfaCode] = useState('');
  const [authState, setAuthState] =
    useState<AuthenticationState>('UNAUTHENTICATED');

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
    } catch (err) {
      setError('Erro de conexão');
      setAuthState('ERROR');
    }
  }

  if (loading && authState === 'AUTHENTICATING') {
    return (
      <div className={styles.container}>
        <p className={styles.status}>Autenticando...</p>
      </div>
    );
  }

  if (authenticated) {
    return (
      <div className={styles.container}>
        <p className={styles.status}>Redirecionando...</p>
      </div>
    );
  }

  if (authState === 'MFA_REQUIRED') {
    return (
      <form onSubmit={handleSubmit} className={styles.cardForm}>
        <h1 className={styles.title}>MFA</h1>
        <input
          className={styles.input}
          type="text"
          value={mfaCode}
          onChange={(e) => setMfaCode(e.target.value)}
          placeholder="Código MFA"
        />
        <button className={styles.button} type="submit">
          Confirmar
        </button>
        {error && <p className={styles.error}>{error}</p>}
      </form>
    );
  }

  return (
    <div
      className={styles.wrapper}
      style={{ backgroundImage: `url('/assets/login/teladelogin.png')` }}
    >
      <div className={styles.overlay} />
      <section className={styles.rightPanel}>
        <div className={styles.panelHeader}>
          <div className={styles.branding}>
            <img
              src="/assets/branding/logoSaaS.png"
              alt="New Wave SaaS"
              className={styles.logoSaaS}
            />
            <span>New Wave Enterprise</span>
          </div>
          <div className={styles.themeBadge}>Modo escuro</div>
        </div>

        <div className={styles.titleBlock}>
          <h1>
            Bem-vindo ao <span>New Wave Enterprise</span>
          </h1>
          <p>
            Acesse sua conta para continuar gerenciando sua empresa com
            eficiência e inteligência.
          </p>
        </div>

        <form className={styles.cardForm} onSubmit={handleSubmit}>
          <label className={styles.label}>
            <span>Usuário</span>
            <input
              className={styles.input}
              type="text"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              placeholder="Digite seu usuário"
            />
          </label>
          <label className={styles.label}>
            <span>Senha</span>
            <input
              className={styles.input}
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Digite sua senha"
            />
          </label>
          <div className={styles.formRow}>
            <label className={styles.checkboxLabel}>
              <input type="checkbox" />
              Lembrar de mim
            </label>
            <a href="#" className={styles.forgotLink}>
              Esqueceu sua senha?
            </a>
          </div>
          <button className={styles.button} type="submit" disabled={loading}>
            Entrar
          </button>
          {error && <p className={styles.error}>{error}</p>}
          <div className={styles.securityInfo}>
            <div>
              <strong>Segurança</strong>
              <p>Avançada</p>
            </div>
            <div>
              <strong>Alta</strong>
              <p>Disponibilidade</p>
            </div>
            <div>
              <strong>Conformidade</strong>
              <p>LGPD</p>
            </div>
          </div>
        </form>
      </section>

      <footer className={styles.footerBar}>
        <div className={styles.footerBrand}>
          <img
            src="/assets/branding/logoSaaS.png"
            alt="New Wave"
            className={styles.footerLogo}
          />
          <span>New Wave Enterprise</span>
        </div>
        <div className={styles.footerInfo}>
          <span>v1.0.0</span>
          <span>© 2026 New Wave Sistemas Digitais</span>
        </div>
      </footer>
    </div>
  );
}
