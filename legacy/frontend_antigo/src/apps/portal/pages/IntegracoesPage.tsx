import { Zap } from "lucide-react";

export default function IntegracoesPage() {
  return (
    <main className="portal-page">
      <section className="portal-section-header">
        <div>
          <h1>Integrações</h1>
          <p>Automatize fluxos com N8N e Webhooks.</p>
        </div>
      </section>

      <section className="portal-module-grid">
        <article className="portal-module-card">
          <div className="portal-module-icon">
            <Zap size={24} />
          </div>
          <div className="portal-module-copy">
            <h2>N8N Workflows</h2>
            <p>Automatize processos com N8N.</p>
          </div>
        </article>
      </section>
    </main>
  );
}