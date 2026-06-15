import React from 'react';

interface FooterProps {
  versao?: string;
}

export default function Footer({ versao = "1.0.0" }: FooterProps) {
  return (
    <footer className="h-10 flex justify-between items-center px-6 border-t border-slate-200 bg-white text-xs text-slate-500">
      <div className="flex gap-2 items-center">
        <span className="font-semibold">NEW WAVE PLATFORM</span>
        <span>v{versao}</span>
      </div>
      
      <div className="flex gap-2 items-center">
        <span className="font-mono opacity-70">SID 7A92F1</span>
      </div>
    </footer>
  );
}