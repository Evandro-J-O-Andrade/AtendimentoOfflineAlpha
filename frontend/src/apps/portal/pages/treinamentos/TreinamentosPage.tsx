import {
  Award,
  BookOpen,
  ClipboardCheck,
  GraduationCap,
  History,
  Route,
} from "lucide-react";
import {
  ModulePlaceholder,
  type PlaceholderSection,
} from "../../components/ModulePlaceholder";

const sections: PlaceholderSection[] = [
  {
    title: "Cursos",
    description: "Catálogo de cursos disponíveis.",
    icon: BookOpen,
  },
  {
    title: "Trilhas",
    description: "Trilhas de aprendizagem organizadas por tema.",
    icon: Route,
  },
  {
    title: "Certificados",
    description: "Emissão e consulta de certificados.",
    icon: Award,
  },
  {
    title: "Avaliações",
    description: "Provas e avaliações de conhecimento.",
    icon: ClipboardCheck,
  },
  {
    title: "Histórico",
    description: "Histórico de conclusões e progresso.",
    icon: History,
  },
];

/** Módulo Treinamentos — reservado para implementação futura. */
export function TreinamentosPage() {
  return (
    <ModulePlaceholder
      title="Treinamentos"
      description="Cursos, trilhas, certificações e avaliações para capacitação dos colaboradores."
      icon={GraduationCap}
      sections={sections}
    />
  );
}
