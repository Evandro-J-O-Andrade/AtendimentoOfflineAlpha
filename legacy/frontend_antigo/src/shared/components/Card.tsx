import { ReactNode } from "react";

interface CardProps {
    children: ReactNode;
    className?: string;
}

export function Card({ children, className = "" }: CardProps) {
    return (
        <div className={`bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-6 ${className}`}>
            {children}
        </div>
    );
}

export function CardHeader({ children, className = "" }: CardProps) {
    return <div className={`mb-4 ${className}`}>{children}</div>;
}

export function CardContent({ children, className = "" }: CardProps) {
    return <div className={className}>{children}</div>;
}

export function CardFooter({ children, className = "" }: CardProps) {
    return (
        <div className={`mt-4 pt-4 border-t border-slate-100 dark:border-slate-800 ${className}`}>
            {children}
        </div>
    );
}