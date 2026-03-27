import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../../auth/AuthProvider";
import "./SelecionarContexto.css";

export default function SelecionarContexto() {
  const navigate = useNavigate();
  const { getContexto, setContexto } = useAuth();

  const [loading, setLoading] = useState(true);
  const [erro, setErro] = useState("");

  const [unidades, setUnidades] = useState([]);
  const [perfis, setPerfis] = useState([]);
  const [locais, setLocais] = useState([]);

  const [idUnidade, setIdUnidade] = useState("");
  const [idPerfil, setIdPerfil] = useState("");
  const [idLocal, setIdLocal] = useState("");

  useEffect(() => {
    async function loadDados() {
      setLoading(true);
      setErro("");
      try {
        const data = await getContexto();
        if (!data) {
          setErro("Nenhum contexto retornado pelo sistema.");
          return;
        }

        setUnidades(data.unidades || []);
        setPerfis(data.perfis || []);

        const listaLocais = data.locais || [];
        if (!listaLocais.some((l) => l.id_local === 0)) {
          listaLocais.unshift({ id_local: 0, nome: "NÃO DEFINIDO" });
        }
        setLocais(listaLocais);

        // seleciona defaults se houver
        if (data.unidades?.length) setIdUnidade(String(data.unidades[0].id_unidade));
        if (data.perfis?.length) setIdPerfil(String(data.perfis[0].id_perfil));
        if (listaLocais.length) setIdLocal(String(listaLocais[0].id_local));
      } catch (err) {
        console.error(err);
        setErro("Falha ao carregar dados do contexto.");
      } finally {
        setLoading(false);
      }
    }
    loadDados();
  }, [getContexto]);

  async function confirmarContexto(e) {
    e.preventDefault();
    if (!idUnidade || !idPerfil) {
      setErro("Unidade e Perfil são obrigatórios.");
      return;
    }

    try {
      const result = await setContexto({
        id_unidade: parseInt(idUnidade, 10),
        id_perfil: parseInt(idPerfil, 10),
        id_local: idLocal === "0" ? null : parseInt(idLocal, 10),
        id_sala: null, // não usado aqui
      });

      if (result?.sucesso) {
        navigate("/operacional");
      } else {
        setErro(result?.mensagem || "Erro ao validar contexto.");
      }
    } catch (err) {
      console.error(err);
      setErro(err.message || "Erro ao salvar contexto.");
    }
  }

  if (loading) return <div className="contexto-loading">Carregando...</div>;
  if (!unidades.length && !perfis.length) return <div className="contexto-error">Usuário sem permissões.</div>;

  return (
    <div className="contexto-wrapper">
      <div className="contexto-logos">
        <img src="/assets/img/prefeitura.png" alt="Prefeitura" onError={(e)=>e.target.style.display='none'} />
        <img src="/assets/img/sistema.png" alt="Sistema" onError={(e)=>e.target.style.display='none'} />
      </div>

      <div className="contexto-box">
        <header className="contexto-header">
          <h1>Selecionar Contexto</h1>
          <p>Escolha a Unidade, Guichê/Local e Perfil para continuar.</p>
        </header>

        {erro && <div className="contexto-error">{erro}</div>}

        <form className="contexto-form" onSubmit={confirmarContexto}>
          <label>
            Unidade
            <select value={idUnidade} onChange={(e) => setIdUnidade(e.target.value)} required>
              {unidades.map((u) => (
                <option key={u.id_unidade} value={u.id_unidade}>{u.nome}</option>
              ))}
            </select>
          </label>

          <label>
            Guichê / Local
            <select value={idLocal} onChange={(e) => setIdLocal(e.target.value)} required>
              {locais.map((l) => (
                <option key={l.id_local} value={l.id_local}>{l.nome}</option>
              ))}
            </select>
          </label>

          <label>
            Perfil
            <select value={idPerfil} onChange={(e) => setIdPerfil(e.target.value)} required>
              {perfis.map((p) => (
                <option key={p.id_perfil} value={p.id_perfil}>{p.nome}</option>
              ))}
            </select>
          </label>

          <button type="submit" className="contexto-submit">Confirmar</button>
        </form>
      </div>
    </div>
  );
}
