import React from 'react';
import { useNavigate } from 'react-router-dom';
import './Gasoterapia.css';

const Gasoterapia = () => {
  const navigate = useNavigate();

  return (
    <div className="gasoterapia-container">
      <header className="gasoterapia-header">
        <h1>💨 Gasoterapia</h1>
        <button onClick={() => navigate('/operacional')} className="btn-voltar">← Voltar</button>
      </header>
      <div className="gasoterapia-content">
        <section className="panel">
          <h2>📋 Controle de Gases Medicinais</h2>
          <p>Gestão de consumo de gases medicinais (Oxigênio, Ar Comprimido, Vácuo)</p>
          <div className="cards-grid">
            <div className="card">
              <h3>🔵 Oxigênio</h3>
              <p className="stat">450 m³</p>
              <p>Consumo hoje</p>
            </div>
            <div className="card">
              <h3>⚪ Ar Comprimido</h3>
              <p className="stat">120 m³</p>
              <p>Consumo hoje</p>
            </div>
            <div className="card">
              <h3>🟡 Vácuo</h3>
              <p className="stat">80 m³</p>
              <p>Consumo hoje</p>
            </div>
          </div>
        </section>
      </div>
    </div>
  );
};

export default Gasoterapia;
