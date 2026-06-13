import React from 'react';
import { useNavigate } from 'react-router-dom';
import './AssistenciaSocial.css';

const AssistenciaSocial = () => {
  const navigate = useNavigate();
  return (
    <div className="assistencia-container">
      <header className="assistencia-header">
        <h1>👥 Assistência Social</h1>
        <button onClick={() => navigate('/operacional')} className="btn-voltar">← Voltar</button>
      </header>
      <div className="assistencia-content">
        <section className="panel">
          <h2>📋 Atendimentos Sociais</h2>
          <p>Gestão de atendimento social, visitas, e encaminhamentos</p>
          <div className="stats-grid">
            <div className="stat-card"><h3>Hoje</h3><p className="stat-number">12</p></div>
            <div className="stat-card"><h3>Pendentes</h3><p className="stat-number">5</p></div>
            <div className="stat-card"><h3>Encaminhamentos</h3><p className="stat-number">8</p></div>
          </div>
        </section>
      </div>
    </div>
  );
};
export default AssistenciaSocial;
