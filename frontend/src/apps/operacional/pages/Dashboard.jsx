import { useEffect, useState } from "react";
import Sidebar from "../../../components/Sidebar";
import { useAuth } from "../../../context/AuthProvider";
import spApi from "../../../api/spApi";

export default function Dashboard() {
    const { session } = useAuth();
    const [runtimeInfo, setRuntimeInfo] = useState(null);
    const [erro, setErro] = useState("");

    useEffect(() => {
        let ativo = true;

        async function carregarRuntime() {
            if (!session?.id_sessao) return;
            
            try {
                const data = await spApi.call('sp_painel_operacional', {
                    p_id_sessao: session.id_sessao
                });

                if (data?.sucesso && data?.resultado) {
                    if (ativo) {
                        setRuntimeInfo(data.resultado);
                    }
                } else {
                    if (ativo) setErro(data?.mensagem || "Falha ao carregar contexto do runtime");
                }
            } catch (e) {
                if (ativo) setErro(e.message || "Erro de comunicação com API");
            }
        }

        carregarRuntime();
        return () => { ativo = false; };
    }, [session]);

    return (
        <div style={{display:'flex',minHeight:'100vh'}}>
            <Sidebar />
            <main style={{flex:1,padding:24}}>
                <h1>Painel Operacional</h1>
                <p>Bem-vindo ao painel. Use a barra lateral para navegar.</p>

                <h2 style={{ marginTop: 24 }}>Sessão operacional</h2>
                <p>
                    Usuário: <strong>{session?.id_usuario ?? "-"}</strong> | Sessão: <strong>{session?.id_sessao ?? "-"}</strong>
                </p>
                <p>
                    Sistema: <strong>{session?.id_sistema ?? "-"}</strong> | Unidade: <strong>{session?.id_unidade ?? "-"}</strong> | Local: <strong>{session?.id_local ?? "-"}</strong>
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
