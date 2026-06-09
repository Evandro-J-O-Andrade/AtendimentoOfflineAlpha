import {
  Award,
  Cake,
  CalendarDays,
  Hash,
  Megaphone,
  MessageSquare,
  Newspaper,
  Rss,
  ThumbsUp,
  Users,
  Vote,
} from "lucide-react";
import {
  ModulePlaceholder,
  type PlaceholderSection,
} from "../../components/ModulePlaceholder";

const sections: PlaceholderSection[] = [
  {
    title: "Feed corporativo",
    description: "Publicações da empresa em um feed cronológico.",
    icon: Rss,
  },
  {
    title: "Comunicados",
    description: "Avisos e notícias institucionais oficiais.",
    icon: Megaphone,
  },
  {
    title: "Aniversariantes",
    description: "Aniversários de colaboradores do mês.",
    icon: Cake,
  },
  {
    title: "Eventos",
    description: "Agenda corporativa e calendário de eventos.",
    icon: CalendarDays,
  },
  {
    title: "Enquetes",
    description: "Pesquisas internas e votações.",
    icon: Vote,
  },
  {
    title: "Reconhecimentos",
    description: "Destaques e elogios entre colaboradores.",
    icon: Award,
  },
  {
    title: "Rede social corporativa",
    description: "Curtidas, comentários, menções e hashtags.",
    icon: ThumbsUp,
  },
  {
    title: "Grupos",
    description: "Comunidades e times para colaboração.",
    icon: Users,
  },
  {
    title: "Mensagens",
    description: "Interações e conversas entre equipes.",
    icon: MessageSquare,
  },
  {
    title: "Hashtags",
    description: "Organização de conteúdo por temas.",
    icon: Hash,
  },
];

/** Módulo Intranet — reservado para implementação futura. */
export function IntranetPage() {
  return (
    <ModulePlaceholder
      title="Intranet Corporativa"
      description="Comunicação institucional e rede social corporativa para engajar os colaboradores."
      icon={Newspaper}
      sections={sections}
    />
  );
}
