import { Boxes, Files, GraduationCap, LifeBuoy, Warehouse } from "lucide-react";
import { useParams } from "react-router-dom";

const reservedModules = {
  almoxarifado: {
    title: "Almoxarifado",
    description: "Requisições internas, separação e distribuição de itens.",
    icon: Warehouse,
  },
  treinamentos: {
    title: "Treinamentos",
    description: "Cursos, trilhas, avaliações e certificados.",
    icon: GraduationCap,
  },
  documentos: {
    title: "Documentos",
    description: "Categorias, pesquisa, versionamento, aprovação e downloads.",
    icon: Files,
  },
  chamados: {
    title: "Chamados",
    description: "Solicitações, suporte, acompanhamento e resolução.",
    icon: LifeBuoy,
  },
};

export default function ReservedModulePage() {
  const { moduleId = "" } = useParams();
  const module = reservedModules[moduleId as keyof typeof reservedModules] || {
    title: "Módulo",
    description: "Estrutura reservada para implementação futura.",
    icon: Boxes,
  };
  const Icon = module.icon;

  return (
    <main className="portal-page">
      <section className="portal-section-header">
        <div>
          <span className="portal-status inactive">Inativo</span>
          <h1>{module.title}</h1>
          <p>{module.description}</p>
        </div>
      </section>

      <section className="portal-reserved-panel">
        <Icon size={34} />
        <div>
          <h2>Módulo reservado</h2>
          <p>Base de navegação e autorização pronta para evolução funcional.</p>
        </div>
      </section>
    </main>
  );
}
