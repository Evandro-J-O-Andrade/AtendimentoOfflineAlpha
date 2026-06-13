import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/apps/operacional/auth/AuthProvider';
import PortalHeader from '@/components/portal/PortalHeader';
import ModuleGrid from '@/components/portal/ModuleGrid';

interface PortalModule {
  id: string;
  nome: string;
  descricao: string;
  icone: string;
  rota: string;
  requerContexto: boolean;
}

/**
 * PortalPage - New Wave Enterprise
 * Portal corporativo com lista de aplicações disponíveis.
 * Fluxo: Login → Portal → Aplicação → Contexto (se necessário) → Dashboard
 */
const PortalPage: React.FC = () => {
  const navigate = useNavigate();
  const { usuario, logout } = useAuth();

  const operacionais: PortalModule[] = [
    { id: 'atendimento', nome: 'Atendimento', descricao: 'Gestão operacional', icone: '🏥', rota: '/operacional', requerContexto: true },
    { id: 'farmacia', nome: 'Farmácia', descricao: 'Dispensação e estoque', icone: '💊', rota: '/operacional/farmacia', requerContexto: true },
    { id: 'estoque', nome: 'Estoque', descricao: 'Controle de materiais', icone: '📦', rota: '/operacional/estoque', requerContexto: true },
  ];

  const corporativos: PortalModule[] = [
    { id: 'financeiro', nome: 'Financeiro', descricao: 'Contas e faturamento', icone: '💰', rota: '/operacional/faturamento', requerContexto: false },
    { id: 'analytics', nome: 'Analytics', descricao: 'Indicadores corporativos', icone: '📊', rota: '/analytics', requerContexto: false },
    { id: 'rh', nome: 'RH', descricao: 'Gestão de pessoas', icone: '👥', rota: '/operacional/rh', requerContexto: false },
  ];

  const servicos: PortalModule[] = [
    { id: 'intranet', nome: 'Intranet', descricao: 'Comunicações internas', icone: '🏢', rota: '/corporativo/intranet', requerContexto: false },
    { id: 'chamados', nome: 'Chamados', descricao: 'Suporte interno', icone: '🎫', rota: '/chamados', requerContexto: false },
    { id: 'agenda', nome: 'Agenda', descricao: 'Compromissos', icone: '📅', rota: '/agenda', requerContexto: false },
    { id: 'documentos', nome: 'Documentos', descricao: 'Arquivo compartilhado', icone: '📄', rota: '/documentos', requerContexto: false },
    { id: 'crm', nome: 'CRM', descricao: 'Gestão de relacionamento', icone: '🤝', rota: '/crm', requerContexto: false },
    { id: 'ava', nome: 'AVA', descricao: 'Ambiente virtual', icone: '🎓', rota: '/ava', requerContexto: false },
  ];

  return (
    <div className="min-h-screen bg-slate-950 p-8">
      <div className="max-w-7xl mx-auto">
        <PortalHeader />

        <ModuleGrid modules={operacionais} title="Aplicações Operacionais" />
        <ModuleGrid modules={corporativos} title="Aplicações Corporativas" />
        <ModuleGrid modules={servicos} title="Serviços Corporativos" />
      </div>
    </div>
  );
};

export default PortalPage;