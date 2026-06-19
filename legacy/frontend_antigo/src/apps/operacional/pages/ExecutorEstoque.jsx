import React from "react";

export default function ExecutorEstoque() {
  return (
    <div style={{ padding: "20px" }}>
      <h1>Executor Estoque</h1>
      <p>Conectado à SP master - Executor Estoque</p>
      <div style={{ marginTop: "20px", padding: "10px", backgroundColor: "#f5f5f5", borderRadius: "5px" }}>
        <p><strong>SP:</strong> sp_executor_estoque</p>
        <p><strong>Rota:</strong> /api/master</p>
        <p><strong>Método:</strong> POST</p>
      </div>
    </div>
  );
}
