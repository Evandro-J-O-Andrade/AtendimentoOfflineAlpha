import { useState } from "react";
import { useRuntimeAuth } from "../auth/RuntimeAuthContext";
import "./Login.css";

export default function Login() {

    const { setSession } = useRuntimeAuth();

    const [login, setLogin] = useState("");
    const [senha, setSenha] = useState("");
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");

    function extractToken(data) {
        if (!data) return null;
        if (typeof data === "string") return data;
        return data.token || data.token_jwt || data.access_token || null;
    }

    async function handleLogin(e) {
        e.preventDefault();
        setError("");

        try {
            setLoading(true);

            const res = await fetch("/api/auth/login", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    login,
                    senha,
                    usar_novo_contexto: true  // Usa o novo serviço de contexto
                })
            });

            const data = await res.json();

            const token = extractToken(data);
            if (token) {
                const ok = setSession(token);
                if (!ok) {
                    setError("Token sem contexto operacional. Refaça o login.");
                    setLoading(false);
                    return;
                }

                window.location.href = "/contexto";
                return;
            }

            // if we get here, login failed
            const apiError = data?.error;
            if (apiError === "SEM_CONTEXTO" || apiError === "USUARIO_SEM_CONTEXTO") {
                setError("Seu usuário não possui contexto de acesso (sistema/unidade/local).");
            } else {
                setError(apiError || (res.ok ? "Credenciais inválidas" : "Falha ao autenticar"));
            }
            setLoading(false);

        } catch {
            setError("Erro ao realizar login");
            setLoading(false);
        }
    }

    return (
        <div className="login-wrap">
            <div className="page-banner">
                <div className="container">
                    <img src="/assets/img/logosenfundo.png" alt="Alpha logo" className="header-logo" />
                    <h1>Gestão de Pronto Atendimento Alpha</h1>
                </div>
            </div>
            <div className="login-card">
                <div className="login-banner">
                    <img src="/assets/img/prefeitura.png" alt="Prefeitura" />
                    <img src="/assets/img/sistema.png" alt="Sistema" />
                </div>
                <form onSubmit={handleLogin}>

                    <label>
                        👤 <span>Usuário</span>
                        <input
                            placeholder="Digite seu usuário"
                            value={login}
                            onChange={e => { setLogin(e.target.value); setError(""); }}
                        />
                    </label>

                    <label>
                        🔐 <span>Senha</span>
                        <input
                            type="password"
                            placeholder="Digite sua senha"
                            value={senha}
                            onChange={e => { setSenha(e.target.value); setError(""); }}
                        />
                    </label>

                    {error && <div className="error-msg">{error}</div>}

                    <button type="submit" disabled={loading}>
                        {loading ? <span className="spinner"/> : "Entrar"}
                    </button>

                    <div className="login-footer">Suporte: contato@exemplo.com</div>
                </form>
            </div>
        </div>
    );
}
