import React, { useEffect, useState } from "react";
import { useAuth } from "./AuthProvider";

export const RuntimeAuthContexto = ({ children }) => {
  const { contextos, loading, erro, getContextos } = useAuth();
  const [contextoAtivo, setContextoAtivo] = useState(null);
  const [loadingSelecao, setLoadingSelecao] = useState(false);

  // Seleciona contexto padrão ou primeiro disponível
  useEffect(() => {
    if (!loading && contextos.length > 0 && !contextoAtivo) {
      setContextoAtivo(contextos[0]);
    }
  }, [loading, contextos, contextoAtivo]);

  const selecionarContexto = async (idContexto) => {
    setLoadingSelecao(true);
    try {
      const ctx = contextos.find((c) => c.id === idContexto);
      if (!ctx) throw new Error("Contexto inválido");
      setContextoAtivo(ctx);
      // opcional: persistir no backend / sessão
      await getContextos(); // refresca contextos se necessário
    } catch (err) {
      console.error("Erro ao selecionar contexto:", err);
    } finally {
      setLoadingSelecao(false);
    }
  };

  if (loading || loadingSelecao) return <div>Carregando...</div>;
  if (erro) return <div>Erro: {erro}</div>;

  return (
    <div>
      {/* Seleção de contexto */}
      {!contextoAtivo && contextos.length > 0 && (
        <div>
          <h3>Selecione seu contexto</h3>
          <ul>
            {contextos.map((c) => (
              <li key={c.id}>
                <button onClick={() => selecionarContexto(c.id)}>
                  {c.nome}
                </button>
              </li>
            ))}
          </ul>
        </div>
      )}

      {/* Contexto ativo */}
      {contextoAtivo && (
        <div>
          <p>Contexto ativo: {contextoAtivo.nome}</p>
          {children}
        </div>
      )}
    </div>
  );
};
