import { useEffect, useMemo, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { useRuntimeAuth } from "../../operacional/auth/RuntimeAuthContext";
import "./AdminModulePage.css";

const FALLBACK_MODULES = {
    usuarios: {
        title: "Cadastro de Usuarios",
        subtitle: "Gestao completa de usuarios, perfis e vinculos operacionais",
        actions: []
    },
    unidades: {
        title: "Unidades e Locais",
        subtitle: "Configuracao de unidades, salas de atendimento e estruturas",
        actions: []
    },
    totem: {
        title: "Totem e Senhas",
        subtitle: "Fluxo de emissao de senha e direcionamento inicial",
        actions: []
    },
    recepcao: {
        title: "Recepcao",
        subtitle: "Registro inicial e abertura do atendimento do paciente",
        actions: []
    },
    triagem: {
        title: "Triagem",
        subtitle: "Classificacao de risco e pre-atendimento",
        actions: []
    },
    medico: {
        title: "Atendimento Medico",
        subtitle: "Consulta clinica, evolucao, prescricao e solicitacoes",
        actions: []
    },
    enfermagem: {
        title: "Enfermagem",
        subtitle: "Execucao assistencial e acompanhamento de pacientes",
        actions: []
    },
    farmacia: {
        title: "Farmacia",
        subtitle: "Dispensacao e rastreabilidade",
        actions: []
    },
    estoque: {
        title: "Estoque",
        subtitle: "Lotes, movimentacoes e produtos",
        actions: []
    },
    atendimento: {
        title: "Atendimento",
        subtitle: "Transicoes e encerramentos do atendimento",
        actions: []
    },
    fila: {
        title: "Fila Operacional",
        subtitle: "Chamadas e finalizacao de filas por setor",
        actions: []
    },
    relatorios: {
        title: "Relatorios",
        subtitle: "Indicadores e relatorios gerenciais do atendimento",
        actions: []
    }
};

export default function AdminModulePage() {
    const navigate = useNavigate();
    const { logout, authFetch } = useRuntimeAuth();
    const { moduloId } = useParams();

    const [catalogo, setCatalogo] = useState({});
    const [loading, setLoading] = useState(true);
    const [msg, setMsg] = useState("");

    useEffect(() => {
        let mounted = true;
        async function carregarCatalogo() {
            try {
                const res = await authFetch("/api/painel/admin/catalogo-acoes");
                if (!res.ok) return;
                const data = await res.json();
                if (mounted) setCatalogo(data.catalogo || {});
            } catch {
                // fallback silencioso
            } finally {
                if (mounted) setLoading(false);
            }
        }
        carregarCatalogo();
        return () => {
            mounted = false;
        };
    }, [authFetch]);

    const moduleData = useMemo(() => {
        const fallback = FALLBACK_MODULES[moduloId] || FALLBACK_MODULES.usuarios;
        const actions = catalogo[moduloId] || [];
        return { ...fallback, actions };
    }, [moduloId, catalogo]);

    function handleLogout() {
        logout();
        navigate("/login");
    }

    async function executarAcao(acao) {
        setMsg("");
        const exemplo = JSON.stringify(acao.exemplo_payload || {}, null, 2);
        const raw = window.prompt(
            `Payload JSON para: ${acao.titulo}\nCodigo: ${acao.codigo}\nSP: ${acao.sp}\nObrigatorios: ${(acao.params_obrigatorios || []).join(", ") || "nenhum"}`,
            exemplo
        );
        if (raw === null) return;

        let payload = {};
        try {
            payload = raw.trim() ? JSON.parse(raw) : {};
        } catch {
            setMsg("Payload JSON invalido.");
            return;
        }

        try {
            const res = await authFetch("/api/painel/admin/executar-acao", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ codigo: acao.codigo, payload })
            });
            const data = await res.json().catch(() => ({}));
            if (!res.ok || data.sucesso === false) {
                setMsg(data.mensagem || data.erro || "Falha ao executar a acao.");
                return;
            }
            setMsg(`OK: ${acao.titulo} (${acao.sp})`);
        } catch {
            setMsg("Erro de conexao ao executar a acao.");
        }
    }

    return (
        <div className="module-page">
            <header className="module-topbar">
                <div className="module-topbar-title">
                    <h1>Sistema De atendimento Alpha Hospitalar unidade Guido Guida Poa Sao Paulo</h1>
                    <p>{moduleData.title}</p>
                </div>
                <div className="module-topbar-actions">
                    <button type="button" onClick={() => navigate("/admin")}>Menu Principal</button>
                    <button type="button" className="danger" onClick={handleLogout}>Sair</button>
                </div>
            </header>

            <main className="module-content">
                <aside className="module-sidebar">
                    <h3>Acoes do Modulo</h3>
                    <div className="module-menu-list">
                        {moduleData.actions.length === 0 && (
                            <button type="button" className="module-menu-item" disabled>
                                Sem acoes mapeadas
                            </button>
                        )}
                        {moduleData.actions.map((item) => (
                            <button key={item.codigo} type="button" className="module-menu-item">
                                {item.titulo}
                            </button>
                        ))}
                    </div>
                </aside>

                <section className="module-workspace">
                    <div className="module-panel">
                        <h2>{moduleData.title}</h2>
                        <p>{moduleData.subtitle}</p>
                        {loading && <p>Carregando catalogo de acoes...</p>}
                        {msg && <div className="module-msg">{msg}</div>}
                        <div className="module-grid">
                            {moduleData.actions.map((item) => (
                                <div className="module-card" key={item.codigo}>
                                    <strong>{item.titulo}</strong>
                                    <span>Codigo: {item.codigo}</span>
                                    <span>SP: {item.sp}</span>
                                    <span>Obrigatorios: {(item.params_obrigatorios || []).join(", ") || "nenhum"}</span>
                                    <span>Status SP: {item.sp_disponivel ? "Disponivel" : "Nao encontrada"}</span>
                                    <button
                                        type="button"
                                        className="module-action-btn"
                                        onClick={() => executarAcao(item)}
                                    >
                                        Executar Acao
                                    </button>
                                </div>
                            ))}
                        </div>
                    </div>
                </section>
            </main>
        </div>
    );
}
