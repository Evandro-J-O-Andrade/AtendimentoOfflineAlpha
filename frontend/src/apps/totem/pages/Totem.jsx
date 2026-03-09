import { useEffect, useMemo, useState } from "react";
import "./Totem.css";

function dataExtenso() {
    const now = new Date();
    return now.toLocaleDateString("pt-BR", {
        day: "2-digit",
        month: "long",
        year: "numeric",
        weekday: "long"
    });
}

function normalizarLabel(nome) {
    return String(nome || "")
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .toUpperCase();
}

export default function Totem() {
    const [opcoes, setOpcoes] = useState([]);
    const [plantao, setPlantao] = useState([]);
    const [loading, setLoading] = useState(false);
    const [mensagem, setMensagem] = useState("");
    const [erro, setErro] = useState("");

    useEffect(() => {
        async function carregarDados() {
            try {
                const [opcoesRes, plantaoRes] = await Promise.all([
                    fetch("/api/totem/opcoes"),
                    fetch("/api/totem/plantao-medico?id_unidade=1")
                ]);

                const opcoesData = await opcoesRes.json().catch(() => ({}));
                const plantaoData = await plantaoRes.json().catch(() => ({}));

                if (opcoesRes.ok) setOpcoes(opcoesData.opcoes || []);
                if (plantaoRes.ok) setPlantao(plantaoData.plantao || []);
            } catch (e) {
                console.error(e);
                setErro("Falha ao carregar dados do totem.");
            }
        }

        carregarDados();
    }, []);

    const grupos = useMemo(() => {
        const g = {
            prioritario: [],
            pediatria: [],
            normalAdulto: []
        };

        for (const opcao of opcoes) {
            const nome = normalizarLabel(opcao.nome);
            if (nome.includes("PEDI")) {
                g.pediatria.push(opcao);
            } else if (
                nome.includes("PRIOR") ||
                nome.includes("PREFER") ||
                nome.includes("EMERGEN") ||
                nome.includes("URG")
            ) {
                g.prioritario.push(opcao);
            } else {
                g.normalAdulto.push(opcao);
            }
        }
        return g;
    }, [opcoes]);

    async function gerarSenha(id_opcao) {
        setLoading(true);
        setErro("");
        setMensagem("");

        try {
            const res = await fetch("/api/totem/gerar-senha", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    id_opcao,
                    id_unidade: 1,
                    id_local_operacional: 1
                })
            });

            const data = await res.json().catch(() => ({}));
            if (!res.ok || !data?.senha) {
                setErro(data.error || "Nao foi possivel gerar a senha.");
                return;
            }

            setMensagem(`Senha gerada: ${data.senha.tipo}`);
        } catch {
            setErro("Erro de comunicacao com o servidor.");
        } finally {
            setLoading(false);
        }
    }

    function renderBotoes(lista, classe) {
        return lista.map((opcao) => (
            <button
                key={opcao.id_opcao}
                type="button"
                className={`totem-btn ${classe}`}
                onClick={() => gerarSenha(opcao.id_opcao)}
                disabled={loading}
            >
                {String(opcao.nome || "GERAR SENHA").toUpperCase()}
            </button>
        ));
    }

    return (
        <div className="totem-page">
            <section className="totem-head">
                <div className="totem-head-logos">
                    <img src="/assets/img/prefeitura.png" alt="Prefeitura" />
                    <img src="/assets/img/sistema.png" alt="Alpha" />
                </div>
                <div className="totem-head-title">
                    <h1>PREFEITURA DO MUNICIPIO DE POA - SP</h1>
                    <h2>PRONTO ATENDIMENTO DR GUIDO GUIDA</h2>
                    <p>{dataExtenso()}</p>
                </div>
            </section>

            <section className="totem-plantao">
                {plantao.length === 0 && <div className="totem-plantao-empty">Sem escala medica do dia.</div>}
                {plantao.map((item, idx) => (
                    <div key={`${item.medico_nome}-${idx}`} className="totem-plantao-row">
                        <div className="esp">{String(item.especialidade || "MEDICO CLINICO").toUpperCase()}</div>
                        <div className="medico">
                            {String(item.medico_nome || "MEDICO DE PLANTAO").toUpperCase()} - CRM: {item.crm || "N/A"}
                        </div>
                    </div>
                ))}
            </section>

            <section className="totem-main">
                <h3>SENHA ELETRONICA DE CHAMADA PARA ATENDIMENTO</h3>

                <div className="totem-boxes">
                    <div className="box-left">
                        <h4>ATENDIMENTO PRIORITARIO</h4>
                        <div className="btn-grid">
                            {renderBotoes(grupos.prioritario, "btn-prioritario")}
                            {renderBotoes(grupos.pediatria, "btn-pediatria")}
                        </div>
                    </div>

                    <div className="box-right">
                        <h4>ATENDIMENTO NORMAL - ADULTO</h4>
                        <div className="btn-grid">
                            {renderBotoes(grupos.normalAdulto, "btn-normal")}
                        </div>
                    </div>
                </div>
            </section>

            {mensagem && <div className="totem-msg ok">{mensagem}</div>}
            {erro && <div className="totem-msg err">{erro}</div>}
        </div>
    );
}
