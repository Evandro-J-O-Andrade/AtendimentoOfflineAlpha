import React from "react";

export default function CoordenadorGlobal() {
  return (
    <div style={{ padding: "20px" }}>
      <h1>Coordenador Global</h1>
      <p>Conectado à SP master - Coordenador Global</p>
      <div style={{ marginTop: "20px", padding: "10px", backgroundColor: "#f5f5f5", borderRadius: "5px" }}>
        <p><strong>SP:</strong> sp_coordenador_global</p>
        <p><strong>Rota:</strong> /api/master</p>
        <p><strong>Método:</strong> GET/POST</p>
      </div>
    </div>
  );
}
