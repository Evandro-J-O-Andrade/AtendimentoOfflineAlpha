import React, { useState } from "react";
import { Eye, EyeOff, LogIn } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../apps/operacional/auth/AuthProvider";
import { getPortalBranding } from "../apps/portal/services/branding";
import "./login.css";

export default function LoginPage() {
  const { login, loading } = useAuth();
  const navigate = useNavigate();
  const brand = getPortalBranding();
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
      
      navigate("/portal");
      
    } catch (err) {
      console.error(err);
      setError("Erro interno, tente novamente");
    }
  };

  if (loading) return <div className="login-loading">Carregando...</div>;

  return (
    <div className="login-page">
      <div className="login-header">
        <div className="login-brand-mark">
          {brand.logoUrl ? (
            <img src={brand.logoUrl} alt="" onError={(e) => { e.currentTarget.style.display = "none"; }} />
          ) : (
            <span>NW</span>
          )}
        </div>
        <div>
          <strong>{brand.organizationName}</strong>
          <small>{brand.companyName}</small>
        </div>
      </div>
      
      <h1 className="login-titulo">{brand.productName}</h1>
      <p className="login-subtitulo">Acesso corporativo</p>
      
      <div className="login-container">
        <form onSubmit={handleLogin} className="login-form">
          <h2>Entrar</h2>

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
                role="button"
                tabIndex={0}
                aria-label={mostrarSenha ? "Ocultar senha" : "Mostrar senha"}
                onKeyDown={(e) => {
                  if (e.key === "Enter" || e.key === " ") setMostrarSenha(!mostrarSenha);
                }}
              >
                {mostrarSenha ? <EyeOff size={18} /> : <Eye size={18} />}
              </span>
            </div>
          </div>

          <button type="submit">
            <LogIn size={18} />
            Entrar
          </button>
        </form>
      </div>
    </div>
  );
}
