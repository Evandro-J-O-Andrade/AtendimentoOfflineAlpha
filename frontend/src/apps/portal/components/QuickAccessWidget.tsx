import React from 'react';
import { Clock } from 'lucide-react';
import { Modulo } from '../../../shared/types/module';

interface QuickAccessWidgetProps {
  recentModules: Modulo[];
  onModuleClick: (mod: Modulo) => void;
}

const QuickAccessWidget: React.FC<QuickAccessWidgetProps> = ({ recentModules, onModuleClick }) => {
  if (!recentModules || recentModules.length === 0) return null;

  return (
    <section className="animate-in fade-in slide-in-from-top-4 duration-700">
      <div className="flex items-center gap-2 mb-4 text-slate-500 dark:text-slate-400">
        <Clock size={16} className="text-brand-primary" />
        <h2 className="text-xs font-bold uppercase tracking-widest">Acesso Rápido</h2>
      </div>
      
      <div className="flex flex-wrap gap-3">
        {recentModules.map((mod) => (
          <button
            key={mod.id}
            onClick={() => onModuleClick(mod)}
            className="flex items-center gap-3 px-4 py-2 bg-white dark:bg-slate-900 rounded-xl shadow-sm border border-slate-100 dark:border-slate-800 hover:border-brand-primary/30 hover:shadow-md transition-all group"
          >
            <div className={`p-1.5 rounded-lg ${mod.color} text-white group-hover:scale-110 transition-transform`}>
              <mod.icone size={14} />
            </div>
            <span className="text-sm font-semibold text-slate-700 dark:text-slate-200 group-hover:text-brand-primary transition-colors">
              {mod.nome}
            </span>
          </button>
        ))}
      </div>
    </section>
  );
};

export default QuickAccessWidget;