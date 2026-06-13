import React from "react";
import { Routes, Route, Navigate } from "react-router-dom";
import PainelTriagem from "./pages/PainelTriagem";
import PainelUsuario from "./pages/PainelUsuario";
import Painel from "./pages/Painel";

export default function AppPainel() {
  return (
    <Routes>
      <Route path="/" element={<PainelUsuario />} />
      <Route path="/triagem" element={<PainelTriagem />} />
      <Route path="/senhas" element={<Painel />} />
      <Route path="/painel-chamadas" element={<Painel />} />
      <Route path="*" element={<Navigate to="/" />} />
    </Routes>
  );
}
