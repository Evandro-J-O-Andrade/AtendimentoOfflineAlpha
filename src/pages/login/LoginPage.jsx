import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './LoginPage.css';

/**
 * LoginPage - Página de Autenticação
 * Design profissional com logo ALPHA, gradiente e animações
 */
export function LoginPage() {
  const navigate = useNavigate();
  const [credenciais, setCredenciais] = useState({
    usuario: '',
    senha: '',
  });
  const [carregando, setCarregando] = useState(false);
  const [erro, setErro] = useState('');
  const [mostrarSenha, setMostrarSenha] = useState(false);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setCredenciais({ ...credenciais, [name]: value });
    if (erro) setErro('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setCarregando(true);
    setErro('');

    try {
      // Simulação de chamada API
      // Em produção: await fetch('/api/auth/login', ...)
      
      // Validação básica
      if (!credenciais.usuario || !credenciais.senha) {
        setErro('Preencha usuário e senha');
        setCarregando(false);
        return;
      }

      // Simulação de delay
      await new Promise((resolve) => setTimeout(resolve, 1500));

      // Simulação de sucesso (em produção, valide com backend)
      if (credenciais.usuario === 'admin' && credenciais.senha === 'admin') {
        // Salvar token/sessão
        localStorage.setItem('usuario_logado', credenciais.usuario);
        localStorage.setItem('token', 'fake-jwt-token');
        
        // Redirecionar para painel
        navigate('/recepcao');
      } else {
        setErro('Usuário ou senha inválidos');
      }
    } catch (error) {
      setErro('Erro ao conectar ao servidor');
    } finally {
      setCarregando(false);
    }
  };

  return (
    <div className="login-page">
      {/* Background animado */}
      <div className="login-background">
        <div className="bg-shape bg-shape-1"></div>
        <div className="bg-shape bg-shape-2"></div>
        <div className="bg-shape bg-shape-3"></div>
      </div>

      {/* Container Principal */}
      <div className="login-container">
        {/* Lado Esquerdo - Informações */}
        <div className="login-left">
          <div className="login-brand">
            {/* Logo ALPHA */}
            <div className="alpha-logo">
              <div className="logo-icon">🏥</div>
              <div className="logo-text">
                <h1>ALPHA</h1>
                <p>Atendimento Offline</p>
              </div>
            </div>
          </div>

          <div className="login-info">
            <h2>Bem-vindo ao Sistema</h2>
            <p>
              Gerenciamento inteligente de filas e atendimento para pronto-socorros e clínicas.
            </p>

            <div className="info-features">
              <div className="feature">
                <span className="feature-icon">⚡</span>
                <span className="feature-text">Rápido e Responsivo</span>
              </div>
              <div className="feature">
                <span className="feature-icon">🔒</span>
                <span className="feature-text">Seguro e Confiável</span>
              </div>
              <div className="feature">
                <span className="feature-icon">📊</span>
                <span className="feature-text">Dados em Tempo Real</span>
              </div>
            </div>
          </div>

          <div className="login-footer">
            <p>© 2026 ALPHA - Atendimento Offline</p>
          </div>
        </div>

        {/* Lado Direito - Formulário */}
        <div className="login-right">
          <div className="login-form-container">
            <h2>Faça Login</h2>
            <p className="login-subtitle">Acesse o painel de controle</p>

            <form onSubmit={handleSubmit} className="login-form">
              {/* Campo Usuário */}
              <div className="form-group">
                <label htmlFor="usuario">
                  <span className="label-icon">👤</span>
                  Usuário
                </label>
                <input
                  id="usuario"
                  type="text"
                  name="usuario"
                  placeholder="Digite seu usuário"
                  value={credenciais.usuario}
                  onChange={handleChange}
                  disabled={carregando}
                  autoFocus
                />
              </div>

              {/* Campo Senha */}
              <div className="form-group">
                <label htmlFor="senha">
                  <span className="label-icon">🔐</span>
                  Senha
                </label>
                <div className="input-group">
                  <input
                    id="senha"
                    type={mostrarSenha ? 'text' : 'password'}
                    name="senha"
                    placeholder="Digite sua senha"
                    value={credenciais.senha}
                    onChange={handleChange}
                    disabled={carregando}
                  />
                  <button
                    type="button"
                    className="btn-toggle-senha"
                    onClick={() => setMostrarSenha(!mostrarSenha)}
                    disabled={carregando}
                    title={mostrarSenha ? 'Ocultar' : 'Mostrar'}
                  >
                    {mostrarSenha ? '👁️' : '👁️‍🗨️'}
                  </button>
                </div>
              </div>

              {/* Erro */}
              {erro && (
                <div className="alert alert-erro">
                  <span className="alert-icon">❌</span>
                  <span className="alert-text">{erro}</span>
                </div>
              )}

              {/* Checkbox Lembrar */}
              <div className="form-checkbox">
                <input
                  id="lembrar"
                  type="checkbox"
                  defaultChecked
                  disabled={carregando}
                />
                <label htmlFor="lembrar">Lembrar-me neste computador</label>
              </div>

              {/* Botão Login */}
              <button
                type="submit"
                className={`btn-login ${carregando ? 'loading' : ''}`}
                disabled={carregando}
              >
                {carregando ? (
                  <>
                    <span className="spinner"></span>
                    Conectando...
                  </>
                ) : (
                  '🔓 Entrar'
                )}
              </button>

              {/* Links Adicionais */}
              <div className="login-links">
                <a href="#" className="link">
                  Esqueceu a senha?
                </a>
                <span className="separator">•</span>
                <a href="#" className="link">
                  Suporte
                </a>
              </div>
            </form>

            {/* Credenciais de Teste */}
            <div className="login-test-info">
              <p className="test-label">🧪 Credenciais de Teste:</p>
              <code>
                Usuário: <strong>admin</strong> | Senha: <strong>admin</strong>
              </code>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default LoginPage;
