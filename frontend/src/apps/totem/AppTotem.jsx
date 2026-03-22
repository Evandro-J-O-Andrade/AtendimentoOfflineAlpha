import React from "react";
import { Routes, Route, Navigate } from "react-router-dom";
import Totem from "./pages/Totem";

export default function AppTotem() {
  return (
    <Routes>
      <Route path="/" element={<Totem />} />
      <Route path="/senha" element={<Totem />} />
      <Route path="/satisfacao" element={<Totem />} />
      <Route path="*" element={<Navigate to="/" />} />
    </Routes>
  );
}
