import React from 'react';

/**
 * Componente de Skeleton Loader para os cards de aplicação do Portal.
 * Utiliza a cor brand-primary nos elementos de destaque para reforçar o branding.
 */
const ApplicationCardSkeleton: React.FC = () => {
  return (
    <div className="flex flex-col items-center justify-center p-6 bg-white dark:bg-slate-900 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800">
      {/* Placeholder do Ícone: Destaque com tom da marca e pulsação */}
      <div className="w-16 h-16 rounded-xl bg-brand-primary/10 mb-4 flex items-center justify-center animate-pulse">
        <div className="w-8 h-8 rounded bg-brand-primary/20" />
      </div>
      
      {/* Placeholder do Título */}
      <div className="h-5 bg-slate-200 dark:bg-slate-700 rounded-full w-32 mb-4 animate-pulse" />
      
      {/* Placeholder da Descrição */}
      <div className="space-y-2 w-full flex flex-col items-center animate-pulse">
        <div className="h-2.5 bg-slate-100 dark:bg-slate-800 rounded-full w-10/12" />
        <div className="h-2.5 bg-slate-100 dark:bg-slate-800 rounded-full w-2/3" />
      </div>
    </div>
  );
};

export default ApplicationCardSkeleton;