import { useState } from "react";
import { Building2, ChevronDown, LogOut, UserCircle } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/app/providers/AuthProvider";
import { getPortalBranding } from "../services/branding";
import NotificationWidget from "./NotificationWidget";

function getUserName(usuario: unknown, session: unknown): string {
  const user = usuario as { nome?: string; login?: string } | null;
  const currentSession = session as { usuario?: { nome?: string; login?: string } } | null;
  return user?.nome || user?.login || currentSession?.usuario?.nome || currentSession?.usuario?.login || "Usuário";
}

export function PortalHeader() {
  const navigate = useNavigate();
  const { usuario, session, logout } = useAuth();
  const [profileOpen, setProfileOpen] = useState(false);
  const [logoFailed, setLogoFailed] = useState(false);
  const brand = getPortalBranding();
  const userName = getUserName(usuario, session);

  function handleLogout() {
    logout();
    navigate("/login", { replace: true });
  }

  return (
    <header className="portal-header">
      <button type="button" className="portal-brand" onClick={() => navigate("/portal")}>
        <span className="portal-brand-logo" aria-hidden="true">
          {brand.logoUrl && !logoFailed ? (
            <img src={brand.logoUrl} alt="" onError={() => setLogoFailed(true)} />
          ) : (
            <Building2 size={22} />
          )}
        </span>
        <span className="portal-brand-copy">
          <strong>{brand.organizationName}</strong>
          <small>{brand.productName}</small>
        </span>
      </button>

      <div className="portal-header-actions">
        <NotificationWidget />

        <div className="portal-profile">
          <button
            type="button"
            className="portal-profile-trigger"
            onClick={() => setProfileOpen((current) => !current)}
            aria-expanded={profileOpen}
          >
            <UserCircle size={22} />
            <span>{userName}</span>
            <ChevronDown size={16} />
          </button>

          {profileOpen && (
            <div className="portal-profile-menu">
              <div className="portal-profile-summary">
                <strong>{userName}</strong>
                <small>{brand.companyName}</small>
              </div>
              <button type="button" onClick={handleLogout}>
                <LogOut size={16} />
                Sair
              </button>
            </div>
          )}
        </div>
      </div>
    </header>
  );
}
