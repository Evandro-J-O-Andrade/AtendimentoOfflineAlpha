import React from "react";
import { useAuth } from "../../../contexts/AuthContext";

export default function Painel() {
  const { usuario, runtime, contexto, permissoes, logout, hasPerfil } = useAuth();

  return (
    <div style={{ padding: 20 }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 20 }}>
        <h1>Bem-vindo, {usuario?.login}</h1>
        <button 
          onClick={logout}
          style={{ padding: "10px 20px", background: "#dc2626", color: "#fff", border: "none", borderRadius: 4, cursor: "pointer" }}
        >
          Sair
        </button>
      </div>

      {hasPerfil('ADMIN') && (
        <div style={{ background: "#dbeafe", padding: 15, borderRadius: 8, marginBottom: 20 }}>
          <strong>👑 Modo Admin Ativo</strong>
        </div>
      )}

      <h2>📍 Contexto Atual</h2>
      <pre style={{ background: "#f5f5f5", padding: 15, borderRadius: 8, overflow: "auto" }}>
        {JSON.stringify(contexto, null, 2)}
      </pre>

      <h2>🚀 Runtime Parrudo (Perfis, Contextos, Filas)</h2>
      <pre style={{ background: "#f5f5f5", padding: 15, borderRadius: 8, overflow: "auto" }}>
        {JSON.stringify(runtime, null, 2)}
      </pre>

      <h2>🔐 Permissões</h2>
      <pre style={{ background: "#f5f5f5", padding: 15, borderRadius: 8, overflow: "auto" }}>
        {JSON.stringify(permissoes, null, 2)}
      </pre>

      <h2>📋 Dados do Usuário</h2>
      <pre style={{ background: "#f5f5f5", padding: 15, borderRadius: 8, overflow: "auto" }}>
        {JSON.stringify(usuario, null, 2)}
      </pre>
    </div>
  );
}
