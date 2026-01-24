import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";
import { useContextoAtendimento } from "@/context/ContextoAtendimento";
import api from "@/services/api";
import "./SelecionarContexto.css";


export default function SelecionarContexto() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const { contexto, definirContexto } = useContextoAtendimento();

  const [perfilAtivo, setPerfilAtivo] = useState("");
  const [localId, setLocalId] = useState("");
  const [especialidade, setEspecialidade] = useState("");
  const [locais, setLocais] = useState([]);
  const [erroLocais, setErroLocais] = useState("");

  // Se já existe contexto definido, redireciona (ex: refresh)
  useEffect(() => {
    if (contexto?.rotaInicial) navigate(contexto.rotaInicial, { replace: true });
  }, [contexto, navigate]);

  // Carrega locais do banco
  useEffect(() => {
    let mounted = true;
    (async () => {
      try {
        setErroLocais("");
        const res = await api.get("/local_atendimento_listar.php");
        if (!mounted) return;
        setLocais(Array.isArray(res.data) ? res.data : []);
      } catch (e) {
        if (!mounted) return;
        setErroLocais("Não foi possível carregar os locais do banco.");
        setLocais([]);
      }
    })();
    return () => {
      mounted = false;
    };
  }, []);

  if (!user) return null;

  function iniciar() {
    if (!perfilAtivo || !localId) return;

    const userId = user.id_usuario ?? user.id ?? null;
    const userNome = user.nome ?? user.login ?? "Usuário";

    const localObj = locais.find((l) => String(l.id_local) === String(localId)) || null;
    const rotaInicial = rotaPorPerfil(perfilAtivo);

    definirContexto({
      usuarioId: userId,
      nomeUsuario: userNome,
      perfil: perfilAtivo,
      especialidade: especialidade || null,
      local: localObj,
      iniciadoEm: new Date().toISOString(),
      rotaInicial,
    });

    navigate(rotaInicial);
  }

  function rotaPorPerfil(perfil) {
    const p = String(perfil || "").toUpperCase();
    if (p === "RECEPCAO" || p === "ADM_RECEPCAO") return "/recepcao";
    if (p.includes("MEDICO")) return "/medico/fila";
    if (p === "TRIAGEM") return "/triagem";
    if (p === "ENFERMAGEM" || p === "TECNICO_ENFERMAGEM") return "/enfermagem";
    return "/";
  }

  return (
    <div className="contexto-container">
      {/* TOPO */}
      <header className="contexto-header">
        <img src="/brasao.png" alt="Hospital" />
      </header>

      {/* CARD */}
      <div className="contexto-card">
        <h2>Selecionar Contexto de Atendimento</h2>

        <div className="usuario-box">
          <strong>{user.nome ?? user.login}</strong>
          <span>{user.login}</span>
        </div>

        {/* PERFIL */}
        <label>Função</label>
        <select
          value={perfilAtivo}
          onChange={e => setPerfilAtivo(e.target.value)}
        >
          <option value="">Selecione</option>
          {user.perfis?.map((p) => (
            <option key={p} value={p}>
              {p}
            </option>
          ))}
        </select>

        {/* ESPECIALIDADE (somente médico) */}
        {String(perfilAtivo || "").toUpperCase().includes("MEDICO") && (
          <>
            <label>Especialidade</label>
            <select
              value={especialidade}
              onChange={e => setEspecialidade(e.target.value)}
            >
              <option value="">Selecione</option>
              <option value="CLINICO">Clínico Geral</option>
              <option value="PEDIATRIA">Pediatria</option>
              <option value="ORTOPEDIA">Ortopedia</option>
            </select>
          </>
        )}

        {/* LOCAL */}
        <label>Local de Atuação</label>
        <select
          value={localId}
          onChange={(e) => setLocalId(e.target.value)}
        >
          <option value="">Selecione</option>
          {locais
            .filter((l) => Number(l.ativo ?? 1) === 1)
            .map((l) => (
              <option key={l.id_local} value={l.id_local}>
                {l.nome} {l.tipo ? `(${l.tipo})` : ""}
              </option>
            ))}
        </select>

        {erroLocais && <p className="error">{erroLocais}</p>}

        <button
          className="btn-iniciar"
          disabled={!perfilAtivo || !localId}
          onClick={iniciar}
        >
          Iniciar Atendimento
        </button>
      </div>

      {/* FOOTER */}
      <footer className="contexto-footer">
        © 2025 • Sistema Hospitalar •{" "}
        <a
          href="https://newwavesistemasdigital.netlify.app"
          target="_blank"
          rel="noreferrer"
        >
          New Wave Sistemas Digital
        </a>
      </footer>
    </div>
  );
}
