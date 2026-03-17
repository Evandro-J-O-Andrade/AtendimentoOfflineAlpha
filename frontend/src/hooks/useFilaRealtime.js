import { useEffect, useState } from "react";
import api from "../api/api";

/**
 * Hook para fila em tempo real com cache offline
 * Atualiza a cada 5 segundos
 */
export const useFilaRealtime = (runtime) => {
  const [fila, setFila] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (!runtime || !runtime.contextos || runtime.contextos.length === 0) {
      setLoading(false);
      return;
    }

    const id_local_operacional = runtime.contextos[0]?.id_local_operacional;
    
    if (!id_local_operacional) {
      setLoading(false);
      return;
    }

    const fetchFila = async () => {
      try {
        const response = await api.get(
          `/fila/atual`,
          { params: { id_local_operacional } }
        );
        
        setFila(response.data);
        setError(null);
        
        // Salvar no cache offline
        localStorage.setItem("fila_cache", JSON.stringify(response.data));
      } catch (err) {
        console.warn("Erro ao buscar fila, usando cache offline:", err.message);
        setError(err.message);
        
        // Fallback offline
        const cache = localStorage.getItem("fila_cache");
        if (cache) {
          try {
            setFila(JSON.parse(cache));
          } catch (e) {
            console.error("Erro ao parsing cache:", e);
          }
        }
      } finally {
        setLoading(false);
      }
    };

    // Buscar inicialmente
    fetchFila();

    // Atualizar a cada 5 segundos
    const interval = setInterval(fetchFila, 5000);

    return () => clearInterval(interval);
  }, [runtime]);

  return { fila, loading, error };
};

export default useFilaRealtime;
