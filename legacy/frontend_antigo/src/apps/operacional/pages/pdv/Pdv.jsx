import React from 'react';
import { useNavigate } from 'react-router-dom';
import './Pdv.css';

const Pdv = () => {
  const navigate = useNavigate();
  return (
    <div className="pdv-container">
      <header className="pdv-header">
        <h1>💳 PDV - Ponto de Venda</h1>
        <button onClick={() => navigate('/operacional')} className="btn-voltar">← Voltar</button>
      </header>
      <div className="pdv-content">
        <section className="panel">
          <h2>💰 Vendas</h2>
          <p>Gestão de vendas e pagamentos</p>
        </section>
      </div>
    </div>
  );
};
export default Pdv;
