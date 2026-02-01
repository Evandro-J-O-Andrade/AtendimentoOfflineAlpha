import React from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import { AtendimentoProvider } from "./context/AtendimentoContext";
import PrivateRoute from "./routes/PrivateRoute";
import RequireLocal from "./routes/RequireContexto";
import SelecionarContexto from "./pages/contexto/SelecionarContexto";


// PÁGINAS PÚBLICAS
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

// PAINÉIS DIRETOS
import Clinico from "./pages/painel/Clinico";
import Pediatrico from "./pages/painel/Pediatrico";
import MedicacaoAdulta from "./pages/painel/MedicacaoAdulta";
import MedicacaoInfantil from "./pages/painel/MedicacaoInfantil";
import RX from "./pages/painel/RX";
import Coleta from "./pages/painel/Coleta";
import Satisfacao from "./pages/painel/Satisfacao";

// SHARED
import NotFound from "./pages/shared/NotFound";

export default function App() {
  return (
    <AuthProvider>
      <AtendimentoProvider>
        <BrowserRouter>
          <Routes>

          {/* PÚBLICAS */}
          <Route path="/login" element={<Login />} />
          <Route path="/totem" element={<Totem />} />

          <Route
  path="/contexto"
  element={
    <PrivateRoute>
      <SelecionarContexto />
    </PrivateRoute>
  }
/>

          {/* OPERAÇÃO */}
          <Route
            path="/recepcao"
            element={
              <PrivateRoute perfil="RECEPCAO">
                <RequireLocal>
                  <Recepcao />
                </RequireLocal>
              </PrivateRoute>
            }
          />

          <Route
            path="/medico/fila"
            element={
              <PrivateRoute perfil="MEDICO">
                <RequireLocal>
                  <Medico />
                </RequireLocal>
              </PrivateRoute>
            }
          />

          <Route
            path="/atendimento/:id"
            element={
              <PrivateRoute>
                <RequireLocal>
                  <Atendimento />
                </RequireLocal>
              </PrivateRoute>
            }
          />

          {/* ADMIN */}
          <Route
            path="/dashboard"
            element={
              <PrivateRoute perfil="ADMIN_MASTER">
                <Dashboard />
              </PrivateRoute>
            }
          />
          <Route
            path="/admin/usuarios"
            element={
              <PrivateRoute perfil="ADMIN_MASTER">
                <AdminUsers />
              </PrivateRoute>
            }
          />
          <Route
            path="/account/sessions"
            element={
              <PrivateRoute perfil="ADMIN_MASTER">
                <Sessions />
              </PrivateRoute>
            }
          />

          {/* PAINÉIS DIRETOS */}
          <Route
            path="/painel/clinico"
            element={
              <PrivateRoute perfil="MEDICO">
                <RequireLocal>
                  <Clinico />
                </RequireLocal>
              </PrivateRoute>
            }
          />
          <Route
            path="/painel/pediatrico"
            element={
              <PrivateRoute perfil="MEDICO">
                <RequireLocal>
                  <Pediatrico />
                </RequireLocal>
              </PrivateRoute>
            }
          />
          <Route
            path="/painel/medicacao-adulta"
            element={
              <PrivateRoute perfil="MEDICO">
                <RequireLocal>
                  <MedicacaoAdulta />
                </RequireLocal>
              </PrivateRoute>
            }
          />
          <Route
            path="/painel/medicacao-infantil"
            element={
              <PrivateRoute perfil="MEDICO">
                <RequireLocal>
                  <MedicacaoInfantil />
                </RequireLocal>
              </PrivateRoute>
            }
          />
          <Route
            path="/painel/rx"
            element={
              <PrivateRoute perfil="MEDICO">
                <RequireLocal>
                  <RX />
                </RequireLocal>
              </PrivateRoute>
            }
          />
          <Route
            path="/painel/coleta"
            element={
              <PrivateRoute perfil="ENFERMAGEM">
                <RequireLocal>
                  <Coleta />
                </RequireLocal>
              </PrivateRoute>
            }
          />
          <Route
            path="/painel/satisfacao"
            element={
              <PrivateRoute perfil="ADM_RECEPCAO">
                <RequireLocal>
                  <Satisfacao />
                </RequireLocal>
              </PrivateRoute>
            }
          />

          {/* 404 */}
          <Route path="*" element={<NotFound />} />

        </Routes>
        </BrowserRouter>
      </AtendimentoProvider>
    </AuthProvider>
  );
}
