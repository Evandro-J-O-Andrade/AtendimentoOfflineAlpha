import React from "react";
import { Routes, Route, Navigate } from "react-router-dom";
import PainelCentralLayout from "@/pages/painel/PainelCentralLayout";

export default function PainelRouter() {
  return (
    <Routes>
      <Route path="/" element={<PainelCentralLayout />} />
      <Route path="*" element={<Navigate to="/painel" />} />
    </Routes>
  );
}