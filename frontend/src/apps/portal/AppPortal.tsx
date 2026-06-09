import { ThemeProvider } from "./theme/ThemeProvider";
import { PortalRoutes } from "./routes/PortalRoutes";

/** Ponto de entrada do módulo Portal Corporativo. */
export default function AppPortal() {
  return (
    <ThemeProvider>
      <PortalRoutes />
    </ThemeProvider>
  );
}
