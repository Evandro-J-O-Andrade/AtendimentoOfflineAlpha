import { BrowserRouter, Routes, Route } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import PrivateRoute from "./auth/PrivateRoute";
import React from "react";

// LOGIN / PÚBLICO
import Login from "./pages/login/Login";
import Totem from "./pages/painel/Totem";

// OPERAÇÃO / ATENDIMENTO
import Recepcao from "./pages/operacao/Recepcao";
import Medico from "./pages/atendimento/Medico";
import Atendimento from "./pages/atendimento/Atendimento";

// ADMIN
import Dashboard from "./pages/admin/Dashboard";
import AdminUsers from "./pages/admin/AdminUsers";
import Sessions from "./pages/admin/Sessions";

// SHARED
import NotFound from "./pages/shared/NotFound";

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>

          {/* PÚBLICAS */}
          <Route path="/login" element={<Login />} />
          <Route path="/totem" element={<Totem />} />

          {/* OPERAÇÃO */}
          <Route
            path="/recepcao"
            element={
              <PrivateRoute>
                <Recepcao />
              </PrivateRoute>
            }
          />

          {/* MÉDICO / FILA */}
          <Route
            path="/medico/fila"
            element={
              <PrivateRoute>
                <Medico />
              </PrivateRoute>
            }
          />

          {/* ATENDIMENTO (FFA) */}
          <Route
            path="/atendimento/:id"
            element={
              <PrivateRoute>
                <Atendimento />
              </PrivateRoute>
            }
          />

          {/* ADMIN */}
          <Route
            path="/dashboard"
            element={
              <PrivateRoute>
                <Dashboard />
              </PrivateRoute>
            }
          />

          <Route
            path="/admin/usuarios"
            element={
              <PrivateRoute>
                <AdminUsers />
              </PrivateRoute>
            }
          />

          <Route
            path="/account/sessions"
            element={
              <PrivateRoute>
                <Sessions />
              </PrivateRoute>
            }
          />

          {/* 404 */}
          <Route path="*" element={<NotFound />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}
