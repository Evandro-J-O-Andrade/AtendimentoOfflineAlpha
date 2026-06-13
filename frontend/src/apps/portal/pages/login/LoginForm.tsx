import { useState, FormEvent } from "react";
import { Eye, EyeOff, LogIn } from "lucide-react";

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
    <div className="min-h-screen flex">
      <div className="hidden lg:flex lg:w-1/2 relative overflow-hidden bg-gradient-to-br from-indigo-600 via-purple-600 to-indigo-800">
        <SvgBackground />
        <div className="relative z-10 flex flex-col justify-center items-center p-12 text-white">
          <div className="max-w-md text-center space-y-6">
            <h1 className="text-4xl font-black">New Wave Enterprise</h1>
            <p className="text-lg opacity-90">Enterprise Management & Analytics Platform</p>
            <p className="text-sm opacity-70">Plataforma Corporativa de Gestão e Inteligência Analítica</p>
          </div>
        </div>
      </div>

      <div className="w-full lg:w-1/2 flex items-center justify-center p-8 bg-slate-50 dark:bg-slate-950">
        <div className="w-full max-w-md space-y-8">
          <div className="text-center lg:hidden">
            <h1 className="text-3xl font-black text-slate-900 dark:text-white">
              New Wave Enterprise
            </h1>
            <p className="text-slate-500 dark:text-slate-400 mt-2">
              Enterprise Management & Analytics Platform
            </p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-6">
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-bold text-slate-700 dark:text-slate-300 mb-2">
                  Usuário
                </label>
                <input
                  type="text"
                  value={usuario}
                  onChange={(e) => setUsuario(e.target.value)}
                  placeholder="seu@email.com"
                  className="w-full h-12 px-4 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 text-slate-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all"
                  required
                  disabled={loading}
                />
              </div>

              <div>
                <label className="block text-sm font-bold text-slate-700 dark:text-slate-300 mb-2">
                  Senha
                </label>
                <div className="relative">
                  <input
                    type={showPassword ? "text" : "password"}
                    value={senha}
                    onChange={(e) => setSenha(e.target.value)}
                    placeholder="••••••••"
                    className="w-full h-12 px-4 pr-12 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 text-slate-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all"
                    required
                    disabled={loading}
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-300"
                  >
                    {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                  </button>
                </div>
              </div>
            </div>

            {error && (
              <div className="p-3 rounded-lg bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800">
                <p className="text-sm text-red-600 dark:text-red-400">{error}</p>
              </div>
            )}

            <button
              type="submit"
              disabled={loading}
              className="w-full h-12 flex items-center justify-center gap-2 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-bold transition-all disabled:opacity-50"
            >
              {loading ? (
                <span>Entrando...</span>
              ) : (
                <>
                  <LogIn size={18} />
                  <span>Entrar</span>
                </>
              )}
            </button>
          </form>

          <Footer />
        </div>
      </div>
    </div>
  );
}

function SvgBackground() {
  return (
    <div className="absolute inset-0">
      <svg className="w-full h-full" viewBox="0 0 800 600" preserveAspectRatio="none">
        <defs>
          <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stopColor="rgba(79, 70, 229, 0.3)" />
            <stop offset="50%" stopColor="rgba(168, 85, 247, 0.2)" />
            <stop offset="100%" stopColor="rgba(219, 39, 119, 0.1)" />
          </linearGradient>
        </defs>
        <circle cx="100" cy="100" r="80" fill="url(#grad1)" className="animate-float" />
        <circle cx="700" cy="150" r="120" fill="url(#grad1)" className="animate-float" style={{ animationDelay: "1s" }} />
        <circle cx="600" cy="450" r="100" fill="url(#grad1)" className="animate-float" style={{ animationDelay: "2s" }} />
        <circle cx="200" cy="500" r="60" fill="url(#grad1)" className="animate-float" style={{ animationDelay: "3s" }} />
        <rect x="300" y="300" width="200" height="200" rx="40" fill="rgba(255,255,255,0.05)" className="animate-float" />
      </svg>
    </div>
  );
}

function Footer() {
  const year = new Date().getFullYear();
  return (
    <footer className="pt-8 border-t border-slate-200 dark:border-slate-800">
      <p className="text-center text-xs text-slate-400">
        &copy; {year} New Wave Sistemas Digitais
        <br />
        <span className="text-slate-500">Powered by New Wave Enterprise</span>
        <br />
        Fundador e CEO: Evandro Andrade
      </p>
    </footer>
  );
}