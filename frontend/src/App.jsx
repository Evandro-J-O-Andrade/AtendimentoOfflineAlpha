import React, { Suspense } from "react";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import { AuthProvider, useAuth } from "./apps/operacional/auth/AuthProvider";

// Lazy loading dos módulos principais
const AppOperacional = React.lazy(() => import("./apps/operacional/AppOperacional"));
const AppPainel = React.lazy(() => import("./apps/painel/AppPainel"));
const AppTotem = React.lazy(() => import("./apps/totem/AppTotem"));
const AppPortal = React.lazy(() => import("./apps/portal/AppPortal"));
const LoginPage = React.lazy(() => import("./apps/login/LoginPage"));
const SelecionarContexto = React.lazy(() => import("./apps/operacional/pages/contexto/SelecionarContexto"));

// Rota privada baseada em autenticação
function PrivateRoute({ children }) {
  const { usuario, loading } = useAuth();
  
  if (loading) {
    return <div>Carregando...</div>;
  }
  
  return usuario ? children : <Navigate to="/login" />;
}

export default function App() {
  return (
    <AuthProvider>
      <Router>
        <Suspense fallback={<div>Carregando...</div>}>
          <Routes>
            {/* Rota de login */}
            <Route path="/login" element={<LoginPage />} />

            {/* Portal Corporativo — tela inicial após autenticação */}
            <Route
              path="/portal/*"
              element={
                <PrivateRoute>
                  <AppPortal />
                </PrivateRoute>
              }
            />

            {/* Rota de seleção de contexto */}
            <Route 
              path="/contexto" 
              element={
                <PrivateRoute>
                  <SelecionarContexto />
                </PrivateRoute>
              } 
            />

            {/* Módulo Operacional */}
            <Route
              path="/operacional/*"
              element={
                <PrivateRoute>
                  <AppOperacional />
                </PrivateRoute>
              }
            />

            {/* Módulo Painel */}
            <Route
              path="/painel/*"
              element={
                <PrivateRoute>
                  <AppPainel />
                </PrivateRoute>
              }
            />

            {/* Módulo Totem */}
            <Route
              path="/totem/*"
              element={
                <PrivateRoute>
                  <AppTotem />
                </PrivateRoute>
              }
            />

            {/* Redireciona qualquer rota desconhecida para login */}
            <Route path="*" element={<Navigate to="/login" />} />
          </Routes>
        </Suspense>
      </Router>
    </AuthProvider>
  );
}
