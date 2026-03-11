import React from "react";
import { AppProvider, useApp } from "./context/AppContext";
import Login from "./apps/auth/pages/Login";
import Painel from "./apps/operacional/pages/Painel";

function AppRouter() {
  const { usuario, loading } = useApp();

  if (loading) {
    return (
      <div style={{ display: "flex", justifyContent: "center", alignItems: "center", height: "100vh" }}>
        <p>Carregando...</p>
      </div>
    );
  }

  return usuario ? <Painel /> : <Login />;
}

export default function App() {
  return (
    <AppProvider>
      <AppRouter />
    </AppProvider>
  );
}
