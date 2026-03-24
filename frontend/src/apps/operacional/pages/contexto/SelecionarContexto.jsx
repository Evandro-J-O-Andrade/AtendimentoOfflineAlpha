import { useEffect, useState, useMemo } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../../auth/AuthProvider";
import "./SelecionarContexto.css";

export default function SelecionarContexto() {
    const navigate = useNavigate();
    const { getContexto, setContexto } = useAuth();

    const [loading, setLoading] = useState(true);
    const [erro, setErro] = useState("");
    
    // Listas reais vindas do Dispatcher -> Orquestradora
    const [unidades, setUnidades] = useState([]);
    const [perfis, setPerfis] = useState([]);
    const [locais, setLocais] = useState([]);
    const [salas, setSalas] = useState([]);
    
    // Seleções do usuário - ESTADO INICIAL VAZIO (sem auto-seleção)
    const [idUnidade, setIdUnidade] = useState(null);
    const [idPerfil, setIdPerfil] = useState(null);
    const [idLocal, setIdLocal] = useState(null);
    const [idSala, setIdSala] = useState(null);

    // Passo atual do fluxo obrigatório
    const [passoAtual, setPassoAtual] = useState(1);

    useEffect(() => {
        async function loadDados() {
            setLoading(true);
            setErro("");
            try {
                // Fluxo Canônico: Node -> Dispatcher -> AUTH.CONTEXTO.GET
                const data = await getContexto();
                
                if (data) {
                    setUnidades(data.unidades || []);
                    setPerfis(data.perfis || []);
                    
                    // Adiciona "NÃO DEFINIDA" como opção default para locais
                    const listaLocais = data.locais || [];
                    const possuiNaoDefinida = listaLocais.some(l => l.id_local === 0 || l.id_local === null);
                    
                    if (!possuiNaoDefinida) {
                        listaLocais.unshift({ id_local: 0, nome: "NÃO DEFINIDA" });
                    }
                    setLocais(listaLocais);
                    
                    // Adiciona opção NÃO DEFINIDA para salas
                    const listaSalas = data.salas || [];
                    
                    // Normaliza o id_sala - o backend usa -1 para NÃO DEFINIDA
                    listaSalas.forEach(sala => {
                        if (sala.id_sala === -1) {
                            sala.id_sala = 0;
                        }
                    });
                    
                    // Verifica se já existe NÃO DEFINIDA (id_sala = 0)
                    const salaPossuiNaoDefinida = listaSalas.some(s => s.id_sala === 0);
                    
                    if (!salaPossuiNaoDefinida) {
                        listaSalas.unshift({ 
                            id_sala: 0, 
                            nome: "NÃO DEFINIDA", 
                            tipo_nome: null,
                            tipo_codigo: null
                        });
                    }
                    
                    setSalas(listaSalas);
                } else {
                    setErro("Nenhum contexto retornado pelo dispatcher.");
                }
            } catch (err) {
                console.error("Erro carregar contextos via dispatcher:", err);
                setErro("Falha ao carregar contextos operacionais.");
            } finally {
                setLoading(false);
            }
        }
        loadDados();
    }, [getContexto]);

    // Agrupa salas por tipo_nome usando useMemo para performance
    const salasAgrupadas = useMemo(() => {
        const grupos = {};
        
        salas.forEach(sala => {
            const tipo = sala.tipo_nome || "SEM TIPO";
            if (!grupos[tipo]) {
                grupos[tipo] = [];
            }
            grupos[tipo].push(sala);
        });
        
        return grupos;
    }, [salas]);

    // Função para verificar se pode avançar para o próximo passo
    const podeAvancar = () => {
        switch (passoAtual) {
            case 1: return !!idUnidade;
            case 2: return !!idPerfil;
            case 3: return !!idLocal;
            case 4: return true; // Sala é opcional
            default: return false;
        }
    };

    // Função para avançar no fluxo obrigatório
    const avancarPasso = () => {
        if (podeAvancar()) {
            setPassoAtual(passoAtual + 1);
        }
    };

    // Função para voltar no fluxo
    const voltarPasso = () => {
        if (passoAtual > 1) {
            setPassoAtual(passoAtual - 1);
        }
    };

    async function confirmarContexto() {
        if (!idUnidade || !idPerfil) {
            setErro("Unidade e Perfil são obrigatórios.");
            return;
        }
        
        try {
            // Fluxo Canônico: Node -> Dispatcher -> AUTH.CONTEXTO.SET
            const result = await setContexto({
                id_unidade: parseInt(idUnidade),
                id_perfil: parseInt(idPerfil),
                id_local: idLocal === 0 || idLocal === null ? null : parseInt(idLocal),
                id_sala: idSala === 0 || idSala === null ? null : parseInt(idSala)
            });
            
            if (result && result.sucesso) {
                // Redireciona para o operacional com contexto ATIVO
                navigate("/operacional");
            } else {
                setErro(result?.mensagem || "Erro ao validar contexto no dispatcher.");
            }
        } catch (err) {
            console.error("Erro ao definir contexto via dispatcher:", err);
            setErro(err.message || "Erro de comunicação com o dispatcher.");
        }
    }

    // Renderiza os cards de seleção baseados no passo atual
    const renderizarCards = () => {
        switch (passoAtual) {
            case 1:
                return (
                    <div className="cards-grid">
                        {unidades.map((u) => (
                            <div 
                                key={u.id_unidade} 
                                className={`card-item ${idUnidade === u.id_unidade ? 'selected' : ''}`}
                                onClick={() => setIdUnidade(u.id_unidade)}
                            >
                                <div className="card-icon">🏥</div>
                                <div className="card-title">{u.nome}</div>
                            </div>
                        ))}
                    </div>
                );
            
            case 2:
                return (
                    <div className="cards-grid">
                        {perfis.map((p) => (
                            <div 
                                key={p.id_perfil} 
                                className={`card-item ${idPerfil === p.id_perfil ? 'selected' : ''}`}
                                onClick={() => setIdPerfil(p.id_perfil)}
                            >
                                <div className="card-icon">👤</div>
                                <div className="card-title">{p.nome}</div>
                            </div>
                        ))}
                    </div>
                );
            
            case 3:
                return (
                    <div className="cards-grid">
                        {locais.map((l) => (
                            <div 
                                key={l.id_local || 0} 
                                className={`card-item ${idLocal === l.id_local ? 'selected' : ''}`}
                                onClick={() => setIdLocal(l.id_local)}
                            >
                                <div className="card-icon">📍</div>
                                <div className="card-title">{l.nome}</div>
                            </div>
                        ))}
                    </div>
                );
            
            case 4:
                // Renderiza salas agrupadas por tipo
                return (
                    <div className="salas-container">
                        {Object.entries(salasAgrupadas).map(([tipo, salasDoTipo]) => (
                            <div key={tipo} className="sala-tipo-group">
                                <h3 className="sala-tipo-title">{tipo}</h3>
                                <div className="cards-grid">
                                    {salasDoTipo.map((s) => (
                                        <div 
                                            key={s.id_sala} 
                                            className={`card-item ${idSala === s.id_sala ? 'selected' : ''}`}
                                            onClick={() => setIdSala(s.id_sala)}
                                        >
                                            <div className="card-icon">🚪</div>
                                            <div className="card-title">{s.nome}</div>
                                            {s.id_sala !== 0 && s.tipo_codigo && (
                                                <div className="card-subtitle">Código: {s.tipo_codigo}</div>
                                            )}
                                        </div>
                                    ))}
                                </div>
                            </div>
                        ))}
                    </div>
                );
            
            default:
                return null;
        }
    };

    // Define o título do passo atual
    const getTituloPasso = () => {
        switch (passoAtual) {
            case 1: return "Selecione a Unidade";
            case 2: return "Selecione o Perfil";
            case 3: return "Selecione o Local/Setor";
            case 4: return "Selecione a Sala";
            default: return "";
        }
    };

    // Define o ícone do passo atual
    const getIconePasso = () => {
        switch (passoAtual) {
            case 1: return "🏥";
            case 2: return "👤";
            case 3: return "📍";
            case 4: return "🚪";
            default: return "➡️";
        }
    };

    if (loading) return <div className="contexto-loading">Acessando Dispatcher...</div>;

    if (!unidades.length && !perfis.length) {
        return (
            <div className="contexto-container">
                <div className="contexto-card">
                    <div className="contexto-error">Usuário sem permissões mapeadas no banco.</div>
                </div>
            </div>
        );
    }

    return (
        <div className="contexto-container">
            <div className="contexto-card">
                <div className="contexto-header">
                    <h1>Iniciar Atendimento</h1>
                    <p className="contexto-subtitle">Configurar Ambiente de Trabalho</p>
                </div>

                {/* Indicador de progresso */}
                <div className="progress-bar">
                    <div className={`progress-step ${passoAtual >= 1 ? 'active' : ''}`}>1</div>
                    <div className="progress-line"></div>
                    <div className={`progress-step ${passoAtual >= 2 ? 'active' : ''}`}>2</div>
                    <div className="progress-line"></div>
                    <div className={`progress-step ${passoAtual >= 3 ? 'active' : ''}`}>3</div>
                    <div className="progress-line"></div>
                    <div className={`progress-step ${passoAtual >= 4 ? 'active' : ''}`}>4</div>
                </div>

                {erro && <div className="contexto-error">{erro}</div>}

                <div className="contexto-form">
                    {/* Título do passo atual */}
                    <div className="passo-header">
                        <span className="passo-icone">{getIconePasso()}</span>
                        <h2 className="passo-title">{getTituloPasso()}</h2>
                    </div>

                    {/* Cards de seleção */}
                    {renderizarCards()}

                    {/* Botões de navegação */}
                    <div className="botoes-navegacao">
                        {passoAtual > 1 && (
                            <button 
                                className="btn-voltar" 
                                onClick={voltarPasso}
                            >
                                ← Voltar
                            </button>
                        )}
                        
                        {passoAtual < 4 ? (
                            <button 
                                className="btn-avancar" 
                                onClick={avancarPasso}
                                disabled={!podeAvancar()}
                            >
                                Avançar →
                            </button>
                        ) : (
                            <button 
                                className="btn-confirmar" 
                                onClick={confirmarContexto}
                                disabled={!idUnidade || !idPerfil}
                            >
                                ✅ INICIAR ATENDIMENTO
                            </button>
                        )}
                    </div>

                    {/* Resumo das selections */}
                    {(idUnidade || idPerfil || idLocal || idSala) && (
                        <div className="resumo-selecao">
                            <div className="resumo-titulo">Resumo da Configuração:</div>
                            {idUnidade && <span className="resumo-item">🏥 {unidades.find(u => u.id_unidade === idUnidade)?.nome}</span>}
                            {idPerfil && <span className="resumo-item">👤 {perfis.find(p => p.id_perfil === idPerfil)?.nome}</span>}
                            {idLocal !== null && <span className="resumo-item">📍 {locais.find(l => l.id_local === idLocal)?.nome || "NÃO DEFINIDA"}</span>}
                            {idSala !== null && <span className="resumo-item">🚪 {salas.find(s => s.id_sala === idSala)?.nome || "NÃO DEFINIDA"}</span>}
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}
