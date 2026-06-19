import { CalendarDays, Megaphone } from "lucide-react";

const intranetAreas = [
  { title: "Feed corporativo", icon: Megaphone },
  { title: "Calendário", icon: CalendarDays },
];

export default function IntranetPage() {
  return (
    <main className="portal-page">
      <section className="portal-section-header">
        <div>
          <h1>Intranet Corporativa</h1>
          <p>Comunicação institucional.</p>
        </div>
      </section>

      <section className="portal-module-grid">
        {intranetAreas.map((area) => {
          const Icon = area.icon;
          return (
            <article className="portal-module-card" key={area.title}>
              <Icon size={24} />
              <h2>{area.title}</h2>
            </article>
          );
        })}
      </section>
    </main>
  );
}