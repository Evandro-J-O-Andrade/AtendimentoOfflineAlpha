import React from "react";

export default function FluxoEstoque() {
  return (
    <div style={{ padding: "20px" }}>
      <h1>Fluxo Estoque</h1>
      <p>Conectado à SP master - Fluxo Estoque</p>
      <div style={{ marginTop: "20px", padding: "10px", backgroundColor: "#f5f5f5", borderRadius: "5px" }}>
        <p><strong>SP:</strong> sp_fluxo_estoque</p>
        <p><strong>Rota:</strong> /api/master</p>
        <p><strong>Método:</strong> GET/POST</p>
      </div>
    </div>
  );
}
