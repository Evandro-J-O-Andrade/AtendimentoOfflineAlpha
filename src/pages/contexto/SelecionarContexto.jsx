import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";
import { useContextoAtendimento } from "@/context/ContextoAtendimento";


export default function SelecionarContexto() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const { contexto, definirContexto } = useContextoAtendimento();

  const [perfilAtivo, setPerfilAtivo] = useState("");
  const [local, setLocal] = useState("");
  const [especialidade, setEspecialidade] = useState("");

  // 🔒 Se já existe contexto definido, redireciona
  useEffect(() => {
    if (contexto?.rotaInicial) {
      navigate(contexto.rotaInicial);
    }
  }, [contexto, navigate]);

  if (!user) return null;

  function iniciar() {
    if (!perfilAtivo || !local) return;

    definirContexto({
      usuarioId: user.id,
      nomeUsuario: user.nome,
      perfil: perfilAtivo,
      especialidade: especialidade || null,
      local,
      iniciadoEm: new Date().toISOString(),
      rotaInicial: rotaPorPerfil(perfilAtivo)
    });

    // ❌ NÃO navega aqui
    // quem navega é o useEffect acima
  }

  function rotaPorPerfil(perfil) {
    switch (perfil) {
      case "RECEPCAO":
        return "/recepcao";

      case "MEDICO":
        return "/medico/fila";

      case "ENFERMAGEM":
      case "TECNICO_ENFERMAGEM":
        return "/enfermagem";

      case "TRIAGEM":
        return "/triagem";

      default:
        return "/";
    }
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
          <strong>{user.nome}</strong>
          <span>{user.email}</span>
        </div>

        {/* PERFIL */}
        <label>Função</label>
        <select
          value={perfilAtivo}
          onChange={e => setPerfilAtivo(e.target.value)}
        >
          <option value="">Selecione</option>
          {user.perfis?.map(p => (
            <option key={p} value={p}>{p}</option>
          ))}
        </select>

        {/* ESPECIALIDADE (somente médico) */}
        {perfilAtivo === "MEDICO" && (
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
          value={local}
          onChange={e => setLocal(e.target.value)}
        >
          <option value="">Selecione</option>
          <option value="SALA_01">Sala 01</option>
          <option value="SALA_02">Sala 02</option>
          <option value="TRIAGEM">Triagem</option>
          <option value="MEDICACAO">Medicação</option>
          <option value="OBSERVACAO">Observação</option>
          <option value="GUICHE_01">Guichê 01</option>
          <option value="GUICHE_02">Guichê 02</option>
        </select>

        <button
          className="btn-iniciar"
          disabled={!perfilAtivo || !local}
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
