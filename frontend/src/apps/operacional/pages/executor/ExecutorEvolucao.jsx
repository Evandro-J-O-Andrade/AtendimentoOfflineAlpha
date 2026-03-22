import React from "react";

export default function ExecutorEvolucao() {
  return (
    <div style={{ padding: "20px" }}>
      <h1>Executor Evolução</h1>
      <p>Conectado à SP master - Executor Evolução</p>
      <div style={{ marginTop: "20px", padding: "10px", backgroundColor: "#f5f5f5", borderRadius: "5px" }}>
        <p><strong>SP:</strong> sp_executor_evolucao</p>
        <p><strong>Rota:</strong> /api/master</p>
        <p><strong>Método:</strong> POST</p>
      </div>
    </div>
  );
}
