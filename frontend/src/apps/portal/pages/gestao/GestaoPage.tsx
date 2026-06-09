import {
  Activity,
  ChartColumn,
  ChartPie,
  Gauge,
  LayoutDashboard,
  Target,
  TrendingUp,
  Users,
} from "lucide-react";
import {
  ModulePlaceholder,
  type PlaceholderSection,
} from "../../components/ModulePlaceholder";

const sections: PlaceholderSection[] = [
  {
    title: "Visão geral",
    description: "Indicadores consolidados da operação.",
    icon: Gauge,
  },
  {
    title: "Desempenho",
    description: "Evolução de métricas ao longo do tempo.",
    icon: TrendingUp,
  },
  {
    title: "Distribuições",
    description: "Composição e participação por categoria.",
    icon: ChartPie,
  },
  {
    title: "Comparativos",
    description: "Comparação entre períodos e áreas.",
    icon: ChartColumn,
  },
  {
    title: "Metas",
    description: "Acompanhamento de objetivos e metas.",
    icon: Target,
  },
  {
    title: "Equipes",
    description: "Produtividade e indicadores por equipe.",
    icon: Users,
  },
  {
    title: "Atividade",
    description: "Eventos recentes e auditoria.",
    icon: Activity,
  },
];

/** Módulo Gestão — dashboard de indicadores (estrutura inicial). */
export function GestaoPage() {
  return (
    <ModulePlaceholder
      title="Gestão"
      description="Dashboards e indicadores para tomada de decisão."
      icon={LayoutDashboard}
      badge="Em construção"
      sections={sections}
    />
  );
}
