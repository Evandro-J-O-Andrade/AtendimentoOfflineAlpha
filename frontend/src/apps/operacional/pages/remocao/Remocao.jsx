import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import './Remocao.css';

const Remocao = () => {
  const navigate = useNavigate();
  const [remocoes, setRemocoes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [erro, setErro] = useState(null);

  useEffect(() => {
    carregarDados();
  }, []);

  const carregarDados = async () => {
    try {
      setLoading(true);
      const token = localStorage.getItem('token');
      const response = await fetch('/api/operacional/remocao', {
        headers: { 'Authorization': `Bearer ${token}` }
      });
      const data = await response.json();
      setRemocoes(data?.dados || []);
      setErro(null);
    } catch (err) {
      setErro('Erro ao carregar dados: ' + err.message);
    } finally {
      setLoading(false);
    }
  };

  const iniciarRemocao = async (id) => {
    try {
      const token = localStorage.getItem('token');
      await fetch(`/api/operacional/remocao/${id}/iniciar`, {
        method: 'POST',
        headers: { 'Authorization': `Bearer ${token}` }
      });
      carregarDados();
    } catch (err) {
      alert('Erro ao iniciar remoção');
    }
  };

  const finalizarRemocao = async (id) => {
    try {
      const token = localStorage.getItem('token');
      await fetch(`/api/operacional/remocao/${id}/finalizar`, {
        method: 'POST',
        headers: { 'Authorization': `Bearer ${token}` }
      });
      carregarDados();
    } catch (err) {
      alert('Erro ao finalizar remoção');
    }
  };

  const getStatusBadge = (status) => {
    const statusMap = {
      'SOLICITADA': { class: 'badge-solicitada', text: 'Solicitada' },
      'AGENDADA': { class: 'badge-agendada', text: 'Agendada' },
      'EM_TRANSITO': { class: 'badge-transito', text: 'Em Trânsito' },
      'NO_LOCAL': { class: 'badge-no-local', text: 'No Local' },
      'EM_REMOCAO': { class: 'badge-remocao', text: 'Em Remoção' },
      'FINALIZADA': { class: 'badge-finalizada', text: 'Finalizada' },
      'CANCELADA': { class: 'badge-cancelada', text: 'Cancelada' }
    };
    const s = statusMap[status] || { class: 'badge-default', text: status };
    return <span className={`badge ${s.class}`}>{s.text}</span>;
  };

  if (loading) {
    return (
      <div className="remocao-container">
        <div className="loading">Carregando...</div>
      </div>
    );
  }

  return (
    <div className="remocao-container">
      <header className="remocao-header">
        <h1>🚑 Remoção</h1>
        <button onClick={() => navigate('/operacional')} className="btn-voltar">
          ← Voltar
        </button>
      </header>

      {erro && <div className="erro-mensagem">{erro}</div>}

      <div className="remocao-content">
        <section className="panel">
          <div className="panel-header">
            <h2>📋 Solicitações de Remoção</h2>
            <button className="btn-novo">+ Nova Solicitação</button>
          </div>
          
          <table className="data-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Paciente</th>
                <th>Origem</th>
                <th>Destino</th>
                <th>Data/Hora</th>
                <th>Tipo</th>
                <th>Status</th>
                <th>Ações</th>
              </tr>
            </thead>
            <tbody>
              {remocoes.map((rem) => (
                <tr key={rem.id}>
                  <td>{rem.id}</td>
                  <td>{rem.paciente_nome}</td>
                  <td>{rem.origem}</td>
                  <td>{rem.destino}</td>
                  <td>{rem.data_hora}</td>
                  <td>{rem.tipo_remocao}</td>
                  <td>{getStatusBadge(rem.status)}</td>
                  <td>
                    {rem.status === 'SOLICITADA' && (
                      <button onClick={() => iniciarRemocao(rem.id)} className="btn-acao btn-iniciar">
                        Iniciar
                      </button>
                    )}
                    {rem.status === 'EM_TRANSITO' && (
                      <button onClick={() => finalizarRemocao(rem.id)} className="btn-acao btn-finalizar">
                        Finalizar
                      </button>
                    )}
                  </td>
                </tr>
              ))}
              {remocoes.length === 0 && (
                <tr>
                  <td colSpan="8" className="no-data">
                    Nenhuma solicitação de remoção
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </section>

        <section className="panel">
          <h2>📊 Estatísticas</h2>
          <div className="stats-grid">
            <div className="stat-card">
              <h3>Pendentes</h3>
              <p className="stat-number">{remocoes.filter(r => r.status === 'SOLICITADA').length}</p>
            </div>
            <div className="stat-card">
              <h3>Em Trânsito</h3>
              <p className="stat-number">{remocoes.filter(r => r.status === 'EM_TRANSITO').length}</p>
            </div>
            <div className="stat-card">
              <h3>Finalizadas Hoje</h3>
              <p className="stat-number">{remocoes.filter(r => r.status === 'FINALIZADA').length}</p>
            </div>
          </div>
        </section>
      </div>
    </div>
  );
};

export default Remocao;
