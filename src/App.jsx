import { BrowserRouter, Routes, Route } from "react-router-dom";
import { AuthProvider } from "./auth/AuthContext";
import PrivateRoute from "./auth/PrivateRoute";
import React from "react";

// Páginas
import Login from "./pages/Login";
import Dashboard from "./pages/Dashboard"; // Dashboard/Admin/Gestão
import Atendimento from "./pages/Atendimento"; // Ficha Única
import Totem from "./pages/Totem"; // Página pública do Totem
import Recepcao from "./pages/Recepcao"; // Recepção protegida
import Medico from "./pages/Medico"; // Médico protegido
import AdminUsers from "./pages/AdminUsers"; // Gestão de usuários (Admin / Suporte)
import Sessions from "./pages/Sessions"; // Sessões
import NotFound from "./pages/NotFound"; // 404

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          {/* ROTA PÚBLICA: Login */}
          <Route path="/login" element={<Login />} />

          {/* ROTA PÚBLICA: Totem */}
          <Route path="/totem" element={<Totem />} />

          {/* ROTA PROTEGIDA: Dashboard/Admin/Gestão */}
          <Route path="/dashboard" element={
            <PrivateRoute>
              <Dashboard />
            </PrivateRoute>
          } />

          {/* ROTA PROTEGIDA: Recepção */}
          <Route path="/recepcao" element={
            <PrivateRoute>
              <Recepcao />
            </PrivateRoute>
          } />

          {/* ROTA PROTEGIDA: Médico */}
          <Route path="/medico/fila" element={
            <PrivateRoute>
              <Medico />
            </PrivateRoute>
          } />

          {/* ROTA PROTEGIDA: Ficha de Atendimento */}
          <Route path="/atendimento/:id" element={
            <PrivateRoute>
              <Atendimento />
            </PrivateRoute>
          } />

          {/* ROTA PROTEGIDA: Gestão de Usuários (Admin / Suporte) */}
          <Route path="/admin/usuarios" element={
            <PrivateRoute>
              <AdminUsers />
            </PrivateRoute>
          } />

          {/* ROTA PROTEGIDA: Sessões */}
          <Route path="/account/sessions" element={
            <PrivateRoute>
              <Sessions />
            </PrivateRoute>
          } />

          {/* ROTA CURINGA: 404 */}
          <Route path="*" element={<NotFound />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}
