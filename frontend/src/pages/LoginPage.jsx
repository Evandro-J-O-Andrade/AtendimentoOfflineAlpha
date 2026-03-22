import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../apps/operacional/auth/AuthProvider";
import "./login.css";

export default function LoginPage() {
  const { login, loading } = useAuth();
  const navigate = useNavigate();
  const [loginInput, setLogin] = useState("");
  const [senha, setSenha] = useState("");
  const [mostrarSenha, setMostrarSenha] = useState(false);
  const [error, setError] = useState("");

  const handleLogin = async (e) => {
    e.preventDefault();
    setError("");
    try {
      const resultado = await login({ login: loginInput, senha });
      if (!resultado.sucesso) {
        setError(resultado.mensagem || "Usuário ou senha inválidos");
        return;
      }
      
      // Se há múltiplos contextos, redireciona para seleção
      if (resultado.temContexto) {
        navigate("/contexto");
      } else {
        navigate("/operacional");
      }
    } catch (err) {
      console.error(err);
      setError("Erro interno, tente novamente");
    }
  };

  if (loading) return <div className="login-loading">Carregando...</div>;

  return (
    <div className="login-page">
      {/* Header com imagens - esquerda e direita */}
      <div className="login-header">
        <div className="login-header-left">
          <img 
            src="/assets/img/prefeitura.png" 
            alt="Prefeitura" 
            className="login-logo-left"
            onError={(e) => {e.target.style.display = 'none'}}
          />
        </div>
        <div className="login-header-right">
          <img 
            src="/assets/img/sistema.png" 
            alt="Sistema" 
            className="login-logo-right"
            onError={(e) => {e.target.style.display = 'none'}}
          />
        </div>
      </div>
      
      {/* Título principal */}
      <h1 className="login-titulo">Pronto Atendimento Alpha</h1>
      <p className="login-subtitulo">Unidade Guido Guida</p>
      
      {/* Container de login */}
      <div className="login-container">
        <form onSubmit={handleLogin} className="login-form">
          <h2>Login</h2>

          {error && <div className="error">{error}</div>}

          <div>
            <label>Usuário</label>
            <input
              type="text"
              value={loginInput}
              onChange={(e) => setLogin(e.target.value)}
              required
            />
          </div>

          <div className="senha-container">
            <label>Senha</label>
            <div className="senha-input-wrapper">
              <input
                type={mostrarSenha ? "text" : "password"}
                value={senha}
                onChange={(e) => setSenha(e.target.value)}
                required
              />
              <span
                className="senha-toggle"
                onClick={() => setMostrarSenha(!mostrarSenha)}
              >
                {mostrarSenha ? "🔒" : "👁"}
              </span>
            </div>
          </div>

          <button type="submit">Entrar</button>
        </form>
      </div>
      
      {/* Imagem de fundo */}
      <img 
        src="/assets/img/logoSemFundo.png" 
        alt="" 
        className="login-bg"
        onError={(e) => {e.target.style.display = 'none'}}
      />
    </div>
  );
}
