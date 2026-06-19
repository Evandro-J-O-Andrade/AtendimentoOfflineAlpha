import { useState, FormEvent } from "react";
import { Eye, EyeOff } from "lucide-react";
import "./Login.css";

interface LoginFormProps {
  loading: boolean;
  error: string | null;
  onSubmit: (data: { usuario: string; senha: string }) => void;
}

export default function LoginForm({ loading, error, onSubmit }: LoginFormProps) {
  const [usuario, setUsuario] = useState("");
  const [senha, setSenha] = useState("");
  const [showPassword, setShowPassword] = useState(false);

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    if (!loading) onSubmit({ usuario, senha });
  };

  return (
    <div className="login-page">
      {/* Lado da Imagem */}
      <div className="image-side"></div>

      {/* Lado do Formulário */}
      <div className="form-side">
        <div className="form-wrapper">
          <h1 style={{ fontSize: '32px', marginBottom: '10px' }}>Entrar</h1>
          <p style={{ color: '#888', marginBottom: '40px' }}>Insira seus dados para acessar.</p>

          <div className="input-group">
            <label className="input-label">Usuário</label>
            <input
              type="text"
              className="input-field"
              placeholder="Digite seu usuário"
              value={usuario}
              onChange={(e) => setUsuario(e.target.value)}
              disabled={loading}
            />
          </div>

          <div className="input-group">
            <label className="input-label">Senha</label>
            <div style={{ position: 'relative' }}>
              <input
                type={showPassword ? "text" : "password"}
                className="input-field"
                placeholder="••••••••"
                value={senha}
                onChange={(e) => setSenha(e.target.value)}
                disabled={loading}
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                disabled={loading}
                style={{
                  position: 'absolute',
                  right: 0,
                  top: '50%',
                  transform: 'translateY(-50%)',
                  background: 'none',
                  border: 'none',
                  color: '#A0A0A0',
                  cursor: 'pointer'
                }}
              >
                {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
              </button>
            </div>
          </div>

          {error && (
            <div style={{
              padding: '8px',
              marginBottom: '15px',
              fontSize: '12px',
              color: '#dc2626',
              backgroundColor: '#fef2f2'
            }}>
              {error}
            </div>
          )}

          <button className="login-btn" disabled={loading}>
            {loading ? "Entrando..." : "ACESSAR"}
          </button>

          <div style={{ textAlign: 'center', marginTop: '20px' }}>
            <a href="#" style={{ fontSize: '11px', color: '#B0B0B0', textDecoration: 'none' }}>Esqueceu sua senha?</a>
          </div>
        </div>

        {/* Rodapé fixo na parte inferior */}
        <div style={{
          position: 'absolute',
          bottom: '20px',
          fontSize: '9px',
          color: '#D0D0D0',
          letterSpacing: '2px',
          textAlign: 'center',
          width: '100%'
        }}>
          © 2026 NEW WAVE SYSTEM - TODOS OS DIREITOS RESERVADOS
        </div>
      </div>
    </div>
  );
}