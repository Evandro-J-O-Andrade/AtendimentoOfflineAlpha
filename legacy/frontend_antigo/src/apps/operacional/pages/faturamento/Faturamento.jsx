import React from 'react';
import { useNavigate } from 'react-router-dom';
import './Faturamento.css';

const Faturamento = () => {
  const navigate = useNavigate();
  return (
    <div className="faturamento-container">
      <header className="faturamento-header">
        <h1>💰 Faturamento</h1>
        <button onClick={() => navigate('/operacional')} className="btn-voltar">← Voltar</button>
      </header>
      <div className="faturamento-content">
        <section className="panel">
          <h2>📊 Painel de Faturamento</h2>
          <div className="stats-grid">
            <div className="stat-card"><h3>Produção Hoje</h3><p className="stat-number">R$ 45.000</p></div>
            <div className="stat-card"><h3>Contas Pendentes</h3><p className="stat-number">12</p></div>
            <div className="stat-card"><h3>Valor Pendente</h3><p className="stat-number">R$ 180.000</p></div>
          </div>
        </section>
      </div>
    </div>
  );
};
export default Faturamento;
