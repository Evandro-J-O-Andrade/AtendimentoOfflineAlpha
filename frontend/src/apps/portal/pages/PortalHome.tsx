import React, { useEffect, useState, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { 
  Activity, FlaskConical, Package, Warehouse, 
  BarChart3, Globe, GraduationCap, FileText, LifeBuoy 
} from 'lucide-react';
import { Modulo } from '../../../shared/types/module';
import ApplicationCard from '../components/ApplicationCard';
import ApplicationGrid from '../components/ApplicationGrid';
import { useTenant } from '@/context/TenantProvider';
import QuickAccessWidget from '../components/QuickAccessWidget';
import { useRecentModules } from '../hooks/useRecentModules';
import ApplicationCardSkeleton from '../components/ApplicationCardSkeleton';

const PortalHome: React.FC = () => {
  const navigate = useNavigate();
  const { brand } = useTenant();
  const [loading, setLoading] = useState(true);

  // Gerencia o carregamento inicial dos módulos
  useEffect(() => {
    // Simula o tempo de carregamento dos módulos
    const timer = setTimeout(() => {
      setLoading(false);
    }, 1200);

    return () => clearTimeout(timer);
  }, []);

  // Mock de Módulos (Em produção viria do hook useMenu/Permissions)
  const modulos: Modulo[] = [
    { id: 1, codigo: 'ATEN', nome: 'Atendimento', descricao: 'Operação assistencial, recepção e triagem.', icone: Activity, rota: '/operacional/contexto', ativo: true, categoria: 'operacional', color: 'bg-brand-primary', favorito: true, ultimoAcesso: 'Hoje, 10:20' },
    { id: 2, codigo: 'FARM', nome: 'Farmácia', descricao: 'Gestão de dispensação e controle farmacêutico.', icone: FlaskConical, rota: '/operacional/contexto', ativo: true, categoria: 'operacional', color: 'bg-brand-secondary', favorito: false, ultimoAcesso: 'Ontem' },
    { id: 3, codigo: 'ESTO', nome: 'Estoque', descricao: 'Movimentação e controle global de insumos.', icone: Package, rota: '/operacional/estoque', ativo: true, categoria: 'operacional', color: 'bg-blue-500', favorito: false },
    { id: 4, codigo: 'ALMO', nome: 'Almoxarifado', descricao: 'Gestão de suprimentos internos e requisições.', icone: Warehouse, rota: '/operacional/almoxarifado', ativo: true, categoria: 'operacional', color: 'bg-cyan-500', favorito: false },
    { id: 5, codigo: 'GEST', nome: 'Gestão', descricao: 'Dashboards corporativos e indicadores de performance.', icone: BarChart3, rota: '/operacional', ativo: true, categoria: 'gestao', color: 'bg-brand-accent', favorito: true, ultimoAcesso: 'Segunda-feira' },
    { id: 6, codigo: 'INTR', nome: 'Intranet', descricao: 'Comunicação institucional e notícias corporativas.', icone: Globe, rota: '/portal/intranet', ativo: true, categoria: 'corporativo', color: 'bg-orange-500', favorito: true, ultimoAcesso: 'Há 2 horas' },
    { id: 7, codigo: 'TREI', nome: 'Treinamentos', descricao: 'Plataforma de capacitação e trilhas de aprendizado.', icone: GraduationCap, rota: '/portal/treinamentos', ativo: false, categoria: 'corporativo', color: 'bg-brand-secondary', favorito: false },
    { id: 8, codigo: 'DOCS', nome: 'Documentos', descricao: 'Gestão documental, normas técnicas e POPs.', icone: FileText, rota: '/portal/documentos', ativo: false, categoria: 'corporativo', color: 'bg-slate-500', favorito: false },
    { id: 9, codigo: 'SUPP', nome: 'Chamados', descricao: 'Suporte técnico e abertura de solicitações internas.', icone: LifeBuoy, rota: '/portal/chamados', ativo: false, categoria: 'corporativo', color: 'bg-amber-500', favorito: false },
  ];

  // Módulos agrupados por categoria para o Portal Hub
  const groupedModules = useMemo(() => ({
    corporativo: modulos.filter(m => m.categoria === 'corporativo'),
    operacional: modulos.filter(m => m.categoria === 'operacional'),
    gestao: modulos.filter(m => m.categoria === 'gestao')
  }), [modulos]);

  const { recentModules, addRecentModule } = useRecentModules(modulos);

  const handleModuleClick = (mod: Modulo) => {
    addRecentModule(mod.codigo);
    navigate(mod.rota);
  };

  return (
    <div className="space-y-16 py-4">
      <header>
        <h1 className="text-5xl font-black tracking-tighter text-slate-900 dark:text-white mb-4">
          Bom dia, <span className="text-brand-primary">Usuário</span>.
        </h1>
        <p className="text-xl text-slate-500 dark:text-slate-400 font-medium max-w-3xl leading-relaxed">
          Bem-vindo ao seu centro de trabalho corporativo. Aqui você encontra todas as ferramentas e aplicações autorizadas para sua função.
        </p>
      </header>

      <QuickAccessWidget 
        recentModules={recentModules} 
        onModuleClick={handleModuleClick} 
      />

      <section>
        <div className="flex items-center gap-4 mb-6">
          <h2 className="portal-eyebrow">
            Ecossistema Corporativo
          </h2>
          <div className="h-px flex-1 bg-slate-200 dark:bg-slate-800"></div>
        </div>

        <ApplicationGrid>
          {loading ? (
            Array.from({ length: 4 }).map((_, i) => (
              <ApplicationCardSkeleton key={i} />
            ))
          ) : (
            groupedModules.corporativo.map((mod) => (
              <ApplicationCard 
                key={mod.id}
                modulo={mod}
                onClick={() => handleModuleClick(mod)}
              />
            ))
          )}
        </ApplicationGrid>
      </section>

      <section>
        <div className="flex items-center gap-4 mb-6">
          <h2 className="portal-eyebrow">
            Operacional
          </h2>
          <div className="h-px flex-1 bg-slate-200 dark:bg-slate-800"></div>
        </div>

        <ApplicationGrid>
          {loading ? (
            Array.from({ length: 4 }).map((_, i) => (
              <ApplicationCardSkeleton key={i} />
            ))
          ) : (
            groupedModules.operacional.map((mod) => (
              <ApplicationCard 
                key={mod.id}
                modulo={mod}
                onClick={() => handleModuleClick(mod)}
              />
            ))
          )}
        </ApplicationGrid>
      </section>
    </div>
  );
};

export default PortalHome;