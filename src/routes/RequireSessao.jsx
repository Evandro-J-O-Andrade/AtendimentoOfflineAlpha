import React from "react";
import { Navigate } from "react-router-dom";
import { useAuth } from "@/features/auth/AuthContext.jsx";

export default function RequireSessao({ children }) {
  const { loading, user } = useAuth();

  if (loading) return null; // ou um spinner
  if (!user) return <Navigate to="/login" replace />;

  return children;
}