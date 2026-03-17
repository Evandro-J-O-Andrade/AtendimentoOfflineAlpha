import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import './Manutencao.css';

const Manutencao = () => {
  const navigate = useNavigate();
  const [chamados, setChamados] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    carregarDados();
  }, []);

  const carregarDados = async () => {
    try {
      setLoading(true);
      const token = localStorage.getItem('token');
      const response = await fetch('/api/operacional/manutencao', {
        headers: { 'Authorization': `Bearer ${token}` }
      });
      const data = await response.json();
      setChamados(data?.dados || []);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const getPrioridadeBadge = (prioridade) => {
    const map = {
      'BAIXA': { class: 'prio-baixa', text: 'Baixa' },
      'MEDIA': { class: 'prio-media', text: 'Média' },
      'ALTA': { class: 'prio-alta', text: 'Alta' },
      'URGENTE': { class: 'prio-urgente', text: 'Urgente' }
    };
    const s = map[prioridade] || { class: 'prio-default', text: prioridade };
    return <span className={`badge ${s.class}`}>{s.text}</span>;
  };

  const getStatusBadge = (status) => {
    const map = {
      'ABERTO': { class: 'badge-aberto', text: 'Aberto' },
      'EM_ANDAMENTO': { class: 'badge-andamento', text: 'Em Andamento' },
      'AGUARDANDO_PECA': { class: 'badge-pecas', text: 'Aguard. Peça' },
      'FINALIZADO': { class: 'badge-finalizado', text: 'Finalizado' },
      'CANCELADO': { class: 'badge-cancelado', text: 'Cancelado' }
    };
    const s = map[status] || { class: 'badge-default', text: status };
    return <span className={`badge ${s.class}`}>{s.text}</span>;
  };

  return (
    <div className="manutencao-container">
      <header className="manutencao-header">
        <h1>🔧 Manutenção</h1>
        <button onClick={() => navigate('/operacional')} className="btn-voltar">← Voltar</button>
      </header>

      <div className="manutencao-content">
        <section className="panel">
          <div className="panel-header">
            <h2>📋 Chamados de Manutenção</h2>
            <button className="btn-novo">+ Novo Chamado</button>
          </div>

          <table className="data-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Equipamento</th>
                <th>Local</th>
                <th>Problema</th>
                <th>Prioridade</th>
                <th>Status</th>
                <th>Abertura</th>
              </tr>
            </thead>
            <tbody>
              {chamados.map((ch) => (
                <tr key={ch.id}>
                  <td>{ch.id}</td>
                  <td>{ch.equipamento}</td>
                  <td>{ch.local}</td>
                  <td>{ch.descricao}</td>
                  <td>{getPrioridadeBadge(ch.prioridade)}</td>
                  <td>{getStatusBadge(ch.status)}</td>
                  <td>{ch.data_abertura}</td>
                </tr>
              ))}
              {chamados.length === 0 && (
                <tr><td colSpan="7" className="no-data">Nenhum chamado</td></tr>
              )}
            </tbody>
          </table>
        </section>
      </div>
    </div>
  );
};

export default Manutencao;
