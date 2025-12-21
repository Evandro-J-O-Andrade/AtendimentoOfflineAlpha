import { BrowserRouter, Routes, Route } from "react-router-dom";
import { AuthProvider } from "./auth/AuthContext";
import PrivateRoute from "./auth/PrivateRoute";
import React from "react";

import Login from "./pages/Login";
import Dashboard from "./pages/Dashboard"; // Dashboard é a nova Home (lista de atendimentos/fila)
import Atendimento from "./pages/Atendimento"; // Rota para a Ficha Única

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          {/* ROTA PÚBLICA: /login */}
          <Route path="/login" element={<Login />} />
          
          {/* ROTA PROTEGIDA: Raiz (/) -> Dashboard/Fila */}
          <Route path="/dashboard" element={
            <PrivateRoute>
              <Dashboard />
            </PrivateRoute>
          } />
          
          {/* ROTA PROTEGIDA: Ficha Única do Paciente */}
          <Route path="/atendimento/:id" element={
            <PrivateRoute>
              <Atendimento />
            </PrivateRoute>
          } />
          
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}