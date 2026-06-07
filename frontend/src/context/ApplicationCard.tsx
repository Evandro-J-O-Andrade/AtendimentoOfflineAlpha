import React from 'react';
import { LucideIcon, Star, Clock } from 'lucide-react';

interface ApplicationCardProps {
  modulo: {
    nome: string;
    descricao: string;
    icone: LucideIcon;
    color: string;
    ativo: boolean;
    favorito?: boolean;
    ultimoAcesso?: string;
  };
  onClick: () => void;
  onFavoriteToggle?: (e: React.MouseEvent) => void;
}

const ApplicationCard: React.FC<ApplicationCardProps> = ({ modulo, onClick, onFavoriteToggle }) => {
  const { nome, icone: Icon, color, descricao, ativo, favorito, ultimoAcesso } = modulo;

  return (
    <div className="relative group/card w-full">
      {/* Botão de Favorito (Posicionamento Absoluto) */}
      <button 
        onClick={(e) => {
          e.stopPropagation();
          onFavoriteToggle?.(e);
        }}
        className={`absolute top-4 right-4 z-10 p-2 rounded-full transition-all duration-300 ${
          favorito ? 'text-amber-400 bg-amber-50 shadow-sm' : 'text-slate-300 hover:text-amber-400 hover:bg-slate-50 opacity-0 group-hover/card:opacity-100'
        }`}
      >
        <Star size={18} fill={favorito ? "currentColor" : "none"} />
      </button>

      <button
        onClick={onClick}
        disabled={!ativo}
        className={`
          w-full flex flex-col items-center justify-center p-8 bg-white dark:bg-slate-900 rounded-3xl shadow-sm border border-slate-100 dark:border-slate-800/50 
          transition-all duration-500 hover:shadow-[0_20px_50px_rgba(0,0,0,0.05)] dark:hover:shadow-[0_20px_50px_rgba(0,0,0,0.3)]
          hover:-translate-y-1.5 active:scale-95 text-center
          ${ativo ? 'hover:border-brand-primary/50 cursor-pointer' : 'opacity-60 cursor-not-allowed'}
        `}
      >
        {/* Ícone com Efeito de Sombra Colorida */}
        <div className={`p-4 rounded-2xl ${color} text-white mb-5 group-hover:scale-110 transition-transform shadow-lg shadow-current/20`}>
          <Icon size={32} />
        </div>
        
        <h3 className="text-xl font-bold text-slate-800 dark:text-white tracking-tight leading-none">{nome}</h3>
        
        {descricao && (
          <p className="text-sm text-slate-500 dark:text-slate-400 mt-3 line-clamp-2 px-2 leading-relaxed">
            {descricao}
          </p>
        )}

        {/* Rodapé do Card: Status e Último Acesso */}
        <div className="mt-8 pt-6 border-t border-slate-50 dark:border-slate-800/50 w-full flex items-center justify-between text-[10px] font-bold uppercase tracking-widest">
          <span className={ativo ? 'text-emerald-500' : 'text-slate-400'}>
            {ativo ? '• Ativo' : '• Inativo'}
          </span>
          
          {ultimoAcesso && (
            <div className="flex items-center gap-1.5 text-slate-400">
              <Clock size={12} />
              <span>{ultimoAcesso}</span>
            </div>
          )}
        </div>
      </button>
    </div>
  );
};

export default ApplicationCard;