import { useState, useEffect } from "react";
import { useRuntimeAuth } from "../auth/RuntimeAuthContext";
import "./Login.css";

export default function Login() {

    const { setSession } = useRuntimeAuth();

    const [login, setLogin] = useState("");
    const [senha, setSenha] = useState("");
    const [choices, setChoices] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");
    const [contextsWithNames, setContextsWithNames] = useState({});

    function extractToken(data) {
        if (!data) return null;
        if (typeof data === "string") return data;
        return data.token || data.token_jwt || data.access_token || null;
    }

    function normalizeChoice(ctx) {
        if (!ctx || typeof ctx !== "object") return ctx;
        return {
            ...ctx,
            id_local_operacional: ctx.id_local_operacional ?? ctx.id_local ?? null
        };
    }

    // Buscar nomes dos contextos (unidades, sistemas, perfis)
    useEffect(() => {
        async function fetchContextNames() {
            if (!choices || choices.length === 0) return;
            
            try {
                const res = await fetch("/api/auth/contextos", {
                    headers: { "Authorization": `Bearer ${localStorage.getItem("runtime_token") || ""}` }
                });
                if (res.ok) {
                    const data = await res.json();
                    setContextsWithNames(data);
                }
            } catch (e) {
                console.log("Erro ao buscar nomes:", e);
            }
        }
        fetchContextNames();
    }, [choices]);

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
                setChoices(Array.isArray(data.choices) ? data.choices.map(normalizeChoice) : []);
                setLoading(false);
                return;
            }

            const token = extractToken(data);
            if (token) {
                const ok = setSession(token);
                if (!ok) {
                    setError("Token sem contexto operacional. Refaça o login.");
                    setLoading(false);
                    return;
                }

                window.location.href = "/operacional";
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

    async function handleSelectContext(ctx) {
        setLoading(true);
        try {
            const nctx = normalizeChoice(ctx);
            const res = await fetch("/api/auth/login", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    login,
                    senha,
                    id_unidade: nctx.id_unidade,
                    id_sistema: nctx.id_sistema,
                    id_local_operacional: nctx.id_local_operacional
                })
            });
            const data = await res.json();
            const token = extractToken(data);
            if (token) {
                const ok = setSession(token);
                if (!ok) {
                    setError("Sessão criada sem contexto operacional válido.");
                    setLoading(false);
                    return;
                }

                window.location.href = "/operacional";
                return;
            }
            setError(data.error || "Não foi possível criar sessão com o contexto selecionado");
        } catch {
            setError("Erro ao selecionar contexto");
        } finally {
            setLoading(false);
        }
    }

    // Função para formatar o nome do contexto
    function formatContextName(ctx) {
        const sistemas = contextsWithNames.sistemas || {};
        const unidades = contextsWithNames.unidades || {};
        const locais = contextsWithNames.locais || {};
        const perfis = contextsWithNames.perfis || {};

        const sistemaNome = sistemas[ctx.id_sistema] || `Sistema ${ctx.id_sistema}`;
        const unidadeNome = unidades[ctx.id_unidade] || `Unidade ${ctx.id_unidade}`;
        const localNome = ctx.id_local_operacional ? (locais[ctx.id_local_operacional] || `Local ${ctx.id_local_operacional}`) : null;
        const perfilNome = ctx.id_perfil ? (perfis[ctx.id_perfil] || `Perfil ${ctx.id_perfil}`) : null;

        return { sistemaNome, unidadeNome, localNome, perfilNome };
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
                            <h3>Escolha o contexto de trabalho</h3>
                            <p className="choices-subtitle">Você possui acesso a múltiplas áreas. Selecione onde deseja trabalhar:</p>
                            {choices.map((c, idx) => {
                                const { sistemaNome, unidadeNome, localNome, perfilNome } = formatContextName(c);
                                return (
                                    <div key={idx} className="context-option">
                                        <button type="button" onClick={() => handleSelectContext(c)} disabled={loading}>
                                            <div className="context-main">
                                                <span className="context-perfil">{perfilNome || c.id_perfil}</span>
                                                <span className="context-unidade">{unidadeNome}</span>
                                            </div>
                                            <div className="context-details">
                                                <span>{sistemaNome}</span>
                                                {localNome && <span>• {localNome}</span>}
                                            </div>
                                        </button>
                                    </div>
                                );
                            })}
                            <button 
                                type="button" 
                                className="btn-back"
                                onClick={() => { setChoices(null); setError(""); }}
                            >
                                ← Voltar
                            </button>
                        </div>
                    )}

                    <div className="login-footer">Suporte: contato@exemplo.com</div>
                </form>
            </div>
        </div>
    );
}
