import React from "react";
import { Routes, Route, Navigate } from "react-router-dom";
import TotemHome from "@/pages/totem/TotemHome";

export default function TotemRouter() {
  return (
    <Routes>
      <Route path="/" element={<TotemHome />} />
      <Route path="*" element={<Navigate to="/totem" />} />
    </Routes>
  );
}