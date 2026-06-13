import React, { useState } from 'react';
import { useAuth } from '../../context/AuthContext';

/**
 * LoginPage - New Wave Enterprise
 * Seguindo LEI CANÔNICA 3: Login Global, Identidade de Plataforma.
 */
const LoginPage: React.FC = () => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const { login } = useAuth();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      await login(username, password);
      // O AuthContext deve redirecionar para o /portal obrigatoriamente
    } catch (err) {
      console.error("Erro na autenticação global");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex bg-slate-50 font-sans">
      {/* Lado Esquerdo: Ilustração SVG Abstrata (Visual Premium) */}
      <div className="hidden lg:flex lg:w-1/2 bg-gradient-to-br from-indigo-900 via-slate-900 to-black p-12 flex-col justify-between relative overflow-hidden">
        <div className="relative z-10">
          <div className="flex items-center gap-3 mb-8">
            <div className="w-10 h-10 bg-indigo-500 rounded-lg flex items-center justify-center shadow-lg shadow-indigo-500/50">
               <svg viewBox="0 0 24 24" className="w-6 h-6 text-white fill-current"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5-10-5-10 5z"/></svg>
            </div>
            <h1 className="text-2xl font-bold text-white tracking-tight">New Wave <span className="text-indigo-400">Enterprise</span></h1>
          </div>
          <h2 className="text-4xl font-extrabold text-white leading-tight mb-4">
            Enterprise Management & <br/>
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-indigo-400 to-cyan-400">Analytics Platform</span>
          </h2>
          <p className="text-slate-400 text-lg max-w-md">Plataforma Corporativa de Gestão e Inteligência Analítica.</p>
        </div>

        {/* Elementos SVG Abstratos de Fundo */}
        <svg className="absolute bottom-0 right-0 w-full h-full opacity-20" viewBox="0 0 800 800">
          <circle cx="400" cy="800" r="300" fill="url(#grad1)" />
          <defs>
            <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" style={{stopColor:'#4f46e5', stopOpacity:1}} />
              <stop offset="100%" style={{stopColor:'#06b6d4', stopOpacity:1}} />
            </linearGradient>
          </defs>
        </svg>

        <div className="relative z-10 text-slate-500 text-sm">
          <p>© New Wave Sistemas Digitais • Powered by New Wave Enterprise</p>
        </div>
      </div>

      {/* Lado Direito: Formulário Clean */}
      <div className="w-full lg:w-1/2 flex items-center justify-center p-8 md:p-16">
        <div className="max-w-md w-full">
          <div className="mb-10">
            <h3 className="text-3xl font-bold text-slate-900 mb-2">Login</h3>
            <p className="text-slate-500">Insira suas credenciais para acessar a plataforma.</p>
          </div>

          <form onSubmit={handleLogin} className="space-y-6">
            <div>
              <label className="block text-sm font-semibold text-slate-700 mb-2">Usuário</label>
              <input 
                type="text" 
                className="w-full px-4 py-3 rounded-xl border border-slate-200 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all outline-none"
                placeholder="nome.sobrenome"
                value={username}
                onChange={e => setUsername(e.target.value)}
                required
              />
            </div>
            <div>
              <label className="block text-sm font-semibold text-slate-700 mb-2">Senha</label>
              <input 
                type="password" 
                className="w-full px-4 py-3 rounded-xl border border-slate-200 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all outline-none"
                placeholder="••••••••"
                value={password}
                onChange={e => setPassword(e.target.value)}
                required
              />
            </div>

            <div className="flex items-center justify-between text-sm">
              <label className="flex items-center gap-2 text-slate-600 cursor-pointer">
                <input type="checkbox" className="rounded text-indigo-600 focus:ring-indigo-500" />
                Lembrar neste dispositivo
              </label>
              <a href="#" className="text-indigo-600 font-semibold hover:underline">Esqueceu a senha?</a>
            </div>

            <button 
              type="submit" 
              disabled={loading}
              className="w-full py-4 bg-slate-900 hover:bg-black text-white rounded-xl font-bold shadow-lg transition-all transform active:scale-[0.98] flex justify-center items-center"
            >
              {loading ? <div className="w-6 h-6 border-2 border-white/30 border-t-white rounded-full animate-spin"></div> : 'Entrar na Plataforma'}
            </button>
          </form>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
