import { useEffect, useState } from "react";
import { consultarFilaEspera } from "../api/spApi";

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

    const id_sessao_usuario = runtime.contextos[0]?.id_sessao_usuario || runtime.id_sessao_usuario;

    if (!id_sessao_usuario) {
      setLoading(false);
      return;
    }

    const fetchFila = async () => {
      try {
        const response = await consultarFilaEspera(id_sessao_usuario);

        setFila(response?.resultado || response?.data || []);
        setError(null);
        
        // Salvar no cache offline
        localStorage.setItem("fila_cache", JSON.stringify(response?.resultado || response?.data || []));
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
