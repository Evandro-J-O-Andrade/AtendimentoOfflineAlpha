import React, { useState, useRef, useEffect } from 'react';
import { Bell, Info, AlertTriangle, CheckCircle } from 'lucide-react';

interface Notification {
  id: number;
  title: string;
  message: string;
  type: 'info' | 'warning' | 'success';
  date: string;
  read: boolean;
}

/**
 * Widget de Notificações Corporativas.
 * Gerencia a exibição e interação com alertas institucionais e do sistema.
 */
export const NotificationWidget: React.FC = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [notifications, setNotifications] = useState<Notification[]>([
    {
      id: 1,
      title: 'Atualização de Sistema',
      message: 'O módulo de faturamento passará por manutenção às 22h.',
      type: 'info',
      date: '10 min atrás',
      read: false,
    },
    {
      id: 2,
      title: 'Meta Batida',
      message: 'Parabéns! A meta de atendimentos da unidade foi atingida.',
      type: 'success',
      date: '1 hora atrás',
      read: false,
    },
    {
      id: 3,
      title: 'Estoque Baixo',
      message: 'O item "Luvas de Procedimento" está abaixo do nível de segurança.',
      type: 'warning',
      date: '2 horas atrás',
      read: true,
    },
  ]);

  const unreadCount = notifications.filter(n => !n.read).length;
  const widgetRef = useRef<HTMLDivElement>(null);

  // Fechar ao clicar fora
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (widgetRef.current && !widgetRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const markAllAsRead = () => {
    setNotifications(notifications.map(n => ({ ...n, read: true })));
  };

  const getIcon = (type: string) => {
    switch (type) {
      case 'warning': return <AlertTriangle size={16} className="text-amber-500" />;
      case 'success': return <CheckCircle size={16} className="text-emerald-500" />;
      default: return <Info size={16} className="text-blue-500" />;
    }
  };

  return (
    <div className="relative" ref={widgetRef}>
      <button 
        type="button"
        className="portal-icon-button" 
        onClick={() => setIsOpen(!isOpen)}
        aria-label="Notificações"
      >
        <Bell size={20} />
        {unreadCount > 0 && <span className="portal-notification-dot"></span>}
      </button>

      {isOpen && (
        <div className="absolute right-0 mt-2 w-80 sm:w-96 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl shadow-2xl z-50 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
          <div className="p-4 border-b border-slate-100 dark:border-slate-800 flex items-center justify-between bg-slate-50/50 dark:bg-slate-800/50">
            <h3 className="font-bold text-slate-900 dark:text-white flex items-center gap-2 text-sm">
              Notificações
              {unreadCount > 0 && (
                <span className="bg-indigo-600 text-white text-[10px] px-1.5 py-0.5 rounded-full">
                  {unreadCount}
                </span>
              )}
            </h3>
            <button 
              type="button"
              onClick={markAllAsRead}
              className="text-[10px] font-bold uppercase tracking-wider text-indigo-600 dark:text-indigo-400 hover:underline"
            >
              Marcar lidas
            </button>
          </div>

          <div className="max-h-[400px] overflow-y-auto">
            {notifications.length === 0 ? (
              <div className="p-8 text-center text-slate-400">
                <Bell size={32} className="mx-auto mb-2 opacity-20" />
                <p className="text-sm">Nenhuma notificação por aqui.</p>
              </div>
            ) : (
              <div className="divide-y divide-slate-100 dark:divide-slate-800">
                {notifications.map((notification) => (
                  <div 
                    key={notification.id} 
                    className={`p-4 flex gap-3 transition-colors hover:bg-slate-50 dark:hover:bg-slate-800/50 ${!notification.read ? 'bg-indigo-50/30 dark:bg-indigo-500/5' : ''}`}
                  >
                    <div className="mt-1 shrink-0">{getIcon(notification.type)}</div>
                    <div className="flex-1 space-y-1">
                      <div className="flex justify-between gap-2">
                        <p className={`text-sm font-bold ${notification.read ? 'text-slate-700 dark:text-slate-300' : 'text-slate-900 dark:text-white'}`}>
                          {notification.title}
                        </p>
                        <span className="text-[10px] text-slate-400 whitespace-nowrap">{notification.date}</span>
                      </div>
                      <p className="text-xs text-slate-500 dark:text-slate-400 leading-relaxed">
                        {notification.message}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>

          <div className="p-3 border-t border-slate-100 dark:border-slate-800 text-center">
            <button type="button" className="text-xs font-semibold text-slate-500 hover:text-indigo-600 transition-colors">
              Ver todas as notificações
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default NotificationWidget;