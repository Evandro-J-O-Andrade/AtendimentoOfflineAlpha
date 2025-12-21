import { useEffect, useState } from "react";
import api from "../api/api";

export default function Sidebar() {
  const [fila, setFila] = useState([]);
  const [loading, setLoading] = useState(true);   // estado de carregamento
  const [error, setError] = useState(null);       // estado de erro

  useEffect(() => {
    setLoading(true);  // inicia carregamento
    api.get("/atendimento.php")
      .then(res => {
        const data = Array.isArray(res.data) ? res.data : [];
        setFila(data);
        setError(null);  // limpa qualquer erro anterior
      })
      .catch(err => {
        console.error("Erro ao carregar a fila:", err);
        setFila([]);     // garante que fila seja um array
        setError("Não foi possível carregar a fila.");
      })
      .finally(() => {
        setLoading(false); // terminou carregamento
      });
  }, []);

}
