import { Users, Building2, CreditCard } from "lucide-react";

const sistemas = [
  { id: "his", nome: "HIS", icon: Building2, desc: "Hospital Information System", cor: "portal-accent-blue" },
  { id: "pdv", nome: "PDV", icon: CreditCard, desc: "Ponto de Venda", cor: "portal-accent-emerald" },
  { id: "crm", nome: "CRM", icon: Users, desc: "Gestão de Relacionamento", cor: "portal-accent-violet" },
];

export default function PortalHomePage() {
  return (
    <main className="portal-page">
      <section className="portal-section-header">
        <div>
          <h1>Portal Corporativo</h1>
          <p>Selecione um sistema para iniciar a sessão operacional.</p>
        </div>
      </section>

      <section className="portal-module-grid">
        {sistemas.map((sistema) => {
          const Icon = sistema.icon;
          return (
            <article className="portal-module-card" key={sistema.id}>
              <div className="portal-module-card-top">
                <div className="portal-module-icon">
                  <Icon size={24} />
                </div>
              </div>
              <div className="portal-module-copy">
                <h2>{sistema.nome}</h2>
                <p>{sistema.desc}</p>
              </div>
              <div className="portal-module-footer">
                <button className="portal-module-action">Acessar</button>
              </div>
            </article>
          );
        })}
      </section>
    </main>
  );
}