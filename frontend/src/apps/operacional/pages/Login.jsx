import { useState } from "react";
import { useRuntimeAuth } from "../auth/RuntimeAuthContext";
import "./Login.css";

export default function Login() {

    const { setSession } = useRuntimeAuth();

    const [login, setLogin] = useState("");
    const [senha, setSenha] = useState("");
    const [idCidade, setIdCidade] = useState("");
    const [idUnidade, setIdUnidade] = useState("");
    const [idSistema, setIdSistema] = useState("");
    const [choices, setChoices] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");

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
                    senha
                })
            });

            const data = await res.json();

            // multiple contexts -> present choices to user
            if (data && data.choices) {
                setChoices(data.choices);
                setLoading(false);
                return;
            }

            // token may be returned as a plain string or as { token: '...' }
            const token = typeof data === "string" ? data : data.token;
            if (token) {
                localStorage.setItem("runtime_token", token);
                setSession(token);
                window.location.href = "/operacional";
                return;
            }

            // if we get here, login failed
            setError(data.error || "Credenciais inválidas");
            setLoading(false);

        } catch {
            setError("Erro ao realizar login");
            setLoading(false);
        }
    }

    async function handleSelectContext(ctx) {
        setLoading(true);
        try {
            const res = await fetch("/api/auth/login", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    login,
                    senha,
                    id_cidade: ctx.id_cidade,
                    id_unidade: ctx.id_unidade,
                    id_sistema: ctx.id_sistema,
                    id_local_operacional: ctx.id_local_operacional
                })
            });
            const data = await res.json();
            const token = typeof data === "string" ? data : data.token;
            if (token) {
                localStorage.setItem("runtime_token", token);
                setSession(token);
                window.location.href = "/operacional";
                return;
            }
            alert("Não foi possível criar sessão com o contexto selecionado");
        } catch (err) {
            alert("Erro ao selecionar contexto");
        } finally {
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

                    {!choices && (
                        <>
                            <button type="submit" disabled={loading}>
                                {loading ? <span className="spinner"/> : "Entrar"}
                            </button>
                        </>
                    )}

                    {choices && (
                        <div className="login-choices">
                            <h3>Escolha o contexto</h3>
                            {choices.map((c, idx) => (
                                <div key={idx}>
                                    <button type="button" onClick={() => handleSelectContext(c)} disabled={loading}>
                                        Unidade {c.id_unidade} — Sistema {c.id_sistema} — Cidade {c.id_cidade}
                                        {c.id_local_operacional ? ` — Setor ${c.id_local_operacional}` : ''}
                                        {c.id_perfil ? ` — Perfil ${c.id_perfil}` : ''}
                                    </button>
                                </div>
                            ))}
                        </div>
                    )}

                    <div className="login-footer">Suporte: contato@exemplo.com</div>
                </form>
            </div>
        </div>
    );
}