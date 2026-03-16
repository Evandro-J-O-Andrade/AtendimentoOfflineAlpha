import { useEffect, useMemo, useState } from "react";
import { useParams, Navigate } from "react-router-dom";
import axios from "axios";
import { useApp } from "../context/AppContext";

export default function RuntimeActionRouter() {
  const { acao } = useParams();
  const { contexto, permissoes, isAuthenticated, getToken } = useApp();
  const [dados, setDados] = useState(null);
  const [erro, setErro] = useState(null);
  const [carregando, setCarregando] = useState(true);

  const temPermissao = useMemo(() => {
    if (!acao) return false;
    return (permissoes || []).some((p) => {
      const cod = String(p.codigo || "").toLowerCase();
      const af = String(p.acao_frontend || "").toLowerCase();
      const alvo = String(acao || "").toLowerCase();
      return cod === alvo || af === alvo;
    });
  }, [permissoes, acao]);

  useEffect(() => {
    const executar = async () => {
      if (!contexto || !acao) return;
      try {
        const token = getToken();
        const res = await axios.post(
          "/api/runtime/dispatch",
          { acao: acao.toUpperCase(), payload: {} },
          { headers: { Authorization: `Bearer ${token}` } }
        );
        setDados(res.data);
      } catch (err) {
        console.error(err);
        setErro(err.response?.data?.erro || err.message || "Erro ao executar ação");
      } finally {
        setCarregando(false);
      }
    };
    executar();
  }, [acao, contexto, getToken]);

  if (!isAuthenticated) return <Navigate to="/login" replace />;
  if (!contexto) return <Navigate to="/contexto" replace />;
  if (!temPermissao) return <div>Acesso negado para ação: {acao}</div>;
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
