import { useEffect, useState } from "react";
import api from "../api/api";

export default function Sidebar() {
  const [fila, setFila] = useState([]);

  useEffect(() => {
    api.get("/atendimento.php")
      .then(res => setFila(res.data));
  }, []);

  return (
    <aside>
      <h3>Fila</h3>
      {fila.map(p => (
        <div key={p.id_atendimento}>
          {p.nome_completo} ({p.status_atendimento})
        </div>
      ))}
    </aside>
  );
}
