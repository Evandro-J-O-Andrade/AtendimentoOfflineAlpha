import { useNavigate } from "react-router-dom";
import { ModuleGrid } from "../components/ModuleGrid";
import { usePortalModules } from "../hooks/usePortalModules";
import type { PortalModule } from "../types/portal";
import "./PortalHome.css";

/** Tela principal do Portal Corporativo (grid de módulos). */
export function PortalHome() {
  const navigate = useNavigate();
  const { modules, loading } = usePortalModules();

  const handleOpen = (module: PortalModule) => {
    if (module.type === "operational") {
      // Contexto operacional só é solicitado ao entrar no módulo.
      navigate("/contexto", { state: { redirect: module.route } });
      return;
    }
    navigate(module.route);
  };

  return (
    <div className="pt-home">
      <div className="pt-home__header">
        <h1 className="pt-home__title">Aplicações</h1>
        <p className="pt-home__subtitle">
          Selecione um módulo para começar. Apenas os módulos liberados para o
          seu perfil são exibidos.
        </p>
      </div>

      {loading ? (
        <div className="pt-home__loading">Carregando módulos...</div>
      ) : (
        <ModuleGrid modules={modules} onOpen={handleOpen} />
      )}
    </div>
  );
}
