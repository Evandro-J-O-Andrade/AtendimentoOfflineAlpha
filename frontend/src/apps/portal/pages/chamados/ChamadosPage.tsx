import {
  Clock,
  Inbox,
  LifeBuoy,
  MessageSquare,
  TicketCheck,
  TrendingUp,
} from "lucide-react";
import {
  ModulePlaceholder,
  type PlaceholderSection,
} from "../../components/ModulePlaceholder";

const sections: PlaceholderSection[] = [
  {
    title: "Abertura de chamados",
    description: "Registro de solicitações e incidentes.",
    icon: Inbox,
  },
  {
    title: "Acompanhamento",
    description: "Status e andamento dos chamados.",
    icon: Clock,
  },
  {
    title: "Atendimento",
    description: "Tratativa e respostas das equipes.",
    icon: MessageSquare,
  },
  {
    title: "Resolução",
    description: "Encerramento e validação de chamados.",
    icon: TicketCheck,
  },
  {
    title: "Indicadores",
    description: "SLA, volume e tempo de resposta.",
    icon: TrendingUp,
  },
];

/** Módulo Central de Chamados — reservado para implementação futura. */
export function ChamadosPage() {
  return (
    <ModulePlaceholder
      title="Central de Chamados"
      description="Abertura, acompanhamento e resolução de chamados e suporte interno."
      icon={LifeBuoy}
      sections={sections}
    />
  );
}
