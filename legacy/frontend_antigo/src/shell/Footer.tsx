import React from 'react';
import { useRuntime } from '@/app/providers/RuntimeContext';

export default function Footer() {
  const { runtime } = useRuntime();

  const entidadeNome = runtime?.entidade?.nome || "NEW WAVE PLATFORM";
  const sistemaNome = runtime?.sistema?.nome || "";
  const unidadeNome = runtime?.unidade?.nome || "";
  const localNome = runtime?.local?.nome || "";

  const contextoDisplay = [sistemaNome, unidadeNome, localNome].filter(Boolean).join(" • ");

  return (
    <footer className="h-10 flex justify-between items-center px-6 border-t border-slate-200 bg-white text-xs text-slate-500">
      <div className="flex gap-4 items-center">
        <div className="flex items-center gap-2">
          <span className="font-semibold">NEW WAVE PLATFORM</span>
          <span>v{runtime?.versao || "1.0.0"}</span>
        </div>
        
        {contextoDisplay && (
          <>
            <span className="text-slate-400">|</span>
            <span className="text-slate-600">{entidadeNome}</span>
            <span className="text-slate-400">•</span>
            <span className="text-slate-600">{contextoDisplay}</span>
          </>
        )}
      </div>

      <div className="flex gap-4 items-center">
        <span className="font-mono opacity-70">SID: {runtime?.sessao?.codigo || "---"}</span>
        <span className="text-green-600">● ONLINE</span>
      </div>
    </footer>
  );
}