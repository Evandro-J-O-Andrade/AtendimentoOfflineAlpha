import { Users } from "lucide-react";

export default function PainelTriagem() {
  return (
    <main className="portal-page">
      <section className="portal-section-header">
        <div>
          <h1>Painel de Triagem</h1>
          <p>Monitoramento de senhas e filas de atendimento.</p>
        </div>
      </section>
      <section className="portal-reserved-panel">
        <Users size={34} />
        <div>
          <h2>Módulo em desenvolvimento</h2>
          <p>Estrutura preparada para integração com fila em tempo real.</p>
        </div>
      </section>
    </main>
  );
}