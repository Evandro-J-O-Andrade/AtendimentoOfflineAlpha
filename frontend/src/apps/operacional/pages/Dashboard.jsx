import { useEffect, useState } from "react";
import Sidebar from "../../../components/Sidebar";
import { useRuntimeAuth } from "../auth/RuntimeAuthContext.jsx";

export default function Dashboard() {
    const { authFetch, session } = useRuntimeAuth();
    const [runtimeInfo, setRuntimeInfo] = useState(null);
    const [erro, setErro] = useState("");

    useEffect(() => {
        let ativo = true;

        async function carregarRuntime() {
            try {
                const res = await authFetch("/api/painel/painel");
                const data = await res.json();

                if (!res.ok) {
                    if (ativo) setErro(data?.erro || data?.error || "Falha ao carregar contexto do runtime");
                    return;
                }

                if (ativo) {
                    setRuntimeInfo(data?.runtime || null);
                }
            } catch {
                if (ativo) setErro("Erro de comunicação com API");
            }
        }

        carregarRuntime();
        return () => { ativo = false; };
    }, [authFetch]);

    return (
        <div style={{display:'flex',minHeight:'100vh'}}>
            <Sidebar />
            <main style={{flex:1,padding:24}}>
                <h1>Painel Operacional</h1>
                <p>Bem-vindo ao painel. Use a barra lateral para navegar.</p>

                <h2 style={{ marginTop: 24 }}>Sessão operacional</h2>
                <p>
                    Usuário: <strong>{session?.user?.id_usuario ?? "-"}</strong> | Sessão: <strong>{session?.user?.id_sessao_usuario ?? "-"}</strong>
                </p>
                <p>
                    Sistema: <strong>{session?.user?.id_sistema ?? "-"}</strong> | Unidade: <strong>{session?.user?.id_unidade ?? "-"}</strong> | Local: <strong>{session?.user?.id_local_operacional ?? "-"}</strong>
                </p>

                {erro && <p style={{ color: "#b91c1c" }}>{erro}</p>}

                {runtimeInfo && (
                    <pre style={{ background: "#f8fafc", padding: 12, borderRadius: 8, marginTop: 12 }}>
                        {JSON.stringify(runtimeInfo, null, 2)}
                    </pre>
                )}
            </main>
        </div>
    );
}
