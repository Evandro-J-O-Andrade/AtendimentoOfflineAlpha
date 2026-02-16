import React from "react";
import { Routes, Route, Navigate } from "react-router-dom";
import RequireSessao from "@/routes/RequireSessao";

// Reaproveita layouts existentes
import RecepcaoLayout from "@/pages/recepcao/RecepcaoLayout";
import TriagemLayout from "@/pages/triagem/TriagemLayout";
import ConsultorioLayout from "@/pages/consultorio/ConsultorioLayout";
import InternacaoLayout from "@/pages/internacao/InternacaoLayout";

export default function AppOperacionalRouter() {
  return (
    <RequireSessao>
      <Routes>
        <Route path="/" element={<Navigate to="/app/recepcao" />} />
        <Route path="/recepcao" element={<RecepcaoLayout />} />
        <Route path="/triagem" element={<TriagemLayout />} />
        <Route path="/consultorio" element={<ConsultorioLayout />} />
        <Route path="/internacao" element={<InternacaoLayout />} />
        <Route path="*" element={<Navigate to="/app/recepcao" />} />
      </Routes>
    </RequireSessao>
  );
}