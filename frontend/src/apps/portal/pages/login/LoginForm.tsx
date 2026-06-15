import { useState, FormEvent } from "react";
import { Eye, EyeOff } from "lucide-react";

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
    <div className="flex h-screen w-full">
      {/* Lado da Imagem */}
      <div className="w-3/5 bg-[url('/assets/img/nwlogin.png')] bg-center bg-cover bg-no-repeat" />

      {/* Lado do Formulário */}
      <div className="w-2/5 flex flex-col justify-center pl-16 bg-white">
        <div className="w-72">
          <h1 className="text-2xl font-bold mb-1">Entrar</h1>
          <p className="text-slate-400 text-sm mb-10">Insira seus dados para acessar o sistema.</p>

          <div className="mb-5">
            <label className="block text-[9px] font-bold text-slate-300 uppercase tracking-wider mb-1">
              Usuário
            </label>
            <input
              type="text"
              className="w-full border-none border-b border-slate-200 py-[6px] text-sm outline-none text-slate-800"
              placeholder="Digite seu usuário"
              value={usuario}
              onChange={(e) => setUsuario(e.target.value)}
              disabled={loading}
            />
          </div>

          <div className="mb-5">
            <label className="block text-[9px] font-bold text-slate-300 uppercase tracking-wider mb-1">
              Senha
            </label>
            <div className="relative">
              <input
                type={showPassword ? "text" : "password"}
                className="w-full border-none border-b border-slate-200 py-[6px] text-sm outline-none text-slate-800"
                placeholder="••••••••"
                value={senha}
                onChange={(e) => setSenha(e.target.value)}
                disabled={loading}
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                disabled={loading}
                className="absolute right-0 top-1/2 -translate-y-1/2 bg-transparent border-none text-slate-400 cursor-pointer"
              >
                {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
              </button>
            </div>
          </div>

          {error && (
            <div className="px-2 mb-4 text-xs text-red-600 bg-red-50">
              {error}
            </div>
          )}

          <button 
            className="w-full bg-brand-primary text-white border-none py-2.5 text-xs font-bold cursor-pointer mt-2.5 hover:bg-brand-primary/90 transition-colors" 
            disabled={loading}
          >
            {loading ? "Entrando..." : "ACESSAR"}
          </button>

          <div className="mt-5">
            <a href="#" className="text-[10px] text-slate-300 no-underline">
              Esqueceu sua senha?
            </a>
          </div>
        </div>

        {/* Rodapé fixo na parte inferior */}
        <div className="absolute bottom-8 left-16 text-[8px] text-slate-300 tracking-wider">
          © 2026 NEW WAVE SYSTEM - TODOS OS DIREITOS RESERVADOS
        </div>
      </div>
    </div>
  );
}