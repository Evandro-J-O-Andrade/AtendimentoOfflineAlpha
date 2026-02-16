import React, { useState } from "react";
import api from "@/services/api";

export default function TotemHome() {
  const [mensagem, setMensagem] = useState("");
  const [erro, setErro] = useState("");

  const emitirSenha = async () => {
    setMensagem("");
    setErro("");
    try {
      const res = await api.post("/senha/senha_gerar.php", { origem: "TOTEM" });
      const { numero, letra } = res.data || {};
      if (!numero) throw new Error("Falha ao emitir senha");
      setMensagem(`Senha emitida: ${letra ?? ""}${numero}`);
    } catch (e) {
      setErro(e.response?.data?.erro || e.message || "Erro ao emitir senha");
    }
  };

  return (
    <div style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 16, padding: 24 }}>
      <h2>Totem de Senhas</h2>
      {mensagem && <div style={{ color: "green" }}>{mensagem}</div>}
      {erro && <div style={{ color: "red" }}>{erro}</div>}
      <button onClick={emitirSenha} style={{ fontSize: 24, padding: "16px 24px" }}>
        Emitir Senha
      </button>
    </div>
  );
}