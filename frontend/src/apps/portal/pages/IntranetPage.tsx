import {
  CalendarDays,
  Cake,
  Megaphone,
  MessageSquareHeart,
  Newspaper,
  PartyPopper,
  Vote,
} from "lucide-react";

const intranetAreas = [
  { title: "Feed corporativo", icon: Newspaper },
  { title: "Comunicados", icon: Megaphone },
  { title: "Aniversariantes", icon: Cake },
  { title: "Eventos", icon: CalendarDays },
  { title: "Enquetes", icon: Vote },
  { title: "Reconhecimentos", icon: MessageSquareHeart },
];

export default function IntranetPage() {
  return (
    <main className="portal-page">
      <section className="portal-section-header">
        <div>
          <span className="portal-status inactive">Inativo</span>
          <h1>Intranet Corporativa</h1>
          <p>Comunicação institucional e interação entre colaboradores.</p>
        </div>
      </section>

      <section className="portal-feature-grid">
        {intranetAreas.map((area) => {
          const Icon = area.icon;
          return (
            <article className="portal-feature-card" key={area.title}>
              <Icon size={24} />
              <h2>{area.title}</h2>
            </article>
          );
        })}
      </section>

      <section className="portal-timeline-panel">
        <PartyPopper size={22} />
        <div>
          <h2>Módulo reservado</h2>
          <p>Estrutura preparada para a próxima etapa de implementação.</p>
        </div>
      </section>
    </main>
  );
}
