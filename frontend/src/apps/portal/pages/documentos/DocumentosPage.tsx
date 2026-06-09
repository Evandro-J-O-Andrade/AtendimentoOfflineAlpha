import {
  CircleCheck,
  Download,
  FileText,
  FolderTree,
  GitBranch,
  Search,
  Star,
} from "lucide-react";
import {
  ModulePlaceholder,
  type PlaceholderSection,
} from "../../components/ModulePlaceholder";

const sections: PlaceholderSection[] = [
  {
    title: "Categorias",
    description: "Organização de documentos por categorias.",
    icon: FolderTree,
  },
  {
    title: "Pesquisa",
    description: "Busca avançada por conteúdo e metadados.",
    icon: Search,
  },
  {
    title: "Versionamento",
    description: "Controle de versões dos documentos.",
    icon: GitBranch,
  },
  {
    title: "Aprovação",
    description: "Fluxo de aprovação e revisão.",
    icon: CircleCheck,
  },
  {
    title: "Downloads",
    description: "Acesso e exportação de arquivos.",
    icon: Download,
  },
  {
    title: "Favoritos",
    description: "Documentos marcados para acesso rápido.",
    icon: Star,
  },
];

/** Módulo Gestão Documental — reservado para implementação futura. */
export function DocumentosPage() {
  return (
    <ModulePlaceholder
      title="Gestão Documental"
      description="Repositório central de documentos com categorias, versionamento e aprovação."
      icon={FileText}
      sections={sections}
    />
  );
}
