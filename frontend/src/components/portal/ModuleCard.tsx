import { useNavigate } from 'react-router-dom';
import { PortalModule } from '@/types/portal';

interface ModuleCardProps {
  module: PortalModule;
}

/**
 * ModuleCard - New Wave Enterprise
 * Card de módulo no portal corporativo.
 */
export default function ModuleCard({ module }: ModuleCardProps) {
  const navigate = useNavigate();

  const handleClick = () => {
    // Se requer contexto, navega para contexto primeiro
    if (module.requerContexto) {
      navigate('/contexto');
    } else {
      navigate(module.rota);
    }
  };

  return (
    <div
      onClick={handleClick}
      className="
        cursor-pointer
        rounded-2xl
        bg-slate-900
        border
        border-slate-800
        p-6
        hover:border-cyan-500
        transition
        group
      "
    >
      <div className="flex items-start justify-between mb-4">
        <div className="text-3xl">{module.icone}</div>
        <svg 
          className="w-5 h-5 text-slate-600 group-hover:text-cyan-400 transition-colors" 
          fill="none" 
          stroke="currentColor" 
          viewBox="0 0 24 24"
        >
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
        </svg>
      </div>

      <h3 className="text-white text-lg font-semibold">
        {module.nome}
      </h3>

      <p className="text-slate-400 mt-2 text-sm">
        {module.descricao}
      </p>
    </div>
  );
}