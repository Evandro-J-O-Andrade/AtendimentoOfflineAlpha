import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import loginService from "../../../../services/loginService";
import { useApp } from "../../../../context/AppContext";
import "./SelecionarContexto.css";

export default function SelecionarContexto() {
    const navigate = useNavigate();
    const { hydrateSession } = useApp();
    const [contextos, setContextos] = useState([]);
    const [loading, setLoading] = useState(true);
    const [selectedUnidade, setSelectedUnidade] = useState("");
    const [selectedEspecialidade, setSelectedEspecialidade] = useState("");
    const [selectedSala, setSelectedSala] = useState("");
    const [erro, setErro] = useState("");
    const [credenciaisPendentes, setCredenciaisPendentes] = useState(null);

    useEffect(() => {
        const pending = sessionStorage.getItem("pending_context");
        if (!pending) {
            setLoading(false);
            setErro("Nenhum contexto pendente encontrado. Faça login novamente.");
            return;
        }
        try {
            const data = JSON.parse(pending);
            setCredenciaisPendentes(data);
            setContextos(data.contextos || []);
        } catch {
            setErro("Não foi possível ler os contextos. Faça login novamente.");
        } finally {
            setLoading(false);
        }
    }, []);

    const contextosDaUnidade = contextos.filter(
        (ctx) => String(ctx.id_unidade) === String(selectedUnidade)
    );

    const especialidades = Array.from(
        new Map(
            contextosDaUnidade.map((ctx) => [
                String(ctx.id_perfil),
                { id_perfil: String(ctx.id_perfil), nome: ctx.perfil_nome || `Perfil ${ctx.id_perfil}` }
            ])
        ).values()
    );

    const salas = [
        { id_local_operacional: "", nome: "Selecione a sala" },
        ...Array.from(
            new Map(
                contextosDaUnidade
                    .filter((ctx) => String(ctx.id_perfil) === String(selectedEspecialidade))
                    .map((ctx) => [
                        String(ctx.id_local_operacional),
                        {
                            id_local_operacional: String(ctx.id_local_operacional),
                            nome: ctx.local_nome || `Local ${ctx.id_local_operacional}`
                        }
                    ])
            ).values()
        )
    ];

    useEffect(() => {
        if (contextos.length === 0) return;

        const unidades = Array.from(new Map(contextos.map((ctx) => [String(ctx.id_unidade), ctx])).values());
        if (unidades.length === 1) {
            setSelectedUnidade(String(unidades[0].id_unidade));
            return;
        }

        if (!selectedUnidade) {
            setSelectedUnidade("");
        }
    }, [contextos, selectedUnidade]);

    useEffect(() => {
        if (!selectedUnidade) return;
        if (especialidades.length === 0) {
            setSelectedEspecialidade("");
            return;
        }

        const exists = especialidades.some((esp) => esp.id_perfil === String(selectedEspecialidade));
        if (!exists && especialidades.length === 1) {
            setSelectedEspecialidade(especialidades[0].id_perfil);
            return;
        }

        if (!exists && especialidades.length > 1) {
            setSelectedEspecialidade("");
        }
    }, [selectedUnidade, selectedEspecialidade, especialidades]);

    useEffect(() => {
        if (!selectedEspecialidade) {
            setSelectedSala("");
            return;
        }
        if (salas.length === 0) return;

        const exists = salas.some((s) => s.id_local_operacional === String(selectedSala));

        if (!exists) {
            setSelectedSala("");
        }
    }, [selectedEspecialidade, selectedSala, salas]);

    function resolverContextoSelecionado() {
        return contextos.find(
            (ctx) =>
                String(ctx.id_unidade) === String(selectedUnidade) &&
                String(ctx.id_perfil) === String(selectedEspecialidade) &&
                String(ctx.id_local_operacional) === String(selectedSala)
        );
    }

    async function handleConfirmar() {
        setErro("");
        const selectedContext = resolverContextoSelecionado();
        if (!selectedContext) {
            setErro("Selecione unidade, especialidade e sala para continuar.");
            return;
        }

        try {
            const loginResult = await loginService.login({
                usuario: credenciaisPendentes?.usuario,
                senha: credenciaisPendentes?.senha,
                id_unidade: selectedContext.id_unidade,
                id_local_operacional: selectedContext.id_local_operacional,
                id_perfil: selectedContext.id_perfil,
                id_sistema: selectedContext.id_sistema
            });

            if (!loginResult?.sucesso) {
                setErro(loginResult?.erro || "Não foi possível ativar o contexto selecionado.");
                return;
            }

            hydrateSession(loginResult);
            sessionStorage.removeItem("pending_context");

            // Redireciona conforme permissões retornadas
            const perms = loginResult.permissoes || [];
            const hasAdmin =
                perms.some((p) =>
                    typeof p === "string"
                        ? p.toUpperCase() === "ADMIN" || p.toUpperCase().includes("PAINEL_ADMIN")
                        : String(p.acao_frontend || p.codigo || "").toLowerCase() === "painel_admin"
                );

            navigate(hasAdmin ? "/admin" : "/dashboard", { replace: true });
        } catch (err) {
            console.error("Erro ao selecionar contexto:", err);
            const detalhe = err.response?.data?.erro || err.response?.data?.error || err.message;
            setErro(`Erro ao selecionar contexto: ${detalhe}`);
        }
    }

    if (loading) {
        return <div className="contexto-loading">Carregando contextos...</div>;
    }

    const unidades = Array.from(
        new Map(
            contextos.map((ctx) => [
                String(ctx.id_unidade),
                { id_unidade: String(ctx.id_unidade), nome: ctx.unidade_nome || `Unidade ${ctx.id_unidade}` }
            ])
        ).values()
    );

    return (
        <div className="contexto-container">
            <div className="contexto-card">
                <h1>Sistema De atendimento Alpha Hospitalar</h1>
                <p className="contexto-subtitle">Selecione seu contexto operacional para entrar</p>

                <div className="contexto-form">
                    <label className="field">
                        <span>Unidade</span>
                        <select
                            value={selectedUnidade}
                            onChange={(e) => setSelectedUnidade(e.target.value)}
                            disabled={unidades.length <= 1}
                        >
                            {unidades.length > 1 && <option value="">Selecione uma unidade</option>}
                            {unidades.map((u) => (
                                <option key={u.id_unidade} value={u.id_unidade}>
                                    {u.nome}
                                </option>
                            ))}
                        </select>
                    </label>

                    <label className="field">
                        <span>Especialidade</span>
                        <select
                            value={selectedEspecialidade}
                            onChange={(e) => setSelectedEspecialidade(e.target.value)}
                            disabled={especialidades.length <= 1}
                        >
                            {especialidades.length > 1 && <option value="">Selecione uma especialidade</option>}
                            {especialidades.map((esp) => (
                                <option key={esp.id_perfil} value={esp.id_perfil}>
                                    {esp.nome}
                                </option>
                            ))}
                        </select>
                    </label>

                    <label className="field">
                        <span>Sala</span>
                        <select
                            value={selectedSala}
                            onChange={(e) => setSelectedSala(e.target.value)}
                            disabled={!selectedEspecialidade}
                        >
                            {salas.map((sala) => (
                                <option key={sala.id_local_operacional} value={sala.id_local_operacional}>
                                    {sala.nome}
                                </option>
                            ))}
                        </select>
                    </label>
                </div>

                {contextos.length === 0 && (
                    <div className="contexto-empty">
                        <p>Nenhum contexto operacional encontrado.</p>
                        <p>Entre em contato com o administrador.</p>
                    </div>
                )}

                {erro && <div className="contexto-error">{erro}</div>}

                <div className="contexto-actions">
                    <button 
                        className="btn-confirmar"
                        disabled={!selectedUnidade || !selectedEspecialidade || selectedSala === ""}
                        onClick={handleConfirmar}
                    >
                        Confirmar e Entrar
                    </button>
                </div>
            </div>
        </div>
    );
}
