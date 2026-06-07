import React from 'react';
import { LayoutGrid, Users, FileText, GraduationCap, LifeBuoy, Stethoscope, Pill, Package, BarChart3, Globe } from 'lucide-react';
import { ApplicationCard } from '@/shared/components/ApplicationCard';

const MODULES = {
  CORPORATIVO: [
    { id: 'intranet', title: 'Intranet', icon: Globe, color: 'bg-blue-500', path: '/corporativo/intranet' },
    { id: 'social', title: 'Rede Social', icon: Users, color: 'bg-indigo-500', path: '/corporativo/social' },
    { id: 'documentos', title: 'Documentos', icon: FileText, color: 'bg-orange-500', path: '/corporativo/documentos' },
    { id: 'ava', title: 'Treinamentos', icon: GraduationCap, color: 'bg-emerald-500', path: '/corporativo/treinamentos' },
    { id: 'chamados', title: 'Chamados', icon: LifeBuoy, color: 'bg-red-500', path: '/corporativo/chamados' },
  ],
  OPERACIONAL: [
    { id: 'atendimento', title: 'Atendimento', icon: Stethoscope, color: 'bg-rose-500', path: '/contexto-selection' },
    { id: 'farmacia', title: 'Farmácia', icon: Pill, color: 'bg-teal-500', path: '/operacional/farmacia' },
    { id: 'estoque', title: 'Estoque', icon: Package, color: 'bg-amber-500', path: '/operacional/estoque' },
  ],
  GESTAO: [
    { id: 'gestao', title: 'Gestão/BI', icon: BarChart3, color: 'bg-purple-600', path: '/gestao/dashboard' },
  ]
};

const PortalHome: React.FC = () => {
  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <header className="mb-12">
        <h1 className="text-3xl font-extrabold text-gray-900 tracking-tight">Portal Corporativo</h1>
        <p className="text-gray-500 mt-2">Selecione o módulo para iniciar suas atividades.</p>
      </header>

      <div className="space-y-12">
        <section>
          <div className="flex items-center gap-2 mb-6 border-b pb-2">
            <LayoutGrid className="text-blue-600" size={20} />
            <h2 className="text-xl font-bold text-gray-800 uppercase tracking-wider">Ecossistema Corporativo</h2>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6">
            {MODULES.CORPORATIVO.map(mod => <ApplicationCard key={mod.id} {...mod} />)}
          </div>
        </section>

        <section>
          <div className="flex items-center gap-2 mb-6 border-b pb-2">
            <Stethoscope className="text-rose-600" size={20} />
            <h2 className="text-xl font-bold text-gray-800 uppercase tracking-wider">Operacional</h2>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6">
            {MODULES.OPERACIONAL.map(mod => <ApplicationCard key={mod.id} {...mod} />)}
          </div>
        </section>
      </div>
    </div>
  );
};

export default PortalHome;