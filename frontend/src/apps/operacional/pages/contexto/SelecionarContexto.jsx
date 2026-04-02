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
  const [salas, setSalas] = useState([]);

  const [idUnidade, setIdUnidade] = useState("");
  const [idPerfil, setIdPerfil] = useState("");
  const [idSala, setIdSala] = useState("");

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

        const listaSalas = data.salas || [];
        if (!listaSalas.some((s) => s.id_sala === 0)) {
          listaSalas.unshift({ id_sala: 0, nome: "NÃO DEFINIDA" });
        }
        setSalas(listaSalas);

        // defaults
        if (data.unidades?.length) setIdUnidade(String(data.unidades[0].id_unidade));
        if (data.perfis?.length) setIdPerfil(String(data.perfis[0].id_perfil));
        if (listaSalas.length) setIdSala(String(listaSalas[0].id_sala));
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
        id_local: null,
        id_sala: idSala === "0" ? null : parseInt(idSala, 10),
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
        <img src="/assets/img/sistemaalpha.png" alt="Sistema Alpha" onError={(e)=>e.target.style.display='none'} />
      </div>

      <div className="contexto-box">
        <header className="contexto-header">
          <h1>Bem-vindo à Unidade Guido Guida</h1>
          <p>Escolha onde vai atuar: selecione Unidade, Especialidade e Sala.</p>
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
            Especialidade
            <select value={idPerfil} onChange={(e) => setIdPerfil(e.target.value)} required>
              {perfis.map((p) => (
                <option key={p.id_perfil} value={p.id_perfil}>{p.nome}</option>
              ))}
            </select>
          </label>

          <label>
            Sala
            <select value={idSala} onChange={(e) => setIdSala(e.target.value)} required>
              {salas.map((s) => (
                <option key={s.id_sala} value={s.id_sala}>{s.nome}</option>
              ))}
            </select>
          </label>

          <button type="submit" className="contexto-submit">Confirmar</button>
        </form>
      </div>
    </div>
  );
}
