import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/app/providers/AuthProvider";
import LoginForm from "./LoginForm";

export default function LoginPage() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (data: { usuario: string; senha: string }) => {
    setLoading(true);
    setError(null);

    try {
      const result = await login({ login: data.usuario, senha: data.senha });

      if (result?.sucesso) {
        navigate("/portal", { replace: true });
      } else {
        setError(result?.mensagem || "Erro ao fazer login");
      }
    } catch (err: any) {
      setError(err.response?.data?.mensagem || err.message || "Erro no servidor");
    } finally {
      setLoading(false);
    }
  };

  return (
    <LoginForm
      loading={loading}
      error={error}
      onSubmit={handleSubmit}
    />
  );
}