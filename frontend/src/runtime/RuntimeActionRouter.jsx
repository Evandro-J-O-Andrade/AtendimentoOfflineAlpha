import { useEffect, useState } from "react";
import { useParams, Navigate } from "react-router-dom";
import { useAuth } from "../apps/operacional/auth/AuthProvider";
import spApi from "../api/spApi";

export default function RuntimeActionRouter() {
  const { acao } = useParams();
  const { session } = useAuth();
  const [dados, setDados] = useState(null);
  const [erro, setErro] = useState(null);
  const [carregando, setCarregando] = useState(true);

  useEffect(() => {
    const executar = async () => {
      if (!session?.id_sessao || !acao) return;
      try {
        // Usar spApi.callRoute para executar a ação
        const res = await spApi.callRoute({
          metodo: 'POST',
          rota: acao,
          id_sessao: session.id_sessao,
          payload: {}
        });
        setDados(res);
      } catch (err) {
        console.error(err);
        setErro(err?.message || "Erro ao executar ação");
      } finally {
        setCarregando(false);
      }
    };
    executar();
  }, [acao, session?.id_sessao]);

  if (!session?.id_sessao) return <Navigate to="/login" replace />;
  if (!session?.contexto_definido) return <Navigate to="/contexto" replace />;
  if (carregando) return <div>Carregando...</div>;
  if (erro) return <div>Erro: {erro}</div>;

  return (
    <div style={{ padding: 24, fontFamily: "Inter, sans-serif" }}>
      <h2>Ação: {acao}</h2>
      <pre style={{ background: "#0f172a", color: "#e2e8f0", padding: 12, borderRadius: 8 }}>
        {JSON.stringify(dados, null, 2)}
      </pre>
    </div>
  );
}
