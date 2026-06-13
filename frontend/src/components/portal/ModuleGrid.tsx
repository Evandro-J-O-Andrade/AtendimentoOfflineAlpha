import { PortalModule } from '@/types/portal';
import ModuleCard from './ModuleCard';

interface ModuleGridProps {
  modules: PortalModule[];
  title?: string;
}

/**
 * ModuleGrid - New Wave Enterprise
 * Grid de módulos no portal corporativo.
 */
export default function ModuleGrid({ modules, title }: ModuleGridProps) {
  return (
    <section className="mb-10">
      {title && (
        <h2 className="text-slate-400 text-sm font-bold uppercase tracking-widest mb-4">
          {title}
        </h2>
      )}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
        {modules.map(module => (
          <ModuleCard key={module.id} module={module} />
        ))}
      </div>
    </section>
  );
}