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
        <>
            <div className="hidden lg:block lg:w-1/2 relative overflow-hidden">
                <img
                    src="/assets/img/nwlogin.png"
                    alt="New Wave Enterprise"
                    className="absolute inset-0 w-full h-full object-cover"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-slate-900/40 to-transparent" />
            </div>

            <div className="w-full lg:w-1/2 flex items-center justify-center p-8 bg-slate-50 dark:bg-slate-950">
                <div className="w-full max-w-md space-y-8">
                    <div className="text-center lg:hidden space-y-2">
                        <h1 className="text-3xl font-black text-slate-900 dark:text-white">
                            New Wave Enterprise
                        </h1>
                        <p className="text-slate-500 dark:text-slate-400">
                            Enterprise Management &amp; Analytics Platform
                        </p>
                    </div>

                    <form onSubmit={handleSubmit} className="space-y-6">
                        <div className="space-y-4">
                            <div>
                                <label className="block text-sm font-bold text-slate-700 dark:text-slate-300 mb-2">
                                    Usuário
                                </label>
                                <div className="relative">
                                    <input
                                        type="text"
                                        value={usuario}
                                        onChange={(e) => setUsuario(e.target.value)}
                                        placeholder="seu@email.com"
                                        className="w-full h-12 pl-4 pr-12 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 text-slate-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all"
                                        required
                                        disabled={loading}
                                    />
                                </div>
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
                                        className="w-full h-12 pl-4 pr-12 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 text-slate-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all"
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
        </>
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