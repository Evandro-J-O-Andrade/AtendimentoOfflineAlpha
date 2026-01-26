import React, { useEffect, useState } from "react";
import api from "@/services/api";
import "./SelectLocalModal.css";

export default function SelectLocalModal({ open, onClose, onSelect, usuario, perfil }) {
  const [locais, setLocais] = useState([]);
  const [loading, setLoading] = useState(false);
  const [selected, setSelected] = useState("");

  useEffect(() => {
    if (!open) return;

    setLoading(true);

    api
      .get("/local_atendimento_listar.php")
      .then((res) => {
        let data = Array.isArray(res.data) ? res.data : [];

        // filtra por perfil selecionado (não por perfis do usuario)
        if (perfil === "MEDICO") {
          data = data.filter((l) => l.tipo === "MEDICO" && Number(l.ativo) === 1);
        } else if (perfil === "RECEPCAO") {
          data = data.filter((l) => l.tipo === "RECEPCAO" && Number(l.ativo) === 1);
        } else if (perfil === "ENFERMAGEM") {
          data = data.filter((l) => l.tipo === "ENFERMAGEM" && Number(l.ativo) === 1);
        }

        setLocais(data);
      })
      .catch((err) => {
        console.error("Erro ao carregar locais", err);
        setLocais([]);
      })
      .finally(() => setLoading(false));
  }, [open, usuario, perfil]);

  useEffect(() => {
    if (!open) setSelected("");
  }, [open]);

  if (!open) return null;

  return (
    <div className="select-local-modal-overlay">
      <div className="select-local-modal">
        <h3>Escolha seu local de atendimento</h3>

        <div className="usuario-info">
          <strong>Usuário:</strong> {usuario?.nome || usuario?.nome_completo || usuario?.login}
          <br />
          <strong>Perfil:</strong> {perfil || (usuario?.perfis || []).join(", ")}
        </div>

        {loading ? (
          <div>Carregando locais...</div>
        ) : (
          <select value={selected} onChange={(e) => setSelected(e.target.value)}>
            <option value="">-- selecione --</option>
            {locais.map((l) => (
              <option key={l.id_local_usuario || l.id_local || l.id} value={JSON.stringify(l)}>
                {l.nome} {l.sala ? `- Sala: ${l.sala}` : ""}
              </option>
            ))}
          </select>
        )}

        <div className="actions">
          <button onClick={() => selected && onSelect(JSON.parse(selected))} disabled={!selected}>
            Selecionar
          </button>
          <button onClick={onClose}>Fechar</button>
        </div>
      </div>
    </div>
  );
}
