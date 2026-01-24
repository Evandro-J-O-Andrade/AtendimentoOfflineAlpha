import React from "react";
import { Navigate, useLocation } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";

function normalizePerfis(perfis) {
  if (!Array.isArray(perfis)) return [];
  return perfis
    .map((p) => String(p || "").trim().toUpperCase())
    .filter(Boolean);
}

function hasPerfil(perfis, required) {
  if (!required) return true;

  const req = String(required).trim().toUpperCase();
  const list = normalizePerfis(perfis);

  // Regras de compatibilidade
  if (req === "MEDICO") return list.some((p) => p.includes("MEDICO"));
  if (req === "ENFERMAGEM") {
    return (
      list.includes("ENFERMAGEM") ||
      list.includes("TECNICO_ENFERMAGEM") ||
      list.includes("TRIAGEM")
    );
  }
  if (req === "ADMIN_MASTER") return list.includes("ADMIN_MASTER") || list.includes("MASTER");

  return list.includes(req);
}

export default function PrivateRoute({ children, perfil }) {
  const { user, token, loading } = useAuth();
  const location = useLocation();

  if (loading) {
    return (
      <div
        style={{
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          height: "100vh",
        }}
      >
        <span>Carregando...</span>
      </div>
    );
  }

  if (!token || !user) {
    return <Navigate to="/login" replace state={{ from: location }} />;
  }

  if (!hasPerfil(user.perfis, perfil)) {
    return <Navigate to="/login" replace />;
  }

  return children;
}
