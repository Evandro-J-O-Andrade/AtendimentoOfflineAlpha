import { Outlet, useNavigate } from "react-router-dom";
import { useAuth } from "../../operacional/auth/AuthProvider";
import { useTheme } from "../theme/themeContext";
import { resolveBranding } from "../branding/branding";
import { PortalHeader } from "./PortalHeader";
import "../theme/tokens.css";
import "./PortalLayout.css";

interface AuthUser {
  nome?: string;
  nome_completo?: string;
  login?: string;
  usuario?: string;
}

function resolveUserName(user: AuthUser | null | undefined): string {
  if (!user) return "Usuário";
  return (
    user.nome ||
    user.nome_completo ||
    user.login ||
    user.usuario ||
    "Usuário"
  );
}

/** Layout base do Portal: cabeçalho fixo + área de conteúdo. */
export function PortalLayout() {
  const { theme } = useTheme();
  const { usuario, logout } = useAuth();
  const navigate = useNavigate();
  const branding = resolveBranding();

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  return (
    <div className="portal-root" data-portal-theme={theme}>
      <div className="portal-shell">
        <PortalHeader
          branding={branding}
          userName={resolveUserName(usuario as AuthUser)}
          notificationCount={3}
          onLogout={handleLogout}
        />
        <main className="portal-content">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
