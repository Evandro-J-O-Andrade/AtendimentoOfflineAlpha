import React from "react";
import { AppProvider } from "./context/AppContext";
import { RuntimeAuthProvider } from "./apps/operacional/auth/RuntimeAuthContext";
import AppRouter from "./router/index.jsx";

export default function App() {
  return (
    <RuntimeAuthProvider>
      <AppProvider>
        <AppRouter />
      </AppProvider>
    </RuntimeAuthProvider>
  );
}
