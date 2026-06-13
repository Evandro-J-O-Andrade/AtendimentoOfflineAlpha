import { ReactNode } from "react";

interface HeaderProps {
    title: string;
    subtitle?: string;
    actions?: ReactNode;
}

export function Header({ title, subtitle, actions }: HeaderProps) {
    return (
        <header className="flex items-center justify-between mb-6 pb-4 border-b border-slate-200 dark:border-slate-800">
            <div>
                <h1 className="text-2xl font-bold text-slate-900 dark:text-white">{title}</h1>
                {subtitle && (
                    <p className="text-slate-500 dark:text-slate-400 mt-1">{subtitle}</p>
                )}
            </div>
            {actions && <div className="flex items-center gap-3">{actions}</div>}
        </header>
    );
}