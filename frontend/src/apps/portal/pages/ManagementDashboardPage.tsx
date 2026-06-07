import { Activity, BarChart3, Files, LifeBuoy, Users } from "lucide-react";
import { usePortalModules } from "../hooks/usePortalModules";

export default function ManagementDashboardPage() {
  const { modules } = usePortalModules();
  const activeModules = modules.filter((module) => module.active).length;

  const metrics = [
    { label: "Aplicações ativas", value: activeModules || "-", icon: Activity },
    { label: "Usuários", value: "-", icon: Users },
    { label: "Documentos", value: "-", icon: Files },
    { label: "Chamados", value: "-", icon: LifeBuoy },
  ];

  return (
    <main className="portal-page">
      <section className="portal-section-header">
        <div>
          <span className="portal-status active">Ativo</span>
          <h1>Dashboard de Gestão</h1>
          <p>Indicadores corporativos e visão consolidada da plataforma.</p>
        </div>
      </section>

      <section className="portal-metric-grid">
        {metrics.map((metric) => {
          const Icon = metric.icon;
          return (
            <article className="portal-metric-card" key={metric.label}>
              <Icon size={21} />
              <strong>{metric.value}</strong>
              <span>{metric.label}</span>
            </article>
          );
        })}
      </section>

      <section className="portal-dashboard-panel">
        <div className="portal-dashboard-visual" aria-hidden="true">
          <BarChart3 size={42} />
        </div>
        <div>
          <h2>Visão executiva</h2>
          <p>Área preparada para consolidação de BI, indicadores e administração multiempresa.</p>
        </div>
      </section>
    </main>
  );
}
