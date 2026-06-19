import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Eye, EyeOff, LogIn } from "lucide-react";
import { useAuth } from "@/app/providers/AuthProvider";

export default function LoginForm() {
  const [usuario, setUsuario] = useState("");
  const [senha, setSenha] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const navigate = useNavigate();
  const { login } = useAuth();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError("");

    try {
      const result = await login({ login: usuario, senha });
      if (result.sucesso) {
        navigate("/portal");
      } else {
        setError(result.mensagem || "Usuário ou senha inválidos");
      }
    } catch (err: any) {
      setError(err.message || "Erro ao conectar ao servidor");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="w-full max-w-md">

      <div className="bg-slate-900 border border-slate-800 rounded-3xl p-10 shadow-2xl">

        <div className="mb-10">

          <h2 className="text-3xl font-bold text-white">
            Acessar Plataforma
          </h2>

          <p className="text-slate-400 mt-2">
            Entre com suas credenciais corporativas
          </p>

        </div>

        <form className="space-y-5" onSubmit={handleSubmit}>

          <div>
            <label className="block text-sm text-slate-300 mb-2">
              Usuário
            </label>

            <input
              type="text"
              value={usuario}
              onChange={(e) => setUsuario(e.target.value)}
              placeholder="Digite seu usuário"
              className="w-full h-12 px-4 rounded-xl bg-slate-800 border border-slate-700 text-white focus:border-cyan-500 outline-none"
            />
          </div>

          <div>
            <label className="block text-sm text-slate-300 mb-2">
              Senha
            </label>

            <div className="relative">

              <input
                type={showPassword ? "text" : "password"}
                value={senha}
                onChange={(e) => setSenha(e.target.value)}
                placeholder="********"
                className="w-full h-12 px-4 rounded-xl bg-slate-800 border border-slate-700 text-white focus:border-cyan-500 outline-none"
              />

              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400"
              >
                {showPassword ? (
                  <EyeOff size={18} />
                ) : (
                  <Eye size={18} />
                )}
              </button>

            </div>
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full h-12 rounded-xl bg-cyan-500 hover:bg-cyan-600 text-white font-bold flex items-center justify-center gap-2 disabled:opacity-50"
          >
            <LogIn size={18} />
            {loading ? "Entrando..." : "Entrar"}
          </button>

          {error && (
            <div className="mt-4 p-3 rounded-lg bg-red-500/10 border border-red-500/30 text-red-400 text-sm">
              {error}
            </div>
          )}

        </form>

        <div className="mt-8 border-t border-slate-800 pt-6 text-center">

          <p className="text-xs text-slate-500">
            Powered by New Wave Enterprise
          </p>

          <p className="text-xs text-slate-600 mt-1">
            © 2026 New Wave Sistemas Digitais
          </p>

        </div>

      </div>

    </div>
  );
}