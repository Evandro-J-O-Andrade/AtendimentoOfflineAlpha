import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Eye, EyeOff, Lock, User } from "lucide-react";
import { useAuth } from "../operacional/auth/AuthProvider";

/** Formulário de autenticação (usuário + senha). */
export function LoginForm() {
  const { login } = useAuth();
  const navigate = useNavigate();

  const [usuario, setUsuario] = useState("");
  const [senha, setSenha] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [remember, setRemember] = useState(true);
  const [error, setError] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setSubmitting(true);
    try {
      const result = await login({ login: usuario, senha });
      if (!result?.sucesso) {
        setError(result?.mensagem || "Usuário ou senha inválidos");
        return;
      }
      // Após autenticar, o usuário entra no Portal Corporativo.
      navigate("/portal");
    } catch {
      setError("Erro interno, tente novamente");
    } finally {
      setSubmitting(false);
    }
  };

  const fieldClasses =
    "flex items-center gap-3 rounded-2xl border border-[var(--surface-border)] bg-[var(--surface)] px-4 py-3.5 backdrop-blur-md transition-colors focus-within:border-primary-bright";

  return (
    <form onSubmit={handleSubmit} className="flex flex-col gap-5">
      {error && (
        <div className="rounded-xl border border-[var(--surface-border)] bg-[var(--surface-strong)] px-4 py-3 text-sm text-[var(--text-base)]">
          {error}
        </div>
      )}

      <div className="flex flex-col gap-2">
        <label htmlFor="nw-user" className="text-sm font-medium text-[var(--text-base)]">
          Usuário
        </label>
        <div className={fieldClasses}>
          <User size={18} className="shrink-0 text-[var(--text-muted)]" />
          <input
            id="nw-user"
            type="text"
            autoComplete="username"
            placeholder="Digite seu usuário"
            value={usuario}
            onChange={(e) => setUsuario(e.target.value)}
            required
            className="w-full text-[var(--text-strong)]"
          />
        </div>
      </div>

      <div className="flex flex-col gap-2">
        <label htmlFor="nw-pass" className="text-sm font-medium text-[var(--text-base)]">
          Senha
        </label>
        <div className={fieldClasses}>
          <Lock size={18} className="shrink-0 text-[var(--text-muted)]" />
          <input
            id="nw-pass"
            type={showPassword ? "text" : "password"}
            autoComplete="current-password"
            placeholder="Digite sua senha"
            value={senha}
            onChange={(e) => setSenha(e.target.value)}
            required
            className="w-full text-[var(--text-strong)]"
          />
          <button
            type="button"
            onClick={() => setShowPassword((v) => !v)}
            aria-label={showPassword ? "Ocultar senha" : "Mostrar senha"}
            className="shrink-0 text-[var(--text-muted)] transition-colors hover:text-[var(--text-strong)]"
          >
            {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
          </button>
        </div>
      </div>

      <div className="flex items-center justify-between">
        <label className="flex cursor-pointer items-center gap-2 text-sm text-[var(--text-base)]">
          <input
            type="checkbox"
            checked={remember}
            onChange={(e) => setRemember(e.target.checked)}
            className="h-4 w-4 rounded accent-[var(--primary)]"
          />
          Lembrar de mim
        </label>
        <a href="#" className="text-sm font-medium text-primary-bright hover:underline">
          Esqueceu sua senha?
        </a>
      </div>

      <button
        type="submit"
        disabled={submitting}
        className="mt-1 rounded-2xl bg-gradient-to-r from-primary to-secondary py-4 text-base font-semibold text-white shadow-lg shadow-[var(--glow-primary)] transition-transform duration-200 hover:scale-[1.03] hover:shadow-[0_0_32px_var(--glow-secondary)] disabled:cursor-not-allowed disabled:opacity-70 disabled:hover:scale-100"
      >
        {submitting ? "Entrando..." : "Entrar"}
      </button>
    </form>
  );
}
