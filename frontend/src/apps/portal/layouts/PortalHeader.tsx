import { useEffect, useRef, useState } from "react";
import { Bell, ChevronDown, LogOut, Moon, Settings, Sun, User } from "lucide-react";
import { IconButton } from "../components/ui/IconButton";
import { useTheme } from "../theme/themeContext";
import type { Branding } from "../branding/branding";
import "./PortalHeader.css";

interface PortalHeaderProps {
  branding: Branding;
  userName: string;
  notificationCount?: number;
  onLogout: () => void;
}

/** Cabeçalho do Portal: marca, notificações, dark mode e menu de perfil. */
export function PortalHeader({
  branding,
  userName,
  notificationCount = 0,
  onLogout,
}: PortalHeaderProps) {
  const { theme, toggleTheme } = useTheme();
  const [menuOpen, setMenuOpen] = useState(false);
  const menuRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        setMenuOpen(false);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const initials = userName
    .split(" ")
    .map((part) => part.charAt(0))
    .slice(0, 2)
    .join("")
    .toUpperCase();

  return (
    <header className="pt-header">
      <div className="pt-header__brand">
        <img
          className="pt-header__logo"
          src={branding.logoUrl}
          alt={branding.organizationName}
          onError={(e) => {
            (e.currentTarget as HTMLImageElement).style.display = "none";
          }}
        />
        <div className="pt-header__brand-text">
          <span className="pt-header__org">{branding.organizationName}</span>
          <span className="pt-header__platform">{branding.platformName}</span>
        </div>
      </div>

      <div className="pt-header__actions">
        <IconButton
          label={theme === "dark" ? "Tema claro" : "Tema escuro"}
          onClick={toggleTheme}
        >
          {theme === "dark" ? <Sun size={20} /> : <Moon size={20} />}
        </IconButton>

        <IconButton label="Notificações" badgeCount={notificationCount}>
          <Bell size={20} />
        </IconButton>

        <div className="pt-header__profile" ref={menuRef}>
          <button
            type="button"
            className="pt-header__profile-trigger"
            onClick={() => setMenuOpen((open) => !open)}
            aria-haspopup="menu"
            aria-expanded={menuOpen}
          >
            <span className="pt-header__avatar">{initials || "?"}</span>
            <span className="pt-header__user">{userName}</span>
            <ChevronDown size={16} />
          </button>

          {menuOpen && (
            <div className="pt-header__menu" role="menu">
              <button type="button" className="pt-header__menu-item" role="menuitem">
                <User size={16} /> Meu perfil
              </button>
              <button type="button" className="pt-header__menu-item" role="menuitem">
                <Settings size={16} /> Preferências
              </button>
              <div className="pt-header__menu-divider" />
              <button
                type="button"
                className="pt-header__menu-item pt-header__menu-item--danger"
                role="menuitem"
                onClick={onLogout}
              >
                <LogOut size={16} /> Sair
              </button>
            </div>
          )}
        </div>
      </div>
    </header>
  );
}
