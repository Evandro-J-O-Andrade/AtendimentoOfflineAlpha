import { useAuth } from '@/apps/operacional/auth/AuthProvider';

interface PortalHeaderProps {
  empresa?: string;
}

/**
 * PortalHeader - New Wave Enterprise
 * Header do portal corporativo com nome do usuário e empresa.
 */
export default function PortalHeader({ empresa = "Tenant XYZ" }: PortalHeaderProps) {
  const { usuario, logout } = useAuth();

  return (
    <header className="flex items-center justify-between mb-10 pb-6 border-b border-slate-800">
      <div>
        <h1 className="text-3xl font-bold text-white">
          New Wave Enterprise
        </h1>
        <p className="text-slate-400 mt-1">
          Enterprise Management &amp; Analytics Platform
        </p>
      </div>

      <div className="flex items-center gap-4">
        <div className="text-right">
          <p className="text-white font-medium">
            Usuário: <span className="text-cyan-400">{usuario?.nome || usuario?.login}</span>
          </p>
          <p className="text-slate-500 text-sm">
            Empresa: <span className="text-slate-400">{empresa}</span>
          </p>
        </div>
        
        <button
          onClick={logout}
          className="px-4 py-2 bg-rose-500/10 hover:bg-rose-500/20 text-rose-400 rounded-xl font-medium transition-colors"
        >
          Sair
        </button>
      </div>
    </header>
  );
}