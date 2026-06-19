import { useEffect, useMemo, useState } from "react";
import "./Totem.css";

interface SenhaData {
    tipo: string;
    label?: string;
}

interface Opcao {
    id_opcao: number;
    nome?: string;
}

interface PlantaoItem {
    medico_nome?: string;
    especialidade?: string;
    crm?: string;
}

function dataExtenso() {
    const now = new Date();
    return now.toLocaleDateString("pt-BR", {
        day: "2-digit",
        month: "long",
        year: "numeric",
        weekday: "long"
    });
}

function normalizarLabel(nome: string | undefined) {
    return String(nome || "")
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .toUpperCase();
}

function imprimirSenha(senhaData: SenhaData) {
    try {
        const conteudo = `
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Senha - ${senhaData.tipo}</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html, body {
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding-top: 10px;
        }
        body { font-family: Arial, sans-serif; }
        .comprovante {
            width: 280px;
            padding: 15px;
            text-align: center;
            border: 2px solid #000;
            margin: 0 auto;
        }
        .header {
            background: #000080;
            color: white;
            padding: 8px;
            margin: -15px -15px 15px -15px;
        }
        .header h1 { font-size: 12px; margin-bottom: 3px; }
        .header h2 { font-size: 10px; font-weight: normal; }
        .senha-numero {
            font-size: 42px;
            font-weight: bold;
            color: #000080;
            margin: 15px 0;
        }
        .senha-tipo {
            font-size: 16px;
            color: #333;
            margin-bottom: 15px;
        }
        .data-hora {
            font-size: 11px;
            color: #666;
            border-top: 1px dashed #ccc;
            padding-top: 12px;
            margin-top: 12px;
        }
        .aviso {
            font-size: 9px;
            color: #888;
            margin-top: 8px;
        }
        @page {
            margin: 0;
            size: auto;
        }
        @media print {
            html, body {
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }
            body {
                padding-top: 5mm;
            }
            .comprovante { border: none; }
        }
    </style>
</head>
<body>
    <div class="comprovante">
        <div class="header">
            <h1>PREFEITURA DE POÁ - SP</h1>
            <h2>PRONTO ATENDIMENTO DR GUIDO GUIDA</h2>
        </div>
        <div class="senha-numero">${senhaData.tipo}</div>
        <div class="senha-tipo">${senhaData.label || "Senha de Atendimento"}</div>
        <div class="data-hora">
            ${new Date().toLocaleDateString("pt-BR")} - ${new Date().toLocaleTimeString("pt-BR")}
        </div>
        <div class="aviso">
            Acompanhe o painel de chamada
        </div>
    </div>
    <script>
        window.onload = function() {
            window.print();
            setTimeout(function() {
                window.close();
            }, 1000);
        };
    </script>
</body>
</html>
        `;
        
        const janelaImpressao = window.open("", "_blank", "width=400,height=600");
        
        if (!janelaImpressao) {
            console.warn("Popup de impressão foi bloqueado pelo navegador");
            const printWindow = window.open('', '_blank');
            if (printWindow) {
                printWindow.document.write(conteudo);
                printWindow.document.close();
            }
            return;
        }
        
        janelaImpressao.document.write(conteudo);
        janelaImpressao.document.close();
    } catch (err) {
        console.error("Erro ao imprimir senha:", err);
    }
}

export default function Totem() {
    const [opcoes, setOpcoes] = useState<Opcao[]>([]);
    const [plantao, setPlantao] = useState<PlantaoItem[]>([]);
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
            prioritario: [] as Opcao[],
            pediatria: [] as Opcao[],
            normalAdulto: [] as Opcao[]
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

    async function gerarSenha(id_opcao: number, nomeOpcao: string | undefined) {
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

            data.senha.label = nomeOpcao || "Atendimento";
            
            setMensagem(`Senha gerada: ${data.senha.tipo}`);
            
            setTimeout(() => imprimirSenha(data.senha), 500);
        } catch {
            setErro("Erro de comunicacao com o servidor.");
        } finally {
            setLoading(false);
        }
    }

    function renderBotoes(lista: Opcao[], classe: string) {
        return lista.map((opcao) => (
            <button
                key={opcao.id_opcao}
                type="button"
                className={`totem-btn ${classe}`}
                onClick={() => gerarSenha(opcao.id_opcao, opcao.nome)}
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
                </div>
                <div className="totem-head-title">
                    <h1>PREFEITURA DO MUNICIPIO DE POA - SP</h1>
                    <h2>PRONTO ATENDIMENTO DR GUIDO GUIDA</h2>
                    <p>{dataExtenso()}</p>
                </div>
                <div className="totem-head-alpha">
                    <img src="/assets/img/sistema.png" alt="Alpha" />
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
                    <div className="box-prioritario">
                        <div className="box-img">
                            <img src="/assets/img/prioritario.jpg" alt="Prioritário" />
                        </div>
                        <h4>Prioritário para preferenciais</h4>
                        <div className="btn-grid">
                            {renderBotoes(grupos.prioritario, "btn-prioritario")}
                        </div>
                    </div>

                    <div className="box-pediatria">
                        <div className="box-img">
                            <img src="/assets/img/pediatrico.png" alt="Pediatria" />
                        </div>
                        <h4>Pediatria</h4>
                        <div className="btn-grid">
                            {renderBotoes(grupos.pediatria, "btn-pediatria")}
                        </div>
                    </div>

                    <div className="box-normal">
                        <div className="box-img">
                            <img src="/assets/img/normal.png" alt="Normal" />
                        </div>
                        <h4>Normal para clínico normal</h4>
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