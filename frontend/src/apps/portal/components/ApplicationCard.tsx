import React from 'react';
import { Modulo } from '../../../shared/types/module';

interface ApplicationCardProps {
  modulo: Modulo;
  onClick: (rota: string) => void;
}

const ApplicationCard: React.FC<ApplicationCardProps> = ({ modulo, onClick }) => {
  const { nome, descricao, icone: Icon, ativo, color = 'indigo', rota } = modulo;

  return (
    <button
      onClick={() => ativo && onClick(rota)}
      disabled={!ativo}
      className={`portal-module-card portal-accent-${color} ${!ativo ? 'opacity-60 grayscale cursor-not-allowed' : ''}`}
    >
      <div className="portal-module-card-top">
        <div className="portal-module-icon">
          <Icon size={24} />
        </div>
        <div className={`portal-status ${ativo ? 'active' : 'inactive'}`}>
          {ativo ? 'Disponível' : 'Em Breve'}
        </div>
      </div>
      
      <div className="portal-module-copy">
        <h2>{nome}</h2>
        <p>{descricao}</p>
      </div>

      <div className="portal-module-footer">
        <div className="portal-module-action">
          {ativo ? 'Acessar Módulo' : 'Solicitar Acesso'}
        </div>
        <div className="portal-context-flag">
          <div className="w-1.5 h-1.5 rounded-full bg-slate-300"></div>
          SaaS
        </div>
      </div>
    </button>
  );
};

export default ApplicationCard;