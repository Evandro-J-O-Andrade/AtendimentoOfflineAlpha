import { useEffect, useState } from "react";
import { useAuth } from "../../auth/AuthProvider";
import { useNavigate } from "react-router-dom";
import "./SelecionarContexto.css";

export default function SelecionarContexto() {
    const { session, getContexto, setContexto } = useAuth();
    const navigate = useNavigate();

    const [data, setData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [erro, setErro] = useState("");

    useEffect(() => {
        async function load() {
            try {
                const res = await getContexto();
                setData(res);
            } catch (err) {
                setErro(err.message);
            } finally {
                setLoading(false);
            }
        }
        load();
    }, [getContexto]);

    async function selecionar(id_unidade, id_local, id_perfil) {
        try {
            await setContexto({
                id_unidade,
                id_local,
                id_perfil
            });
            navigate("/dashboard");
        } catch (err) {
            setErro(err.message);
        }
    }

    if (loading) return <div className="contexto-loading">Carregando...</div>;

    return (
        <div className="contexto-container">
            <div className="contexto-card">
                <h1>Selecionar Contexto</h1>
                
                {erro && <div className="contexto-error">{erro}</div>}

                {data?.unidades?.map((u) => (
                    <button
                        key={u.id_unidade}
                        onClick={() => selecionar(u.id_unidade, 0, data.perfis?.[0]?.id_perfil)}
                        className="btn-confirmar"
                    >
                        {u.nome}
                    </button>
                ))}

                {!data?.unidades?.length && (
                    <p>Nenhuma unidade disponível</p>
                )}
            </div>
        </div>
    );
}
